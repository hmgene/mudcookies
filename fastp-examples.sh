input="
/mnt/rstor/SOM_GENE_BEG33/data/083121_AK_Novogen/RH5_KAPAFr_WG_081721_NovoG_R1.fastq.gz
/mnt/rstor/SOM_GENE_BEG33/data/083121_AK_Novogen/RH5_KAPAFr_WG_081721_NovoG_R2.fastq.gz
/mnt/rstor/SOM_GENE_BEG33/data/083121_AK_Novogen/RH5_OmniC_081721_NovoG_R1.fastq.gz
/mnt/rstor/SOM_GENE_BEG33/data/083121_AK_Novogen/RH5_OmniC_081721_NovoG_R2.fastq.gz
/mnt/rstor/SOM_GENE_BEG33/data/083121_AK_Novogen/RH5_RNAse_KAPAFr_WG_081721_NovoG_R1.fastq.gz
/mnt/rstor/SOM_GENE_BEG33/data/083121_AK_Novogen/RH5_RNAse_KAPAFr_WG_081721_NovoG_R2.fastq.gz
"

## set env for fastp
fastp=~/pr/fastp
queue_time="10:00:00"
debugdir="/home/hxk728/pj/fossil-c/fastq/debug"
threads=4
mem=100G

mkdir -p $debugdir
chmod 777 $debugdir


echo "$input" | grep -v '^$' | grep "R1.fastq.gz" \
| while read line; do
        na=${line##*/}; na=${na%_NovoG*}
        fq1=$line; fq2=${fq1/_R1/_R2}
        o1=${na}_R1.fastq.gz; o2=${na}_R2.fastq.gz
        jname="fastp_$na"

#cat<<-EOF
sbatch<<-EOF
#!/bin/bash
#SBATCH -o $debugdir/$jname-%j.out
#SBATCH -e $debugdir/$jname-%j.err
#SBATCH -t $queue_time
#SBATCH --mem=$mem
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p smp
#SBATCH -J ${jname}
$fastp -i $fq1 -o $o1 -I $fq2 -O $o2 -h $na.html --detect_adapter_for_pe
EOF
done
