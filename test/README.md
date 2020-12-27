
## scPred Track
```
## prepare pbmc_1.rda, and pbmc_2.rda
bash ../src/data_from_scpred.sh 
## train celltype from pbmc_1
bash ../src/train-celltype-with-scpred.sh  pbmc_1.rda pbmc_1.scpred.rds
## predict celltype for pbmc_2 using the trained model
bash ../src/predict-celltype-with-scpred.sh pbmc_2.rda pbmc_1.scpred.rds pbmc_2.predict.rds

```
