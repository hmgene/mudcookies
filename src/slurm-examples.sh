mem=24000
jid="sc-mouse"
## add more options
echo "#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --job-$jid
#SBATCH --time=1-2:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=$mem
#SBATCH -o $jid.out
#SBATCH -e $jid.err

        module load R/4.0.1 
        bash $src/merge-cellranger.sh input.txt mouse-hong1-5.rds
        #bash seurat-default.sh $f $n
        #bash scsa-default.sh $n.markers.csv $n.marker.csv.scsa 
        #bash seurat-post-scsa.sh $n.seurat.rds $n.marker.csv.scsa $n.seurat.scsa.rds
" | sbatch -N 1
