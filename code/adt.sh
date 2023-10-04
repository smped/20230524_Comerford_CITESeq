#!/bin/bash
#SBATCH -p skylake
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=01:00:00   
#SBATCH --mem=64GB       
#SBATCH -o /hpcfs/users/a1018048/20230524_Comerford_CITESeq/slurm/%x_%j.out
#SBATCH -e /hpcfs/users/a1018048/20230524_Comerford_CITESeq/slurm/%x_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=stephen.pederson@adelaide.edu.au

## Activate the mamba environment
source /home/a1018048/.bashrc
mamba activate /hpcfs/users/a1018048/envs/alevin-fry

WD=/hpcfs/users/a1018048/20230524_Comerford_CITESeq
## The adt index has already been created, so we just need to align
salmon alevin \
  -l ISR \
  -i ${WD}/data/external/adt_index \
  -1 ${WD}/data/fastq/merged/23-00585_S2_R1_001.fastq.gz \
  -2 ${WD}/data/fastq/merged/23-00585_S2_R2_001.fastq.gz \
  --read-geometry 2[11-25] \
  --bc-geometry 1[1-16] \
  --umi-geometry 1[17-28] \
  -o ${WD}/output/adt_mapping \
  -p 16 \
  --sketch

## The next step is the permit list
alevin-fry generate-permit-list \
  -d fw \
  -i ${WD}/output/adt_mapping \
  -o ${WD}/output/adt_quant \
  -k

## Collate
alevin-fry collate \
  -r ${WD}/output/adt_mapping \
  -i ${WD}/output/adt_quant \
  -t 16

## Quant
alevin-fry quant \
  -m data/external/t2g_adt.tsv \
  -i ${WD}/output/adt_quant \
  -o ${WD}/output/adt_quant/crlike \
  -r cr-like \
  -t 16 \
  --use-mtx

mamba deactivate