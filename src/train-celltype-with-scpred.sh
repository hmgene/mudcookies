#!/bin/bash
usage="
$BASH_SOURCE <seurat.obj> <scpred.obj> [nproc]
<seurat.obj> : cell_type annotation must be in meta.data
<scpred.obj> : scpred object 
[nproc] : multi-cores (default 2)
"; if [ $# -lt 1 ];then echo "$usage";exit; fi

ip=$1
op=${2:-"out_scpred.rds"}
nproc=${3:-2}

cat << 'EOF' | sed "s#INPUT#$ip#" | sed "s#OUTPUT#$op#" \
| sed "s#NPROC#$nproc#" >$op.rcmd

# ref: https://powellgenomicslab.github.io/scPred/articles/introduction.html 
library("scPred")
library("Seurat")
library("magrittr")
require("doParallel")
require("mda")

input = "INPUT"
output= "OUTPUT"
nproc=NPROC

# test set
if( !file.exists( input ) && input == "test" ){
	d = scPred::pbmc_1
}else{
	d = readRDS(input);
}

# query data must use the same norm. 
d = d %>%
  NormalizeData() %>%
  FindVariableFeatures() %>%
  ScaleData() %>%
  RunPCA()

d = getFeatureSpace(d, "cell_type") # default svmRadial

cl = makePSOCKcluster(nproc)
registerDoParallel(cl)
d = trainModel(d, model= "mda", allowParallel=T)
# retraining : d<- trainModel(d, model = "mda", reclassify = c("cMono", "ncMono"))
stopCluster(cl)

scpred=get_scpred(d)
saveRDS(scpred, file=output)
# new_embedding_aligned vs new_embedding : after and before harmony

EOF

R --no-save -f $op.rcmd 
