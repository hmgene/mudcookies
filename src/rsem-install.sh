## download gencode 
download-rsem-files(){
wget https://github.com/deweylab/RSEM/archive/v1.3.3.tar.gz
tar -vzxf v1.3.3.tar.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_36/GRCh38.primary_assembly.genome.fa.gz
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_24/GRCh38.primary_assembly.genome.fa
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_24/gencode.v24.annotation.gtf.gz
wget http://genomedata.org/rnaseq-tutorial/HBR_UHR_ERCC_ds_5pc.tar
gunzip *.gz
}

echo "#!/bin/bash
#SBATCH --job-name=rsem-ref
#SBATCH --time=4-23:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=64000
#SBATCH -e slurm-%j.err
#SBATCH -o slurm-%j.out

module load STAR  #/cm/shared/apps/STAR/2.7.6a/STAR
module load RSEM
mkdir -p rsem_ref
srun rsem-prepare-reference -p 4 \
        --gtf gencode.v36.annotation.gtf \
        --star \
        --star-path  /cm/shared/apps/STAR/2.7.6a \
        ./GRCh38.primary_assembly.genome.fa \
        rsem_ref/gencode_human
" | sbatch -N 1
