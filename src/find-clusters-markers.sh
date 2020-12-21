#!/bin/bash
usage="
$BASH_SOURCE <seurat> <output_prefix> [resolution (default=0.5)]
 <output_prefix>: use the same name as the <seurat> if you want to overwrite 
"
if [ $# -lt 1 ];then echo "$usage"; exit; fi
res=${3:-0.5}

cat<<'EOF'| sed s#INPUT.RES#$res# | sed s#OUTPUT#$2# | sed s#INPUT#$1#  #> $2.rcmd

input="INPUT"
input.res=INPUT.RES
output="OUTPUT"

require(dplyr)
require(Seurat)

d=readRDS(input)
d=FindClusters(d,graph.name="RNA_snn", resolution=input.res)
saveRDS(d,paste0(output,".rds"))

d.m = FindAllMarkers(d, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
write.csv(d.m,paste0(output,"_diffexp_","res",input.res,".csv"))

top10 =  d.m %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
d1 = d[, sample(colnames(d), size =2000, replace=F)]
pdf(file=paste0(output,"_diffexp_","res",input.res,"top10.pdf"))
DoHeatmap(d1,features=top10$gene) + NoLegend()
dev.off()
EOF
