#!/bin/bash
usage="$BASE_SOURCE"

cat << 'EOF' | R --no-save

library(scPred)
saveRDS( scPred::pbmc_1, file= "pbmc_1.rda")
saveRDS( scPred::pbmc_2, file= "pbmc_2.rda")

EOF
