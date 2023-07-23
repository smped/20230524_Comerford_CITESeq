#!/bin/bash
#SBATCH -p skylake
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=02:00:00   
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
REF=/hpcfs/users/a1018048/refs/grcm39

## The splici index has already been created, so we just need to align
salmon alevin \
  -l ISR \
  -i ${REF}/grcm39_splici_idx \
  -1 ${WD}/data/fastq/merged/23-00584_S1_R1_001.fastq.gz \
  -2 ${WD}/data/fastq/merged/23-00584_S1_R2_001.fastq.gz \
  --read-geometry 2[1-end] \
  --bc-geometry 1[1-16] \
  --umi-geometry 1[17-28] \
  -o ${WD}/output/rna_mapping \
  -p 16 \
  --sketch

## The next step is the permit list
alevin-fry generate-permit-list \
  -d fw \
  -i ${WD}/output/rna_mapping \
  -o ${WD}/output/rna_quant \
  -k

## Collate
alevin-fry collate \
  -r ${WD}/output/rna_mapping \
  -i ${WD}/output/rna_quant \
  -t 16

## Quant
alevin-fry quant \
  -m ${REF}/transcriptome_splici_fl86/transcriptome_splici_fl86_t2g_3col.tsv \
  -i ${WD}/output/rna_quant \
  -o ${WD}/output/rna_quant/crlike \
  -r cr-like \
  -t 16 \
  --use-mtx

mamba deactivate