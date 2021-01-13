## download gencode 
download-gencode-files(){
        mkdir -p gencode
        cd gencode
        wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M25/GRCm38.primary_assembly.genome.fa.gz
        wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M25/gencode.vM25.annotation.gtf.gz
        wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_36/GRCh38.primary_assembly.genome.fa.gz
        wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_36/gencode.v36.annotation.gtf.gz
        gunzip *.gz
        cd ..
}
install-rsem(){
        wget https://github.com/deweylab/RSEM/archive/v1.3.3.tar.gz
        tar -vzxf v1.3.3.tar.gz
        cd RSEM-1.3.3
        make
        ..
}
download-rsem-example-files(){
        mkdir -p data
        cd data
        wget http://genomedata.org/rnaseq-tutorial/HBR_UHR_ERCC_ds_5pc.tar
        cd ..
}
rsem-prepare-reference(){

gtf=gencode/gencode.vM25.annotation.gtf
star=./STAR-2.7.6a/bin/Linux_x86_64
genome=./gencode/GRCm38.primary_assembly.genome.fa
output=./rsem_ref/gencode_mouse
nproc=4

## rsem bug: the output must be in the genome directory
mkdir -p ${output%/*}
cp $genome ${output%/*}
rsem-prepare-reference -p 4 --gtf $gtf  --star --star-path $star $genome $output

        
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
