# obtained from SingleR package
# understand how to score cell types

input=<seurat.obj>
output=<prefix>

library(celldex)
ref.hpca <- HumanPrimaryCellAtlasData()
ref.immgen <- ImmGenData()
library(SingleR)
pred=SingleR(test=as.SingleCellExperiment(d),
        ref=ref.hpca,labels=ref.hpca$label.main, assay.type.test=1)
saveRDS(pred,file=paste0(output,".singler_hpca.rds"))




SingleR = function (method = "single", sc_data, ref_data, types, clusters = NULL, 
    genes = "de", quantile.use = 0.8, p.threshold = 0.05, fine.tune = TRUE, 
    fine.tune.thres = 0.05, sd.thres = 1, do.pvals = T, numCores = SingleR.numCores, 
    ...) 
{
    rownames(ref_data) = tolower(rownames(ref_data))
    rownames(sc_data) = tolower(rownames(sc_data))
    A = intersect(rownames(ref_data), rownames(sc_data))
    sc_data = as.matrix(sc_data[A, ])
    ref_data = ref_data[A, ]
    if (ncol(sc_data) > 1) {
        not.use = rowSums(is.na(ref_data)) > 0 | rowSums(is.na(sc_data)) > 
            0 | rowSums(ref_data) == 0
        ref_data = ref_data[!not.use, ]
        sc_data = sc_data[!not.use, ]
    }
    mat = medianMatrix(ref_data, types)
    if (typeof(genes) == "list") {
        utypes = unique(types)
        n = round(500 * (2/3)^(log2(c(ncol(mat)))))
        genes.filtered = unique(unlist(unlist(lapply(utypes, 
            function(j) lapply(utypes, function(i) genes[[i]][[j]][1:n])))))
        genes.filtered = intersect(genes.filtered, rownames(mat))
        print(paste0("Number of DE genes:", length(genes.filtered)))
    }
    else if (genes[1] == "de") {
        n = round(500 * (2/3)^(log2(c(ncol(mat)))))
        genes.filtered = unique(unlist(unlist(lapply(1:ncol(mat), 
            function(j) {
                lapply(1:ncol(mat), function(i) {
                  s = sort(mat[, j] - mat[, i], decreasing = T)
                  s = s[s > 0]
                  names(s)[1:min(n, length(s))]
                })
            }))))[-1]
        print(paste0("Number of DE genes:", length(genes.filtered)))
    }
    else if (genes[1] == "sd") {
        sd = rowSds(as.matrix(mat))
        genes.filtered = intersect(rownames(mat)[sd > sd.thres], 
            rownames(sc_data))
        print(paste0("Number of genes with SD>", sd.thres, ": ", 
            length(genes.filtered)))
    }
    else {
        genes.filtered = intersect(tolower(genes), intersect(tolower(rownames(sc_data)), 
            tolower(rownames(ref_data))))
        print(paste("Number of genes using in analysis:", length(genes.filtered)))
    }
    cell.names = colnames(sc_data)
    if (method == "single") {
        if (dim(sc_data)[2] > 2) {
            print(paste("Number of cells:", dim(sc_data)[2]))
        }
    }
    else if (method == "cluster") {
        n = length(levels(clusters))
        print(paste("Number of clusters:", n))
        data = matrix(nrow = dim(sc_data)[1], ncol = n)
        for (i in 1:n) {
            data[, i] = rowSums(as.matrix(sc_data[, is.element(clusters, 
                levels(clusters)[i])]))
        }
        colnames(data) = levels(clusters)
        rownames(data) = rownames(sc_data)
        sc_data = data
    }
    else {
        print("Error: method must be 'single' or 'cluster'")
        return(0)
    }
    output = SingleR.ScoreData(sc_data, ref_data, genes.filtered, 
        types, quantile.use, numCores = numCores, ...)
    if (do.pvals == T) {
        output$pval = SingleR.ConfidenceTest(output$scores)
    }
    if (fine.tune == TRUE & length(unique(types)) > 2) {
        labels = SingleR.FineTune(sc_data, ref_data, types, output$scores, 
            quantile.use, fine.tune.thres, genes = genes, sd.thres, 
            mat, numCores = numCores)
        output$labels1 = as.matrix(output$labels)
        output$labels = as.matrix(labels)
        output$labels1.thres = c(output$labels)
        if (do.pvals == T) 
            output$labels1.thres[output$pval > p.threshold] = "X"
    }
    else {
        labels = as.matrix(output$labels)
        output$labels.thres = c(output$labels)
        if (do.pvals == T) 
            output$labels.thres[output$pval > p.threshold] = "X"
    }
    output$cell.names = cell.names
    output$quantile.use = quantile.use
    output$types = types
    output$method = method
    return(output)
}
<bytecode: 0x55791b681588>
<environment: namespace:SingleR>
