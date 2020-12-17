## Vision
- To make all bioinformaticians and collaborators happy in single-cell study 

## Our Missions 
- To setup single-cell data workflow 
- To highlight individual's strength
- To stregthen team bond 
- To improve collaboration

## Abstract Strategies
1. separate static and dynamic workflow (pipelines, data organization)
1. code considering flexibility and reusability first
1. get help for code scalibility and portability 

## Strategy example
Single-cell RNA tools, best to my short knowledge, perform the following steps (standard-like tool names:  
1. cell counting (cellranger) 
1. normalization, reduction, (Seurat::SCTransform)  
1. integration, batch correction and reduction (Seurat::Integration, Harmony)   
1. interpretation and annotation (GSEA, GO, DESeq2, etc.)

We will develop independent programs handling a simple task.</br>
Using your data, test and validate assembled programs, and share your idea.

## Usueful Links
1. We collect pipelines in [src directory](./src) directory
1. Seurat: https://github.com/satijalab/seurat
2. Batch-correction bantchmarking : https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1850-9) PMID 31948481
