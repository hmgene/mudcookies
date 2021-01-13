#!/bin/bash

usage="$BASH_SOURCE <fastq1> <fastq2> <ref> <output> [-p <nproc>]"
if [ $# -lt 4 ];then echo "$usage"; exit; fi

star=`which STAR` #/cm/shared/apps/STAR/2.7.6a/STAR
star=${star%/*}
odir=$4
isgzip=""
[[ $1 =~ .*gz ]] && isgzip="--star-gzipped-read-file"

mkdir -p ${odir%/*} # RSEM error
rsem-calculate-expression --paired-end $isgzip \
        --star --star-path $star \
        --estimate-rspd \
        --append-names \
        --no-bam-output \
        $@
~                                              
