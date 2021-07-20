## input parameters (project_name. matrix_directory)
input="
LB6 /w/LB6/outs/filtered_feature_bc_matrix/
RLL /w/RLL/outs/filtered_feature_bc_matrix/
"
output="LB6_RLL"
nproc=6

##
library(Seurat)
library(parallel)
inp=read.table(text=input)
l=mclapply(X=1:nrow(inp), mc.cores=nproc,FUN=function(i) {
        expression_matrix <- Read10X(data.dir = inp[i,]$V2)
        seurat_object = CreateSeuratObject(counts = expression_matrix, project=inp[i,]$V1)
        seurat_object
})

d=merge(l[[1]],l[2:length(l)])
d[["percent.mt"]] <- PercentageFeatureSet(d, pattern = "^MT-")

d=NormalizeData(d, normalization.method = "LogNormalize", scale.factor = 10000)
d=FindVariableFeatures(d, selection.method = "vst", nfeatures = 2000)
d=ScaleData(d)
d=RunPCA(d, features = VariableFeatures(object = d))
print(d[["pca"]], dims = 1:5, nfeatures = 5)
VizDimLoadings(d, dims = 1:2, reduction = "pca")
d <- JackStraw(d, num.replicate = 100)
d <- ScoreJackStraw(d, dims = 1:20)
#JackStrawPlot(d, dims = 1:15)

d <- FindNeighbors(d, dims = 1:20)
d <- FindClusters(d, resolution = 0.5)
d <- RunUMAP(d, dims = 1:20)
saveRDS(d,paste0(output,".rds"))

## markers
tmp=mclapply(X = names(table(d$seurat_clusters)), mc.cores=nproc,FUN = function(x) {
        m=FindMarkers(d,ident.1=x, only.pos=T)
        write.csv(m[order(-m$avg_log2FC),],file=paste0(output,"_marker_",x,".csv"))
})



