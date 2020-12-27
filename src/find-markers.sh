#!/bin/bash
usage="
$BASH_SOURCE <seurat> <output_prefix> [nproc]
 <output_prefix>: use the same name as the <seurat> if you want to overwrite 
 [nproc]: number of processes (default=1) 
"
if [ $# -lt 1 ];then echo "$usage"; exit; fi
nproc=${3:-1}
maxsize="${4:-16}000*1024^2"

cat<<'EOF' | sed "s#INPUT#$1#" | sed "s#OUTPUT#$2#"  \
| sed "s#NPROC#$nproc#" \
| sed "s#MAXSIZE#$maxsize#" 

# ref: https://satijalab.org/seurat/v3.0/future_vignette.html
input="INPUT"
nproc=NPROC
maxsize=eval("MAXSIZE")
output="OUTPUT"

require(dplyr)
require(Seurat)


d=readRDS(input)
#<!--parallelization required -->
options(future.globals.maxSize=maxsize)
if( input.nproc > 1){
	require(future)
	plan("multicore",workers=nproc)
}

d.m = FindAllMarkers(d, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
write.csv(d.m,paste0(output,"_diffexp_","res",input.res,".csv"))

EOF
