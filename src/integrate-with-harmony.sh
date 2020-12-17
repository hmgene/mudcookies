#!/bin/bash
usage="
	$BASH_SOURCE <merged.seurat.objects> <output.seurat.object>
"
if [ $# -lt 1 ];then echo "$usage"; exit; fi

cat<<'EOF'| sed s#OUTPUT#$2# | sed s#INPUT#$1#  > $2.rcmd
input="INPUT";
output="OUTPUT"; 


library(Seurat)
library(cowplot)
library(harmony)
library(stringr)
library(dplyr)

d = readRDS(input);
d[["percent.mt"]] = PercentageFeatureSet(d, pattern = "^MT-")
d = NormalizeData(d, normalization.method = "LogNormalize", scale.factor = 10000)
d = FindVariableFeatures(d, selection.method = "vst", nfeatures = 2000)
d = ScaleData(d, vars.to.regress = "percent.mt")
d = RunPCA(d, pc.genes= VariableFeatures(object = d))

d=RunHarmony(d, group.by.vars=c("orig.ident"),assay.use="RNA", theta=2,sigma=0.1);#,nclust=10);

d=RunUMAP(d, reduction="harmony",dims=1:20)
d=FindNeighbors(d, reduction="harmony",dims=1:20)
d=FindClusters(d,graph.name="RNA_snn", resolution=0.5)
saveRDS(d,paste0(output,".rds"))


EOF
R --no-save -f $2.rcmd
