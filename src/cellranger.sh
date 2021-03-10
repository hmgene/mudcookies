#output=o.csv
#file -i $input
#iconv -f us-asicii -t UTF-8 2_12_2021_Louveau_sample_sheet.csv  > o.csv
#file -i o.csv
#cat $input | perl -npe '$_=~s/\r\n/\n/g;' > $output


cellranger mkfastq --id=tutorial_walk_through \
--run=210203_A01101_0095_AH2N2LDRXY \
--csv=Jihye_sample_sheet.csv \
--force-single-index



input="
#id     fastq   prefix
s1      180611_A00405_0027_BH5LT2DSXX   1_LUL
s2      180611_A00405_0027_BH5LT2DSXX   2_RUL
s3      190219_A00405_0081_BHGY2CDSXX   1_RB6
s4      190219_A00405_0081_BHGY2CDSXX   2_LB6
s5      190219_A00405_0081_BHGY2CDSXX   4_BMC
s6      190219_A00405_0081_BHGY2CDSXX   5_CRVL
s7      190913_A00405_0142_AHH2J7DSXX   3_RB6
s8      190913_A00405_0142_AHH2J7DSXX   1_LB_1plus2
s9      191108_A00405_0164_AHMVMHDSXX   A
s10     191108_A00405_0164_AHMVMHDSXX   B
s11     191108_A00405_0164_AHMVMHDSXX   C
s12     191125_A00405_0172_AHNJCFDSXX   RUL
s13     191125_A00405_0172_AHNJCFDSXX   LUL
"

transcriptome="~/data/10x/refdata-gex-GRCh38-2020-A"
cellranger="~/data/10x/cellranger-5.0.0/bin/cellranger"
sourceme="~/data/10x/cellranger-5.0.0/sourceme.bash"

echo "$input" | grep -v "^$\|^#" | while read -r line;do
        a=( `echo "$line"` )
        id=${a[0]}
        fastq="../fastq/${a[1]}"
        prefix=${a[2]}
        if [  ! -d $fastq ];then
                echo "$fastq not exists";
                continue
        fi

samples=( ` ls $fastq/$prefix*R1* | perl -npe '$_=~s/.+\/(\w+)_S\d+.+/$1/g' ` )
ifs=$IFS;IFS=","; samples=`echo "${samples[*]}"`; IFS=$ifs

mkdir -p $id
echo "
#!/bin/sh
#BSUB -o $id.bsub.out
#BSUB -e $id.bsub.err
#BSUB -J $id
#BSUB -R rusage[mem=64] span[hosts=1]
        source $sourceme
        $cellranger count --id $id --fastqs $fastq/ --sample $samples --transcriptome $transcriptome --r1-length=26  --r2-length=100 
"  | bsub



done

