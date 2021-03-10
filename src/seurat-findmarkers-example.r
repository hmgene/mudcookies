## select target resolution
input="seurat-object.rds"
output="out.csv"
nproc=1

d=readRDS(input)
## select a target cluster result
Idents(object=d) = d@meta.data$RNA_snn_res.0.2

## modify nproc > 1 if parallization needed
if( nproc > 1 ){
        require("future");
        plan("multiprocess",workers=nproc);
}
x=FindAllMarkers(d)
write.csv(x,file=output)
