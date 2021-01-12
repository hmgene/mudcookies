#!/bin/bash

usage="$BASH_SOURCE <fastq1> <fastq2> <ref> <output> [nproc]"
if [ $# -lt 1 ];then echo "$usage"; exit; fi
nproc=${5:-1}
star=`which STAR` #/cm/shared/apps/STAR/2.7.6a/STAR
star=${star%/*}
odir=$4
echo "
mkdir -p ${odir%/*} # RSEM error
rsem-calculate-expression -p $nproc --paired-end \
        --star --star-path $star \
        --star-gzipped-read-file \
        --estimate-rspd \
        --append-names \
        --no-bam-output \
        $1 $2 $3 $4 
" | bash
