# Vision
To help synthesize single-cell data for free for poor researchers.
I had some nice catch-phrases but forgot what they were.

# Missions 
## Learn and digest algorithms 
From my short experience the single-cell RNA tools perform the following steps:  
- cell counting (cellranger) 
- normalization, reduction, (Seurat::SCTransform)  
- integration, batch correction and reduction (Seurat::Integration, Harmony)   
- interpretation and annotation (GSEA, etc)

## Make the synthetic data indistinguishable  
We follow Bayesian concept : Posterior ~ Prior x Model
1. train a model using a real data using a flat (naive) prior 
1. regenerate data using the posterior predictive distribution
1. iteratively improve the performance

# Value
Imagine you cannot tell synthetic sc-RNA data from real one.
Then, we can focus on unknown findings minimizing chores and 
maximizing productivity.

# Reward plan
No inspiring quotes but we appreciate for your contributions.
All the contributions are carved in a log history. 

# Usueful Links
[Seurat](https://github.com/satijalab/seurat)
[PMID: 31948481](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1850-9)
