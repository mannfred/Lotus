####Import differential expression results from edgeR####

setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity')

Lotus<-read.csv('Trinity_trans_2.counts.matrix.LFR2_vs_LFY2.edgeR.csv', header=TRUE) 
head(Lotus)



#### Create subset of genes differentially expressed at yellow stage####

LotusSUBSET<-subset(Lotus, FDR<0.0500) #subset of Lotus with only significant rows
head(LotusSUBSET)


samp1SIG<-subset(LotusSUBSET, logFC>0) #subsetting my FDR subset to include only fold changes greater than 0 
#(less than 0 indicates red stage is higher expressed)
head(samp1SIG) #samp1SIG is a subset of Lotus with logFC greater than 0 and all FDR<0.05

write.csv(samp1SIG, file='edgeR_results_LFYHIGHER_Sep30_2015.csv') 



####annotate samp1SIG with Lotus 2.5 BLAST results#### 
setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity') 

#import differentially expressed genes at yellow stage of floral colour change
LotusYELLOW<-read.csv('edgeR_results_LFYHIGHER_Sep30_2015.csv', header=TRUE) 
head(LotusYELLOW) 

#import Trinity contig-BLAST lookup table
setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/BLAST Data')
ResultsBLAST<-read.csv('BLASTN_LJ2.5-Trinity_BESTHIT.csv', header=TRUE) 
#besthits extracted in Linux shell (see Trinity RNA-seq instructions)


#remove isoform information from Trinity IDs (using genes.results file from edgeR)
ResultsBLAST$Trinity_ID = sapply(strsplit(paste(ResultsBLAST$Trinity_ID), "_i"), function(x)x[[1]])
head(ResultsBLAST)

#annotate differentially expressed Trinity contigs
LotusYELLOW$Lotus_ID<-ResultsBLAST$Lotus_ID[match(LotusYELLOW$Trinity_ID, ResultsBLAST$Trinity_ID)]
head(LotusYELLOW)

write.csv(LotusYELLOW, file='edgeR_results_LFYHIGHER_Annotated_Nov7_2015.csv')
#now ready to export to AgriGO for ontology term enrichment analysis 



####Post-AgriGO: Match genes of interest (from AgriGO) to their respective Trinity contigs####

#import annotated diffexp Trinity contigs
setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/')
Annotated_yellow<-read.csv('edgeR_results_LFYHIGHER_Annotated_Nov7_2015.csv', header=TRUE)
head(ResultsBLAST_yellow)

#import a gene list associated with some enriched GO term (example: Flavonoid bionsythetic process)
setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/AgriGO Genes Trinity')

Flav<-read.csv('Flavonoid.csv', header=TRUE)
head(Flav)

#match Flavonoid genes to their Trinity contig by 'Lotus_ID' column
library(dplyr)
FlavANNOTATED<-inner_join(Flav, Annotated_yellow, by='Lotus_ID') 
#(this is different than just simply matching because there may be several
#Trinity contigs that match to one Lotus gene)

#remove uneccesary colums
head(FlavANNOTATED)
FlavANNOTATED$X<-NULL 
FlavANNOTATED$PValue<-NULL 
FlavANNOTATED$logCPM<-NULL


write.csv(FlavANNOTATED, file='Flavonoid Annotated.csv')



####Adding in Soybean BLAST results for functional annotation####

setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/BLAST Data')

#import Soybean-Trinity contig BLAST lookup table
SoybeanBLAST<-read.csv('BLASTN_Soy-Trinity_BESTHIT.csv', header=TRUE)
head(SoybeanBLAST)

#remove isoform tags
SoybeanBLAST$Trinity_ID = sapply(strsplit(paste(SoybeanBLAST$Trinity_ID), "_i"), function(x)x[[1]])
head(SoybeanBLAST)

#import Enriched GO Term gene list 
setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/AgriGO Genes Trinity')
FlavonoidANNOTATED<-read.csv('Flavonoid Annotated.csv', header=TRUE) 


#insert Soybean IDs into Gene Term Enrichment data set
FlavANNOTATED$Soybean_ID<-SoybeanBLAST$Soybean_ID[match(FlavANNOTATED$Trinity_ID, SoybeanBLAST$Trinity_ID)]
head(FlavANNOTATED)

write.csv(FlavANNOTATED, file='Flavonoid Annotated.csv')



####add FPKM info####
setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/Expression Data')

yellowFPKM<-read.csv('LFY2_FPKM.csv', header=TRUE)
redFPKM<-read.csv('LFR2_FPKM.csv', header=TRUE)

setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/AgriGO Genes Trinity')
#import AgriGO gene lists

FlavANNOTATED$yellow_FPKM<-yellowFPKM$FPKM[match(FlavANNOTATED$Trinity_ID, yellowFPKM$gene_id)]
FlavANNOTATED$red_FPKM<-redFPKM$FPKM[match(FlavANNOTATED$Trinity_ID, redFPKM$gene_id)]
head(FlavANNOTATED)
write.csv(FlavANNOTATED, file='Flavonoid Annotated.csv')


####add LogFC info####
setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/OutputTrinity/')

redlogFC<-read.csv('edgeR_results_LFRHIGHER_Annotated_Nov6_2015.csv', header=TRUE)
head(redlogFC$logFC)

FlavANNOTATED$logFC<-redlogFC$logFC[match(FlavANNOTATED$Trinity_ID, redlogFC$Trinity_ID)]
head(FlavANNOTATED)

write.csv(FlavANNOTATED, file='Flavonoid Annotated.csv')
