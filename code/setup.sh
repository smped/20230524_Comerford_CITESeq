#! /bin/bash

## All commands in this script were run manually

## A conda environment was setup
mamba create -p ../envs/alevin-fry -c bioconda alevin-fry salmon

## The environment was then activated and the adt file indexed
## The file adt.tsv was formed manually
mamba activate alevin-fry
cd data/external/
salmon index -t adt.tsv -i adt_index --features -k7
cd ../..

## In order to prepare the genome, a `splici` index is needed, as per:
## https://combine-lab.github.io/alevin-fry-tutorials/2021/improving-txome-specificity/
## This was also performed in it's own folder

## For the quant stage a spoofed t2g_adt.tsv file is needed for transcript
## to gene mappings. Not really relevant but required for the workflow
awk '{print $1"\t"$1;}' data/external/adt.tsv > data/external/t2g_adt.tsv
