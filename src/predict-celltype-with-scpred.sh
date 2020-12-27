#!/bin/bash
usage="
$BASH_SOURCE <seurat.obj> <scpred.obj> <output>
<seurat.obj>: cell_type annotation must be in meta.data
<scpred.obj>: default( out )
<output>: output_prefix ( overwrite if it is the same as <seurat.obj>
"; if [ $# -lt 1 ];then echo "$usage";exit; fi

ip1=${1:-"test"}
ip2=${2:-"test"}
op=${3:-"out"}

cat<<'EOF' | sed "s#INPUT1#$ip1#" | sed "s#INPUT2#$ip2#" | sed "s#OUTPUT#$op#" 
# for details read https://powellgenomicslab.github.io/scPred/articles/introduction.html 
library("scPred")
library("Seurat")
library("magrittr")

input1= "INPUT1"
input2= "INPUT2"
output= "OUTPUT"

query = readRDS(input1)
query = NormalizeData(query) ## this must be same as the reference
scpred = readRDS(input2)

query = scPredict(query, scpred)
saveRDS(paste0(output,".rds"))


## some useful queries
## this is a merged space which may be different from that of query space alone
# query <- RunUMAP(query, reduction = "scpred", dims = 1:30) 
## scpred_prediction is after harmony while scpred is before harmony
# DimPlot(query, group.by = "scpred_prediction", label = TRUE, repel = TRUE)
# crossTab(query, "cell_type", "scpred_prediction")
## avoid aligning 
# query <- scPredict(query, reference, recompute_alignment = FALSE)
## different prob. threshold 
# query <- scPredict(query, reference, recompute_alignment = FALSE, threshold = 0.9)
## parallel training
# library(doParallel)
# cl <- makePSOCKcluster(2)
# registerDoParallel(cl)
# reference <- trainModel(reference, model = "mda", allowParallel = TRUE)
## rerunning w/o Seurat obj 
# scpred <- get_scpred(reference)
# query <- scPredict(query, scpred)
EOF
