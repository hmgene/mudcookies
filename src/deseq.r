# make this reusable by implementing input, output

library(googlesheets4)
library(stringr)
library(dplyr)
library("VennDiagram")
library(Matrix.utils)

## preprocess : clean column names and make groups
d0=read.table("count.txt",check.name=F,header=T)
colnames(d0)=str_replace(colnames(d0),".genes.results","")
colnames(d0)=str_replace(colnames(d0),"-","_")

gene= unlist( lapply(row.names(d0), function(x1) str_split(x1,"_")[[1]][2]))
d0 = d0 %>% aggregate.Matrix(groupings=gene)

d=d0[,grep("MDSC",colnames(d0))]
g= paste0(str_match(colnames(d),"VPK|WT"),"_",str_match(colnames(d),"splenic|tumor"))
v=data.frame(id=colnames(d),g=g)

## run DESeq2 
dds=DESeqDataSetFromMatrix(as.matrix(round(d)), DataFrame(v), ~0+ g)
dds= dds[rowSums(counts(dds)) >= 10,]
dds = DESeq(dds)
rn=resultsNames(dds)
#"gVPK_splenic" "gVPK_tumor"   "gWT_splenic"  "gWT_tumor"

rld <- rlog(dds, blind=TRUE)
plotPCA(rld, intgroup="id")
pheatmap(cor(assay(rld)))


## Wald test
ctr="gWT_splenic"
trt="gVPK_splenic"
ctr="gWT_tumor"
trt="gVPK_tumor"
cont=rep(0,length(rn))
cont[ rn == ctr ] = -1; cont[ rn == trt ] = 1
res=results(dds,contrast=cont,alpha=0.5)
ntd=assay(normTransform(dds))
o=order(res$pvalue)
pheatmap(t(scale(t( ntd[o,][1:100,]))),fontsize_row=5)
#de=list()
