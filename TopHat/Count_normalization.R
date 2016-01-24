library(edgeR)

setwd('~/path/TopHat2.1.0')
list.files('~/path/TopHat2.1.0')

data<-read.csv('TopHat.counts.matrix.csv', header=TRUE)
head(data)
group<-subset(data, select= -c(X))
head(group)
d<-DGEList(group)

d<-calcNormFactors(d)
norm.counts<-cpm(d)*1e6

head(norm.counts)

write.csv(norm.counts, file='Normalized.TopHat.counts.csv')
