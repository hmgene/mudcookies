#!/bin/bash
usage="
$BASH_SOURCE <seurat> <output_prefix> [[resolution (default=0.5)] [nproc]]
 <output_prefix>: use the same name as the <seurat> if you want to overwrite 
"
if [ $# -lt 1 ];then echo "$usage"; exit; fi
res=${3:-0.5}
nproc=${4:-1}

cat<<'EOF'| sed s#INPUT.RES#$res# | sed s#OUTPUT#$2# | sed s#INPUT#$1#\
| sed "s#NPROC#$nproc#"  > $2.rcmd

input="INPUT"
input.res=INPUT.RES
nproc=NPROC
output="OUTPUT"
require(Seurat)
d=readRDS(input)

if( nproc > 1 ){
	require("future");
	plan("multiprocess",workers=nproc);
}
d=FindNeighbors(d, reduction="harmony",dims=1:50)
d=FindClusters(d,graph.name="RNA_snn", resolution=input.res)
saveRDS(d,paste0(output,".rds"))
EOF

R --no-save -f $2.rcmd
