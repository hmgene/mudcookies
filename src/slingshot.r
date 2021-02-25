#
# trajectory with selected 1000 cells
#
x=VariableFeatures(d)
y=d$RNA@data[x,]
e=apply(y,2,mean)

j=match( data.table(id=colnames(y), e=e, c=d$orig.ident)[order(-e,c),head(.SD,100),by=c]$id, colnames(y) )
w=Embeddings(d,"harmony")[j,]
c=d$orig.ident[j]


my_color <- brewer.pal(8,"Set2")
names(my_color) <- unique(names(table(c)))

        ggplot()+ geom_point(aes(x = x, y = y,col=color)) +
        scale_color_manual(labels=names(my_color),values=as.character(my_color))

x = data.frame(x=w[,1],y=w[,2],color=my_color[c])
plot(x$x,x$y, col = my_color[c], pch=16, asp = 1)
legend("topright",legend = names(my_color), fill = my_color)
lines(sds, lwd=2, type = 'lineages', col = c("black"))

plot(reducedDim(sds), col = my_color[c], pch = 16, cex = 0.5)
lines(sds, lwd = 2, type = 'lineages', col = 'black')

library(slingshot)
sds <- slingshot(w, clusterLabels = c, start.clus = "Lee-1", stretch = 0)

library(ggbeeswarm)
data.frame(x=slingPseudotime(sds)[,1],y=factor(c),c=my_color[c]) %>%
        filter(!is.na(x)) %>%
        ggplot(aes(x=x,y=y,colour=c)) +
         scale_color_manual(labels=names(my_color),values=as.character(my_color)) +
         geom_quasirandom(groupOnX = FALSE) + theme_classic()
