bam2fq(){
for f in *.bam;do
        n=${f%.RNA-Seq.bam}
        if [ -f ${n}_R1.fastq.gz ];then continue; fi
        cat<<-eof  #| sbatch
        #!/bin/bash 
        module load samtools
        samtools view -F0x100 -hf0x2 $f | samtools fastq - -n -1 ${n}_R1.fastq.gz -2 ${n}_R2.fastq.gz
        eof
done

}
