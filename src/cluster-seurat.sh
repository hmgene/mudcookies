#!/bin/bash
usage="
$BASH_SOURCE <input_seurat.obj> <output_seurat.obj> [resolution ] [nproc]
 [resolution] : default 0.5
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
saveRDS(d,output)
EOF
cat $2.rcmd
#R --no-save -f $2.rcmd
