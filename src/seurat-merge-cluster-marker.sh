## input parameters
idir="data"
out="data/3n3p" ## big files > 100Mb
nproc=6

# ref: https://satijalab.org/seurat/articles/integration_large_datasets.html
library(data.table)
library(stringr)
library(Seurat)
library(parallel)
library("R.utils")


# ref: https://satijalab.org/seurat/articles/integration_introduction.html
l=mclapply(X =  list.files(idir,pattern=".txt.gz"), mc.cores=nproc, FUN = function(x) {
        y=fread(paste0(idir,"/",x)); z=y[,-1]; row.names(z)=y$GENE;
        z=CreateSeuratObject(count=z, project=str_extract(x,"GSM\\d+"));
        #z=NormalizeData(z,verbose=F)
        #z=FindVariableFeatures(z, verbose=F)
        return(z)
})




nproc=6
# ref: https://satijalab.org/seurat/articles/integration_introduction.html
l=mclapply(X =  list.files(idir,pattern=".txt.gz"), mc.cores=nproc, FUN = function(x) {
        y=fread(paste0(idir,"/",x)); z=y[,-1]; row.names(z)=y$GENE;
        z=CreateSeuratObject(count=z, project=str_extract(x,"GSM\\d+"));
        #z=NormalizeData(z,verbose=F)
        #z=FindVariableFeatures(z, verbose=F)
        return(z)
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
JackStrawPlot(d, dims = 1:15)

d <- FindNeighbors(d, dims = 1:20)
d <- FindClusters(d, resolution = 0.5)
d <- RunUMAP(d, dims = 1:20)
saveRDS(d,paste0(out,".rds"))


## markers
tmp=mclapply(X = names(table(d$seurat_clusters)), mc.cores=nproc,FUN = function(x) {
        m=FindMarkers(d,ident.1=x, only.pos=T)
        write.csv(m[order(-m$avg_log2FC),],file=paste0(out,"_marker_",x,".csv"))
})



