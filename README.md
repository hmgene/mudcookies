
## Our Missions 
- To learn and digest single-cell algorithms
- To validate the algorithms using synthetic data
- To develop a simulator producing realistic data

## Vision
To help synthesize single-cell data for free for poor researchers.

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
The final virtual sequencing machine will cost less with equivalenet power as real single-cell sequencers. 

## Usueful Links
[1]: (https://github.com/satijalab/seurat)
[2]: (https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1850-9) PMID 31948481
