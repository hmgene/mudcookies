## Vision
To help synthesize single-cell data for free for poor researchers.
I had some nice catch-phrases but forgot what they were.

## Missions 
### Learn and digest algorithms 
Single-cell RNA tools, best to my short knowledge, perform the following steps:  
- cell counting (cellranger) 
- normalization, reduction, (Seurat::SCTransform)  
- integration, batch correction and reduction (Seurat::Integration, Harmony)   
- interpretation and annotation (GSEA, etc)

### Make the synthetic data indistinguishable  
I propose a Bayesian way : Posterior ~ Prior x Model
1. define and train a model using a real data with a flat (naive) prior 
1. simulate data using posterior predictive distribution
1. iteratively improve the performance

## Value
Imagine you cannot tell synthetic sc-RNA data from real one.
Then, we can focus on unknown findings minimizing chores and 
maximizing productivity.

## Reward plan
No inspiring quotes but we appreciate for your contributions.
All the contributions are carved in a log history. 

## Usueful Links
[Seurat](https://github.com/satijalab/seurat)
[PMID: 31948481](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1850-9)
