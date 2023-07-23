#!/bin/bash
#SBATCH -p skylake
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=04:00:00   
#SBATCH --mem=16GB       
#SBATCH -o /hpcfs/users/a1018048/20230524_Comerford_CITESeq/slurm/%x_%j.out
#SBATCH -e /hpcfs/users/a1018048/20230524_Comerford_CITESeq/slurm/%x_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=stephen.pederson@adelaide.edu.au

source /home/a1018048/.bashrc
module load FastQC/0.12.1-Java-17.0.6

fastqc \
  -o /hpcfs/users/a1018048/20230524_Comerford_CITESeq/output/fastqc \
  --noextract \
  --nogroup \
  -t 8 \
  /hpcfs/users/a1018048/20230524_Comerford_CITESeq/data/fastq/merged/*fastq.gz

