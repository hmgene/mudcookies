## rename 
from=(
usftp21.novogene.com/raw_data/LNXIP_BGn_1h_AR/LNXIP_BGn_1h_AR_CKDL220008926-1a-AK5433-AK5434_HK7CWDSX3_L4_1.fq.gz
usftp21.novogene.com/raw_data/LNXIP_BGn_24h_AR/LNXIP_BGn_24h_AR_CKDL220008926-1a-AK5435-AK2591_HK7CWDSX3_L4_1.fq.gz
usftp21.novogene.com/raw_data/LNXIP_BGn_6h_AR/LNXIP_BGn_6h_AR_CKDL220008926-1a-AK5405-AK5406_HK7CWDSX3_L4_1.fq.gz
usftp21.novogene.com/raw_data/LNXIP_D_1h_AR/LNXIP_D_1h_AR_CKDL220008926-1a-AK5105-AK5430_HK7CWDSX3_L4_1.fq.gz
usftp21.novogene.com/raw_data/LNXIP_D_24h_AR/LNXIP_D_24h_AR_CKDL220008926-1a-AK5432-AK4181_HK7CWDSX3_L4_1.fq.gz
usftp21.novogene.com/raw_data/LNXIP_D_6h_AR/LNXIP_D_6h_AR_CKDL220008926-1a-AK5431-AK2875_HK7CWDSX3_L4_1.fq.gz
usftp21.novogene.com/raw_data/RH5_NT_6h_MYOD1/RH5_NT_6h_MYOD1_CKDL220008926-1a-AK5436-AK5437_HK7CWDSX3_L4_1.fq.gz
)
to=(
LNCaPXIP_BG15n_1hr_AR_040622_NovoG
LNCaPXIP_BG15n_6hr_AR_040622_NovoG
LNCaPXIP_BG15n_24hr_AR_040622_NovoG
LNCaPXIP_DMSO_1hr_AR_040622_NovoG
LNCaPXIP_DMSO_6hr_AR_040622_NovoG
LNCaPXIP_DMSO_24hr_AR_040622_NovoG
RH5_NT_6h_MYOD1_031122_NovoG
)
odir=/mnt/rstor/SOM_GENE_BEG33/data/040622_NovoG
ls $odir

for (( i=0; i<${#from[@]}; i++ ));do
        q1=${from[$i]};
        q2=${q1/_1.fq.gz/_2.fq.gz};
        if [[ -f $q1 && -f $q2 ]];then
                f1=${to[$i]}_R1.fastq.gz;
                f2=${to[$i]}_R2.fastq.gz;
                echo "
                        cp $q1 $odir/$f1
                        cp $q2 $odir/$f2
                "
        fi

done
