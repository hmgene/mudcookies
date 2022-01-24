
setwd("~/RNAseq/Trapp/WM_microglia/GMline_vs_WMline/")
#rd <- read.table("WTvsTREM2_MIC_Rosaline.txt", header=T, sep="\t")

rd <- read.table("GMline_vs_WMline_byCountsDeSeq_adjP005_v2.txt", sep='\t', header= T)
#rd <- read.table("Mic_D12_KOvsWT_rosaline2.txt", sep='\t', header= T)
#rd <- read.table("Mic_D28_KOvsWT_rosaline2.txt", sep='\t', header= T)

#rd <- read.table("WTvsTREM2_MAC_Rosaline2.txt", sep='\t', header= T)
#rd <- read.table("WTvsTREM2_MACDay12_Rosaline2.txt", sep='\t', header= T)
#rd <- read.table("WTvsTREM2_MACDay28_Rosaline2.txt", sep='\t', header= T)







p <- ggplot(data=rd, aes(x=log2FoldChange, y=-log10(pvalue))) + geom_point()
ggplot(data=rd, aes(x=log2FoldChange, y=-log10(pvalue))) + geom_point() + theme_minimal()
de<-rd
ggplot(data=rd, aes(x=log2FoldChange, y=-log10(pvalue))) + geom_point() + theme_minimal()
p2 <- p + geom_vline(xintercept=c(-0.6, 0.6), col="red") +
     geom_hline(yintercept=-log10(0.05), col="red")
de$diffexpressed <- "NO"
#de$diffexpressed[de$log2FoldChange > 0.6 & de$pvalue < 0.05] <- "UP"
#de$diffexpressed[de$log2FoldChange < -0.6 & de$pvalue < 0.05] <- "DOWN"

de$diffexpressed[de$log2FoldChange > 0 & de$pvalue < 0.05] <- "UP"
de$diffexpressed[de$log2FoldChange < -0 & de$pvalue < 0.05] <- "DOWN"

p <- ggplot(data=de, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed)) + geom_point() + theme_minimal()

p2 <- p + geom_vline(xintercept=c(-0.6, 0.6), col="red") +
         geom_hline(yintercept=-log10(0.05), col="red")
p3 <- p2 + scale_color_manual(values=c("blue", "black", "red"))
 
mycolors <- c("blue", "red", "black")
 
 names(mycolors) <- c("DOWN", "UP", "NO")
p3 <- p2 + scale_colour_manual(values = mycolors)
de$delabel <- NA
de$delabel[de$diffexpressed != "NO"] <- de$Symbol[de$diffexpressed != "NO"]

length(de$delabel[de$diffexpressed != "NO"])

#ggplot(data=de, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed, label=delabel)) + 
#     geom_point() + 
#     theme_minimal() +
#     geom_text()

g1 <- subset(de, Symbol == "CD36")
g2 <- subset(de, Symbol == "LPL")
g3 <- subset(de, Symbol == "FN1")

library(ggrepel)
# plot adding up all layers we have seen so far
ggplot(data=de, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed, label=delabel)) +
         geom_point() + 
         theme_minimal() +
         geom_text_repel() +
         scale_color_manual(values=c("blue", "black", "red")) +
         geom_vline(xintercept=c(-0.6, 0.6), col="red") +
         geom_hline(yintercept=-log10(0.05), col="red") +
         #geom_point(aes(x = de[de$Symbol %in% c("CD36"),]$log2FoldChange, y = -log10(de[de$Symbol %in% c("CD36"),]$pvalue)), colour="purple")
         #geom_text(data = de[de$group == "CD36",], aes(x = de[de$Symbol %in% c("CD36"),]$log2FoldChange * 1.05, y = -log10(de[de$Symbol %in% c("CD36"),]$pvalue), label = "CD36"))
         geom_point(data=g1, colour="purple") +  # this adds a red point
         geom_point(data=g2, colour="green") +  # this adds a red point
         geom_point(data=g3, colour="light blue") +  # this adds a red point

  		 #geom_text(data =g1, label="CD36", color="purple", nudge_x = 0.03, nudge_y = 0.03, check_overlap = T)
# plot the data
