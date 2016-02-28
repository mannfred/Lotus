
### De novo assembly of RNA-seq reads into contigs using Trinity (v 2.0.6)


[Check out Trinity on GitHub](https://github.com/trinityrnaseq/trinityrnaseq/wiki)
<br />
<br />

---


We have two transcriptomes to analyse for differential expression: <br />
yellow (LFY_R1.fastq and LFY_R2.fastq) and red (LFR_R1.fastq and LFR_R2.fastq) <br />
<br />

#####First things first:
Ensure your .fastq files are of equal length.
```
~/Lotus filicaulis Project/RNA seq reads$ gunzip -c LFY_R2.fastq.gz | wc -l
```
<br />
If .fastq files are unequal in length (can happen when downloading published RNA-seq datasets), please see [Eric Normandeau's python script](https://github.com/enormandeau/Scripts/blob/master/fastqCombinePairedEnd.py) to re-sync trimmed .fastq files or [Simon Andrews'](https://github.com/s-andrews) perl script which I've hosted [here](https://github.com/mannfred/Lotus/blob/master/Trinity/fastq_sanity_check.md) 
<br />
---
##### De novo assembly

Commands were run in the Ubuntu 14.04 shell
```
./Trinity --seqType fq --SS_lib_type FR --max_memory 20G  --left LFY_R1.fastq.gz,LFR_R1.fastq.gz --right LFY_R2.fastq.gz,LFR_R2.fastq.gz --CPU 6
```
output: Trinity.fasta
<br />
<br />
Relevant for UBC ZCU Cluster Users:
```
/Linux/trinity/./Trinity --seqType fq --max_memory 42G --left All_GN_R1.fastq --right All_GN_R2.fastq --CPU 16 --output ~/Genlisea-trinity --normalize_reads --normalize_max_read_cov 30 

```
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
<br />
<br />

##### Construct BLAST database 

Trinity contigs assembled *de novo* have unique Trinity IDs, but need to be annotated to be interpreted biologically.
Build a BLASTn database using the CDS library of your desired organism to identify your contigs, I used the *Lotus japonicus* CDS library published by the Kazusa DNA Research Institute at ftp://ftp.kazusa.or.jp/pub/lotus/lotus_r3.0/ 
```
makeblastdb -in ~/path/Lj3.0_cds.ffn.gz  -out LotusDB -dbtype nucl -parse_seqids
```
output: LotusDB (database file usable by BLAST)
<br />
<br />
##### BLASTn of Trinity contigs against database
```
blastn -query Trinity.fasta.adj    -out BLASTN_LJ-Trinity.txt  -db LotusDB -outfmt 6 -evalue 1e-4
```
output: BLASTN_LJ-Trinity.txt containing *all* BLAST matches to Trinity contigs
<br />
<br />
##### Extract 'best' BLASTn result 
I extracted the 'best' BLAST-Trinity matches based on bitscore, though one could extract the best hit based on percent match, or some other criteria. 
```
sort -k1,1 -k12,12nr -k11,11n ~/path/Lotus_BLAST_Database/BLASTN_LJ-Trinity.txt | sort -u -k1,1 --merge > BLASTN_LJ-Trinity_BESTHIT.txt
```
output: BLASTN_LJ-Trinity.txt containing the top BLAST-contig matches. This file can be used to annotate contigs identified in the differential expression test, and is necessary for gene ontology enrichment analysis. If you used a lenient expectation value when BLASTing (like I did) then I recommend double checking any contigs of interest by aligning the amino acid sequence of your contig with the amino acid sequences of its putative homologs. 




