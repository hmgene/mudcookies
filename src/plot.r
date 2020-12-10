myboxplot = function(df,features,group){
	require("tibble")
	require("dplyr")
	require("reshape2")
	
	fea=match(features,row.names(d))
	features=features[!is.na(fea)]
	df$RNA@data[features,] %>%
        data.frame(check.names=F) %>% rownames_to_column( "feature") %>%
        filter(feature %in% features) %>%
        melt(id.var="feature") %>%
        filter(value > 0) %>%
        mutate(group=df@meta.data[[ group ]][ match(variable,colnames(df))]) %>%  
        mutate(feature=factor(feature,levels=features)) %>%
        ggplot(aes(x=feature, y=value,fill=feature)) +       
        geom_boxplot() + facet_wrap(~group)
}

#
# orig.ident x clusters : cell counts 
#
countcell=function(seurat.obj){
	require(reshape2)
	require(tibble)

	seurat.obj@meta.data %>%
	group_by(orig.ident,seurat_clusters) %>% count %>% 
	dcast(orig.ident ~ seurat_clusters,fill=0) %>%
	column_to_rownames("orig.ident")
}


#
# Heatmap of markers
#  markers: (feautre, type) columns

myheatmap=function(seuratobj, markers){
	require(ComplexHeatmap)
	require(Matrix.utils)
	require(tibble)
	require(dplyr)
	avg = t(seuratobj$RNA@data) %>%    
		aggregate.Matrix( groupings=seuratobj@meta.data$seurat_clusters, fun = "mean") %>%              
		t() %>% data.frame(check.names=F) %>% rownames_to_column(var="feature")
	avg1=merge(avg,markers,by="feature")
	avg.m=avg1[,2:(ncol(avg))]
	row.names(avg.m) = make.names(avg1$feature,unique=TRUE)
	ha=rowAnnotation( type=avg1$type )
	Heatmap((avg.m), row_split=avg1$type,row_title_rot=0,
		row_names_gp = gpar(fontsize = 8)) # right_annotation=ha)
}

