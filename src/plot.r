myboxplot = function(df,feature,group){
	df$RNA@data[feature,] %>%
        data.frame(check.names=F) %>% rownames_to_column( "feature") %>%
        filter(feature %in% features) %>%
        melt(id.var="feature") %>%
        filter(value > 0) %>%
        mutate(group=df@meta.data[[ group ]][ match(variable,colnames(df))]) %>%  
        mutate(feature=factor(feature,levels=features)) %>%
        ggplot(aes(x=feature, y=value,fill=feature)) +       
        geom_boxplot() + facet_wrap(~group)
}
