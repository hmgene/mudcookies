## modify sample_sheet.csv with the order of columns, LANE, SAMPLE, and BARCODE


mem=64000
jid="mkfastq"
## add more options
echo "#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --job-name=$jid
#SBATCH --time=1-5:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=$mem
#SBATCH -o $jid.out
#SBATCH -e $jid.err
        module load bcl2fastq
        rm -rf louveaa/
        source /home/kimj23/beegfs/cellranger-6.0.0/sourceme.bash
                cellranger mkfastq --id=louveaa --maxjobs=24 --mempercore=64000 --run=210223_A01101_0103_BH2LFHDRXY --csv=Jihye_2_23_2021_Louveau_sample_sheet.csv --force-single-index
" | sbatch -N 1      
