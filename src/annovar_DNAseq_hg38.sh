## hg38

## annovar download : read https://annovar.openbioinformatics.org/en/latest/user-guide/download/

## annovar dataDB download to humandb_hg38(directory)
./annotate_variation.pl -downdb -buildver hg38 -webfrom annovar {$dbname} {$humandb}
e.g.,
./annotate_variation.pl -downdb -buildver hg38 -webfrom annovar 1000g2014oct humandb_hg38/


## [IMPORTANT!]  remove header lines of vcf file, except column header

## convert no-headed vcf file to annovar input (.avinput)
./convert2annovar.pl -format vcf4 --includeinfo /Users/jihyekim/NextGenSequencing/Ghosh_EXOME/217388lb6.pass.snp.indel_nohead.txt > /Users/jihyekim/NextGenSequencing/Ghosh_EXOME/217388lb6.pass.snp.indel_nohead.avinput   

## annovar annotation.
## add/remove/change databases 
./table_annovar.pl ../../Ghosh_EXOME/217388lb6.pass.snp.indel_nohead.avinput ./humandb_hg38 -buildver hg38 -out ../../Ghosh_EXOME/217388lb6 -remove -protocol knowngene,refGene,cosmic70,ljb26_all,esp6500siv2_all,avsnp150,1000g2015aug_all -operation g,g,f,f,f,f,f


