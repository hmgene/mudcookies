

input ="%INPUT%"
output="%OUTPUT%"

input=read.table(input,header=T)
# this will contain id, and cellranger_dir columns 
# you can also include other inventory columns to be used in harmony group.by.var 

d.list=list();
j=1; for( i in 1:nrow(input)){
        f=input[i,]$cellranger_dir 
        id=input[i,]$id
        if(file.exists(f)){
                d=Read10X(data.dir=f)
                d.list[[j]]= CreateSeuratObject(counts=d,project=id,min.cells=3,min.features=200)
                j = j + 1
        }else{
                warning(paste0(f," doesnot exist!"));
        }
}


d = merge(d.list[[1]],d.list[2:length(d.list)])
d[["percent.mt"]] <- PercentageFeatureSet(d, pattern = "^MT-")
# non-stringent filtering
d = subset(d, subset = nFeature_RNA > 200 & percent.mt < 25 )

d = NormalizeData(d, normalization.method = "LogNormalize") 
d = FindVariableFeatures(d, selection.method = "vst", nfeatures = 2000)
d = ScaleData(d, vars.to.regress = "percent.mt")
d = RunPCA(d, pc.genes= VariableFeatures(object = d))

# you can redefine group.by.var
# theta controlls overcorrection (0: no correction, 2: default, >2: more correction)
d=RunHarmony(d, group.by.vars=c("orig.ident"),assay.use="RNA", theta=2) 

# Note, UMAP uses harmony reduction not PCA
d=RunUMAP(d, reduction="harmony",dims=1:50)
# more dimensions find unknown cell types
d=FindNeighbors(d, reduction="harmony",dims=1:50)
# fine-resolution needs bottom-up cell identification (CI)
# many publications prefer to top-down CI (use resolution=0.3 .., and do sub-clustering later)
d=FindClusters(d,graph.name="RNA_snn", resolution=0.8)

# don't forget to save!!
saveRDS(d,paste0(output,".rds"))
