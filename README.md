## Vision
To provide syhhetic single-cell data for free for poor researchers

## Our Missions 
- To organize energy-efficient single-cell pipelines 
- To develop a virtual seuqncer producing realistic data

## Strategies
Single-cell RNA tools, best to my short knowledge, perform the following steps (standard-like tool names:  
1. cell counting (cellranger) 
1. normalization, reduction, (Seurat::SCTransform)  
1. integration, batch correction and reduction (Seurat::Integration, Harmony)   
1. interpretation and annotation (GSEA, GO, DESeq2, etc.)
Using this we develop scalable, reusable pipelines.</br> 

The parameters and models are obtained from the above runs.
And then, we will make some synthetic data indistinguishable from the real one.
We can think of a Bayesian way : Posterior ~ Prior x Model
1. define and train a model using a real data with a flat (naive) prior 
1. simulate data using posterior predictive distribution
1. iteratively improve the performance

## Value
As much value as mudcookies for some people 

## Usueful Links
1. Seurat: https://github.com/satijalab/seurat
2. Batch-correction bantchmarking : https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1850-9) PMID 31948481
