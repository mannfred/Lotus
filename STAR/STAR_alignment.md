### RNA-seq alignment to *Lotus japonicus* using STAR (v 2.4)


[Check out STAR on GitHub](https://github.com/alexdobin/STAR)
<br />
<br />

---


We have two transcriptomes to analyse for differential expression: <br />
yellow (LFY_R1.fastq and LFY_R2.fastq) and red (LFR_R1.fastq and LFR_R2.fastq) <br />
<br />
I sourced the reference genome and gene annotation file for *Lotus japonicus*  from [Kazusa](http://www.kazusa.or.jp/lotus/)
##### Prepare genome reference

Commands were run in the Ubuntu 14.04 shell
```
 ./rsem-prepare-reference --gtf Lj3.0_gene_models_geneids.gtf ~/path/rsem/Lj3.0_pseudomol.fna Lotus --star --star-path ~/path/STAR/bin/Linux_x86_64/
```
<br />
 
##### Align reads to the genome reference and calculate expression
```
./rsem-calculate-expression --star --star-path ~/path/STAR/bin/Linux_x86_64/ --gzipped-read-file -p 8 ~/path/Trinity2/LFR_R1.fastq.gz,~/path/Trinity2/LFR_R2.fastq.gz ~/path/rsem/Lotus REDexpression
```
<br />
*see Trinity instructions to build expression matrix and calculate differential expression. 