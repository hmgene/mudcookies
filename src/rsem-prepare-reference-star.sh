#!/bin/bash

usage="$BASH_SOURCE <genome> <gtf> <out>"
if [ $# -lt 3 ];then echo $usage; exit; fi

genome=$1
gtf=$2
star=`which STAR`; 
star=${star%/STAR}
output=$3
nproc=4


## rsem bug: the output must be in the genome directory
mkdir -p ${output%/*}
rsem-prepare-reference --gtf $gtf  --star --star-path $star $genome $output ${@:4:${#@}}
