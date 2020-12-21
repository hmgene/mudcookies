require(dplyr)
require(Seurat)

input="../harmony/bladder-harmony-1.rds"
output="bladder-harmony-1"
input.res=0.2

d=readRDS(input)
d=FindClusters(d,graph.name="RNA_snn", resolution=input.res)
d.m = FindAllMarkers(d, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
write.csv(d.m,paste0(output,"_diffexp_","res",input.res,".csv"))

top10 =  d.m %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
d1 = d[, sample(colnames(d), size =2000, replace=F)]
pdf(file=paste0(output,"_diffexp_","res",input.res,"top10.pdf"))
DoHeatmap(d1,features=top10$gene) + NoLegend() +
        theme(axis.text.y = element_text(size = 5))
dev.off()
