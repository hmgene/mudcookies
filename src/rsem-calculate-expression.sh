#!/bin/bash

usage="$BASH_SOURCE <fastq1> <fastq2> <ref> <output> [-p <nproc>]"
if [ $# -lt 4 ];then echo "$usage"; exit; fi
star=`which STAR` #/cm/shared/apps/STAR/2.7.6a/STAR
star=${star%/*}
odir=$4

mkdir -p ${odir%/*} # RSEM error
rsem-calculate-expression -p $nproc --paired-end \
        --star --star-path $star \
        --star-gzipped-read-file \
        --estimate-rspd \
        --append-names \
        --no-bam-output \
        $@
