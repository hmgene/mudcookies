## select target resolution
input="seurat-object.rds"
output="out.csv"

d=readRDS(input)
## select a target cluster result
Idents(object=d) = d@meta.data$RNA_snn_res.0.2
## need parallization
x=FindAllMarkers(d)
write.csv(x,file=output)
