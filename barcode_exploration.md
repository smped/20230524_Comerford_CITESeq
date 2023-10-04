# Exploration of barcodes

Preliminary exploration of the data revealed that the RNA-Seq libraries contained ~17,000 unique cell barcodes.
This is in line with expecations given that ~20,000 cells were sequenced.

The combined ADT/HTO library, however, contained cell-barcodes for ~70,000 cell barcodes, which is far in excess of what is expected.
When comparing these two sets of cell-barcodes, only 63 were found to be in common.

The current assumption is that the cell-barcodes in the RNA-Seq library are correct but something has gone awry with the ADT/HTO library.
As such, the cell-barcodes from all reads (excluding N-bases) were obtained from the RNA-Seq library

```bash
cd data/fastq/merged
zcat 23-00584_S1_R1_001.fastq.gz | \
egrep  '^[ACGT]{16}' | \
sed -r 's/(^[ACGT]{16}).+/\1/g' | \
sort | \
uniq -c | \
sort -n > rnaseq_barcodes.txt
```

## TTGTTCACATGAGATA

As the most numerous cell-barcode amongst the RNA-Seq barcodes, this was used to explore the ADT/HTO library.

1. Reads with this cell barcode were identified were found
2. HTO/ADT barocdes from these 12 reads were checked

```bash
zcat 23-00585_S2_R1_001.fastq.gz | egrep -n '^TTGTTCACATGAGATA'
```

	37177210:TTGTTCACATGAGATATCACTATACGTA
	98058278:TTGTTCACATGAGATATAACAATCTCTG
	98949966:TTGTTCACATGAGATAACCATGGGTAAC
	114311870:TTGTTCACATGAGATATGACAGCACAAA
	151762714:TTGTTCACATGAGATACGTCACGTATTA
	268174278:TTGTTCACATGAGATATCAACGATTTGT
	311024674:TTGTTCACATGAGATAGATCCCAAAGTT
	395209642:TTGTTCACATGAGATACGTATCCGGTGT
	665624382:TTGTTCACATGAGATATTACTTCTCGTA
	671253134:TTGTTCACATGAGATATTACATGAGCGA
	684214926:TTGTTCACATGAGATAAAGAGAAGTTTT
	720028030:TTGTTCACATGAGATACTTACCCCATGC


```bash
zcat 23-00585_S2_R2_001.fastq.gz | sed -n '37177210p' | sed -r 's/^[ACGTN]{10}(.{15}).*/\1/g'
```

	ACCCACCAGTAAGAC

```bash
egrep 'ACCCACCAGTAAGAC'  ../../external/adt.tsv | sed -r 's/.+://g'
```

	HTO1     ACCCACCAGTAAGAC


Using the same process gave the following summary

| Line | Barcode | Match | Comment |
|:---- |:------- |:----- |:------- |
| 37177210   | ACCCACCAGTAAGAC | HTO1 | |
| 98058278   | ACCCACCAGTAAGAC | HTO1 | |
| 98949966   | ACCAACCAGTAAGAC | HTO1 | C/A Sequencing error at pos 4 |
| 114311870  | ACCCACCAGTAAGAC | HTO1 | |
| 151762714  | ACCCACCAGTAAGAC | HTO1 | |
| 268174278  | ATCATGTGTTAGTTC |      | No match found |
| 311024674  | ACCCACCAGTAAGAC | HTO1 | |
| 395209642  | ACCCACCAGTAAGAC | HTO1 | |
| 665624382  | ACCCACCAGTAAGAC | HTO1 | |
| 671253134  | ACCCACCAGTAAGAC | HTO1 | |
| 684214926  | ACCCACCAGTAAGAC | HTO1 | |
| 720028030  | ACCCACCAGTAAGAC | HTO1 | |

Table: All barcodes from these reads map to HTO1, with the exception of 1 unmatched barcode

## CTACATTAGCGTTAGG

```bash
zcat 23-00585_S2_R1_001.fastq.gz | egrep -n '^CTACATTAGCGTTAGG'
```

	212350334:CTACATTAGCGTTAGGGGTATAGGCGGT

```bash
zcat 23-00585_S2_R2_001.fastq.gz | sed -n '212350334p' | sed -r 's/^[ACGTN]{10}(.{15}).*/\1/g'
```

	TTAAAGAGATTCTGC


```bash
egrep 'TTAAAGAGATTCTGC'  ../../external/adt.tsv | sed -r 's/.+://g'
```

Despite 229616 reads algining from the RNA-seq, only one read in the ADT/HTO set matched this cell-barcode.
There was no match to any of the ADT/HTO barcodes.

Searching amongst the R1 reads for the barcode at any position also revealed only one match 

```bash
zcat 23-00585_S2_R1_001.fastq.gz | egrep -m10 '.CTACATTAGCGTTAGG'
```

	CTACATTGATCTCTACATTAGCGTTAGG

Searching amongst the R2 reads showed no match.
Searching amongst the R1 libraries but removing the first or last nucleotides also showed one more match, but not in the expected position.
