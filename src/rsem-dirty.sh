NPROC=8
STAR_PATH=~/data/star/STAR-2.5.3a/bin/Linux_x86_64
r=~/data/rsem/grch38/grch38
for f1 in ../cutadapt/*_1.fq.gz;do
        f2=${f1/_1/_2};
        n=${f1##*/};
        o=exp/$n
        echo "
        #!/bin/sh
        #BSUB -o %J.bsub.out
        #BSUB -e %J.bsub.err
        #BSUB -J $o
        mkdir -p ${o%/*}
        rsem-calculate-expression -p $NPROC --paired-end \
                --star --star-path $STAR_PATH \
                --estimate-rspd \
                --star-gzipped-read-file \
                --append-names \
                --output-genome-bam \
                $f1 $f2 $r $o
        " | bsub
done
exit

TPM(){
#{ for f in exp/*.genes.results;do echo ${f:4:4}; done } | sort -u | while read n;do 
for f in exp/*.genes.results;do
        n=${f#*/};n=${n%.genes.results};
        echo -e "gene\tcount\tTPM" > $n.tpm;
        cut -f 1,5,6 $f | grep -v gene_id \
        | hm util.groupby - 1 2,3,3 sum,sum,count | perl -ne '
                chomp;my@a=split/\t/,$_;
                $a[0]=~s/.+_(\w+)/$1/;
                $a[2]=$a[2]/$a[3];
                print join("\t",@a[0..2]),"\n";
        ' >> $n.tpm
done
}
#hm util.join -h 1 *.tpm | perl -npe '$_=~s/.tpm//g;' > out.tpm 
for f in 2040 2049 2831 3352 3627 4173;do
        o=${f}_vs_3440_8039
echo "
        hm util.cut out.tpm gene 3440 8039  $f \
        | hm util.cut - gene count TPM \
        | hm edger.filtersmall - 2,3,4,5,6,7 10 4 \
        | hm edger.rep - 2,3,4,5 6,7 $o.edger
        hm edger.summary $o.edger 0.05 1 $o
" | bsub
done
exit

for f in 2040 2049 2831 3352 3627 4173;do
        n=3440_8039
        m=$f
        o=${n}_to_{$m}
        echo "
        hm gsea.prepare $n:3440.tpm,8039.tpm $m:$f.tpm 1 3 $o
        hm gsea.run $o.gct $o.cls ~/projs/odisi/gsea/c2.cp.kegg.v6.0.symbols.gmt  gsea/$o
        " | bsub
done
exit
#hm edger.filtersmall a.txt 2,3,4,5,6,7,8,9 10 4 | hm edger.rep - 2,3 4,5,6,7,8.9  out.edger
#hm edger.summary out.edger 0.05 1 out.edger
