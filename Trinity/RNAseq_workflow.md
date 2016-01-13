### De novo assembly of RNA-seq reads into contigs using Trinity (v 2.0.6)

<<<<<<< HEAD
[Check out Trinity on GitHub](https://github.com/trinityrnaseq/trinityrnaseq/wiki)
=======
[Check out Trinity on GitHub](https://github.com/trinityrnaseq/trinityrnaseq/wiki) 
>>>>>>> origin/master
<br />
<br />

---


We have two transcriptomes to analyse for differential expression: <br />
yellow (LFY_R1.fastq and LFY_R2.fastq) and red (LFR_R1.fastq and LFR_R2.fastq) <br />
<br />

##### De novo assembly

Commands were run in the Ubuntu 14.04 shell
```
./Trinity --seqType fq --SS_lib_type FR --max_memory 20G  --left LFY_R1.fastq.gz,LFR_R1.fastq.gz 
	  --right LFY_R2.fastq.gz,LFR_R2.fastq.gz --CPU 6
```
output: Trinity.fasta
<br />
<br />

##### Concatanate Trinity contig headers
```
cat ~/path/Trinity.fasta | cut -f 1 -d “ “ > Trinity.fasta.adj
```
output: Trinity.fasta.adj
<br />
<br />
##### Calculate expression as counts per contig (RSEM)

```
cd ~/path/Trinity/util

./align_and_estimate_abundance.pl --seqType fq --left ~/path/LFR_R1.fastq --right ~/path/LFR_R2.fastq --transcripts   ~/path/trinity_out_dir/Trinity.fasta.adj --output_prefix LFR 	--est_method RSEM --aln_method bowtie --trinity_mode --prep_reference
```
output: LFR.genes.results and LFR.isoforms.results<br />
repeat for all other samples (ex: LFY_R1.fastq and LFY_R2.fastq) 
<br />
<br />
##### Build matrix to combine gene expression data from all samples
```
./abundance_estimates_to_matrix.pl --est_method RSEM --out_prefix Trinity_trans LFY.genes.results LFR.genes.results
```
output: Trinity_trans.counts.matrix (counts) and Trinity_trans.TMM.fpkm.matrix (fpkm normalized)
<br />
<br />
##### Calculate differential expression (edgeR)
```
cd ~/path/Trinity/Analysis/DifferentialExpression/
./run_DE_analysis.pl --matrix ~/Downloads/Trinity2/util/Trinity_trans.counts.matrix --method edgeR
```
output: Trinity_trans.counts.matrix.LFR_vs_LFY.edgeR.DE_results
