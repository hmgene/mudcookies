
#wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_42/GRCh38.primary_assembly.genome.fa.gz
#wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_42/gencode.v42.annotation.gtf.gz
#gunzip -dc *.gz;

## depending on the GTF you have to convert convet gene id to gene name
gtf=gencode.v42.annotation.gtf
fa=GRCh38.primary_assembly.genome.fa
## change this to where hisat2 exists
hp=/usr/local/hisat2/2.2.0/bin
ref="rsem_hisat2_hg38"

## input fastq files
fq1=x_R1.fastq.gz
fq2=x_R2.fastq.gz
## output name
o="out"


## index
cat<<-eof | sbatch  --mem=200g -c 8
#!/bin/bash
module load gcc
module load hisat2
rsem-prepare-reference -p 8 --gtf $gtf  --hisat2-hca --hisat2-path $hp $fa $ref
eof

## mapping and RSEM
cat<<-eof | sbatch --mem=16g -c 8
#!/bin/bash
hisat2 -x $ref  -1 $fq1 -2 $fq2 -p 8 \
    --no-spliced-alignment  --end-to-end  --no-softclip  --rdg 10000,10000  --rfg 10000,10000 > $o.sam
samtools view -hb $o.sam | samtools view -bh -f 0x2 -F 0x100 - | samtools sort -n > $o.bam
rsem-calculate-expression --paired-end --bam $o.bam $ref $o
eof

