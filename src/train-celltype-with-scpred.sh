#!/bin/bash
usage="
$BASH_SOURCE <seurat.obj> <scpred.obj>
<seurat.obj> : cell_type annotation must be in meta.data
<scpred.obj> : scpred object 
"; if [ $# -lt 1 ];then echo "$usage";exit; fi

ip=$1
op=${2:-"out_scpred.rds"}

cat << 'EOF' | sed "s#INPUT#$ip#" | sed "s#OUTPUT#$op#" >$op.rcmd
# for details read https://powellgenomicslab.github.io/scPred/articles/introduction.html 
library("scPred")
library("Seurat")
library("magrittr")

input = "INPUT"
output= "OUTPUT"

# test set
if( !file.exists( input ) && input == "test" ){
	d = scPred::pbmc_1
}else{
	d = readRDS(input);
}

# this is why we stick to the baseline norm 
d = d %>%
  NormalizeData() %>%
  FindVariableFeatures() %>%
  ScaleData() %>%
  RunPCA()

d = getFeatureSpace(d, "cell_type") # default svmRadial
d = trainModel(d)
# retraining : d<- trainModel(d, model = "mda", reclassify = c("cMono", "ncMono"))

scpred=get_scpred(d)
saveRDS(scpred, file=output)
# new_embedding_aligned vs new_embedding : after and before harmony

EOF

R --no-save -f $op.rcmd 
