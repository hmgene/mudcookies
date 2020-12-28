#!/bin/bash
usage="
$BASH_SOURCE <seurat.rds> <output.cvs> [nproc] [maxsize (Gbyte)]
 <output_prefix>: use the same name as the <seurat> if you want to overwrite 
 [nproc]: number of processes (default=1) 
"
if [ $# -lt 1 ];then echo "$usage"; exit; fi


ip=$1
op=$2
nproc=${3:-1}
maxsize="${4:-16}000*1024^2"

#mkdir -p ${op%/*}

cat<<'EOF' | sed "s#INPUT#$ip#" \
| sed "s#OUTPUT#$op#" \
| sed "s#NPROC#$nproc#" \
| sed "s#MAXSIZE#$maxsize#"  > $op.rcmd

# ref: https://satijalab.org/seurat/v3.0/future_vignette.html
input="INPUT"
nproc=NPROC
maxsize=eval("MAXSIZE")
output="OUTPUT"

require(dplyr)
require(Seurat)
require(parallel)

d=readRDS(input)
mn = mclapply( names(table(d$seurat_clusters)), function(x) {
	y=FindMarkers(d, ident.1=x, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
	data.frame(feature=row.names(y),cluster=x,y)
})
m=data.frame(Reduce(rbind,mn))
write.csv(m,output)
EOF

R --no-save -f $op.rcmd
