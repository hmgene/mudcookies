
## scPred Track
```
## prepare pbmc_1.rda, and pbmc_2.rda
bash ../src/data_from_scpred.sh 
## train celltype from pbmc_1
## make sure pbmc_1 has a "cell_type" column 
bash ../src/train-celltype-with-scpred.sh  pbmc_1.rda pbmc_1.scpred.rds 2
## predict celltype for pbmc_2 using the trained model
bash ../src/predict-celltype-with-scpred.sh pbmc_2.rda pbmc_1.scpred.rds pbmc_2.predict.rds

```

## Harmony Track 
```
bash ../src/integrate-with-harmony.sh pbmc_1.rda pbmc_1.harmony.rds
## recluster with a resolution 0.2
bash ../src/cluster-seurat.sh  pbmc_1.harmony.rds pbmc_1.harmony.rds  0.2
bash ../src/diffexp.sh  pbmc_1.harmony.rds pbmc_1.harmony.diff.csv

```
