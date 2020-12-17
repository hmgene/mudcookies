## Vision
- To make all bioinformaticians and collaborators happy in single-cell study 

## Our Missions 
- To setup single-cell data workflow 
- To highlight individual's strength
- To stregthen team bond 
- To improve collaboration

## Abstract Strategies
1. separate static and dynamic workflow (pipelines, data organization)
1. let codes resusable by others in a different situation
1. we will update after completing the above

## Some details
Single-cell RNA tools, best to my short knowledge, perform the following steps (standard-like tool names:  
1. cell counting (cellranger) 
1. normalization, reduction, (Seurat::SCTransform)  
1. integration, batch correction and reduction (Seurat::Integration, Harmony)   
1. interpretation and annotation (GSEA, GO, DESeq2, etc.)

We will develop independent programs handling a simple task.</br>
Using your data, test and validate assembled programs, and share your idea.

## Usueful Links
1. We collect pipelines in [src directory](./src) directory related project in https://github.com/hmgene/mudcookies/projects/1
1. How to share programs https://docs.github.com/en/free-pro-team@latest/github/managing-your-work-on-github/about-project-boards
1. Seurat: https://github.com/satijalab/seurat
1. Batch-correction bantchmarking : https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1850-9) PMID 31948481
