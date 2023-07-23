# 20230524_Comerford_CITESeq

## Initial Data Exploration

The files in `data/fastq/raw` are 

```bash
[4.0K]  data/fastq/raw
├── [5.8G]  23-00584_S1_L001_R1_001.fastq.gz
├── [ 14G]  23-00584_S1_L001_R2_001.fastq.gz
├── [6.3G]  23-00584_S1_L002_R1_001.fastq.gz
├── [ 15G]  23-00584_S1_L002_R2_001.fastq.gz
├── [2.1G]  23-00585_S2_L001_R1_001.fastq.gz
├── [4.3G]  23-00585_S2_L001_R2_001.fastq.gz
├── [2.6G]  23-00585_S2_L002_R1_001.fastq.gz
└── [5.5G]  23-00585_S2_L002_R2_001.fastq.gz
```

- Perhaps the first step would be to merge fastq files from L001 and L002
- Clearly R1 is the 28bp barcode + UMI whilst R2 is the transcript
    + `23-00584_S1` appears most likely to be the RNA-Seq
	+ `23-00585_S2` appears to be the antibody derived sequnces

### Merge files

```bash
cd data/fastq/raw/
cat 23-00584_S1_L00*R1* > ../merged/23-00584_S1_R1_001.fastq.gz
cat 23-00584_S1_L00*R2* > ../merged/23-00584_S1_R2_001.fastq.gz
cat 23-00585_S2_L00*R1* > ../merged/23-00585_S2_R1_001.fastq.gz
cat 23-00585_S2_L00*R2* > ../merged/23-00585_S2_R2_001.fastq.gz
tree -sh ../mergd
```

	[4.0K]  merged
	├── [ 12G]  23-00584_S1_R1_001.fastq.gz
	├── [ 29G]  23-00584_S1_R2_001.fastq.gz
	├── [4.7G]  23-00585_S2_R1_001.fastq.gz
	└── [9.7G]  23-00585_S2_R2_001.fastq.gz

```bash
cd ../merged
```

## Key Notes

- ADT: Antibody-Derived Tags
- HTO: Hash antibody tag oligos

It's currently unclear which library contains which information

### Library Sizes

```bash
zcat 23-00584_S1_R1_001.fastq.gz | \
	sed -n '1~4p' | \
	wc -l
```

	576,854,434

```bash
zcat 23-00585_S2_R1_001.fastq.gz | \
	sed -n '1~4p' | \
	wc -l
```

	224,884,874

### R1 Structure

- R1 is 28nt
    + 16nt *cell barcode*
	+ 12nt *UMI*
- These sequences will not be specifically defined

Estimates of unique cell numbers may be obtainable from R1 libraries

```bash
# zcat 23-00584_S1_R1_001.fastq.gz | \
#   egrep '^[AGCT]{16}' | \
#   sed -r 's/(.{16}).+/\1/g' | \
#   sort | \
#   uniq | \
#   wc -l
```
(Out of memory)


### R2 Structure

- R2 is 90nt
    + 10nt ???
	+ 16nt barcode
	+ 9nt??
	+ `GCTTTAAGGCCGGTCCTAGCAA...`

Checking for ADT sequences will be relevant for R2

## Running Checks

A prudent idea may be to check for the presence of the hashes for each mouse.
It should also be noted that given there are only 3 mice, the HTO are included in the ADT library.

### Hashtag 1:

```bash
zcat 23-00584_S1_R2_001.fastq.gz | egrep -c '^[ACGT]{10}ACCCACCAGTAAGAC'
```
	922

```bash
zcat 23-00585_S2_R2_001.fastq.gz | egrep -c '^[ACGT]{10}ACCCACCAGTAAGAC'
```

	2,828,363

### Hashtag 2:

```bash
zcat 23-00584_S1_R2_001.fastq.gz | egrep -c '^[ACGT]{10}GGTCGAGAGCATTCA'
```
	115

```bash
zcat 23-00585_S2_R2_001.fastq.gz | egrep -c '^[ACGT]{10}GGTCGAGAGCATTCA'
```
	503,332

	
### Hashtag 3:

```bash
zcat 23-00584_S1_R2_001.fastq.gz | egrep -c '^[ACGT]{10}CTTGCCGCATGTCAT'
```
	148

```bash
zcat 23-00585_S2_R2_001.fastq.gz | egrep -c '^[ACGT]{10}CTTGCCGCATGTCAT'
```
	790,776

### CCR4

```bash
zcat 23-00584_S1_R2_001.fastq.gz | egrep -c '^[ACGT]{10}TTCATGTGTTTGTGC'
```

	3,442

```bash
zcat 23-00585_S2_R2_001.fastq.gz | egrep -c '^[ACGT]{10}TTCATGTGTTTGTGC'
```

	18,166,841

## Conclusion

The ADT samples are definitely 23-00585_S2, leaving 23-00584_S1 as the sample containing RNA transcripts.
