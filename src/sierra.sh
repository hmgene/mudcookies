gene="JUN"
regtools=regtools/build/regtools

gene_range(){
 grep gene $1 | grep -w $2 |  perl -ne 'use strict;
        my ($c,$s,$e);
        while(<STDIN>){ chomp; my @d=split/\t/,$_;
                $c = $d[0];
                $s = defined($s) && $s<$d[3] ? $s : $d[3] ;
                $e = defined($e) && $e>$d[4] ? $e : $d[4];
        }
        print "$c:$s-$e\n"
'
}

grep $gene genes.gtf | awk '{print "chr"$0;}' > $gene.gtf
cloc=`gene_range $gene.gtf $gene`
for n in s3 ;do
        o="$n-$gene"
        bam=$n/outs/possorted_genome_bam.bam
        samtools view -hb $bam $cloc > $o.bam
        samtools index $o.bam
        $regtools junctions extract -s 1 -o $o.j.bed $o.bam
        samtools view $o.bam | perl -ne 'chomp;if($_=~/CB:Z:([\w\d-]+)/){ print $1,"\n";};' > $o.white.txt
done
exit
cat<<EOF
library(Sierra)
b=c("s3-MMP10.bam","s4-MMP10.bam")
g="MMP10.gtf"
j=c("s3-MMP10.j.bed","s4-MMP10.j.bed")
o=c("s3-MMP10","s4-MMP10")
w=c("s3-MMP10.white.txt","s4-MMP10.white.txt")
for( i in 1:length(b)){
        FindPeaks(output.file=paste0(o[i],".peak"), gtf.file=g,bamfile=b[i],junctions.file=j[i])
}

m = data.frame(Peak_file=paste0(o,".peak"), Identifier=o,stringAsFactors=F)
m.f=paste0(paste(o,collapse="_"),".txt")
MergePeakCoordinates( m, output.file=m.f)

c.f=output.dir=paste0(o,".count")
for( i in 1:length(b)){
        CountPeaks(peak.sites.file=m.f, gtf.file=g, bamfile=b[i], whitelist.file=w[i], output.dir=c.f[i], countUMI=T)
}
ag.f=paste0(paste(o,collapse="_"),".aggregate")
e=o
AggregatePeakCounts(peak.sites.file=m.f, count.dirs=c.f, exp.labels=e, output.dir=ag.f)

an.f=paste0(paste(o,collapse="_"),".annotations.txt")
genome <- BSgenome.Hsapiens.UCSC.hg38::BSgenome.Hsapiens.UCSC.hg38
AnnotatePeaksFromGTF(peak.sites.file = m.f, gtf.file = g, output.file = an.f, genome = genome)

d=readRDS("../20200430/lb6_rb6_190219.rds")
d1=RenameCells(d, new.names=gsub("rb6_190219_(\\w+)","\\1-s3-MMP10",colnames(d)))
d1=RenameCells(d1, new.names=gsub("lb6_190219_(\\w+)","\\1-s4-MMP10",colnames(d1)))

peak.annotations <- read.table(an.f, header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)
peak.counts <- ReadPeakCounts(data.dir = ag.f)


peaks.seurat <- PeakSeuratFromTransfer(peak.data = peak.counts,
                                       genes.seurat = d1,
                                       annot.info = peak.annotations,
                                       min.cells = 0, min.peaks = 0)

Condition <- data.frame(Condition = sub(".*-(.*)", "\\1",
                        colnames(peaks.seurat)),
                        row.names = colnames(peaks.seurat))
peaks.seurat <- AddMetaData(peaks.seurat, metadata = Condition,
                            col.name = "Condition")


gtf_gr <- rtracklayer::import(g)
PlotCoverge(genome_gr=gtf_gr,geneSymbol="MMP10",genome="hg38",bamfiles=b)


res.table = DUTest(peaks.seurat,
                   population.1 = "s3-MMP10",
                   population.2 = "s4-MMP10",
                   exp.thresh = 0.1),
                   feature.type = c("UTR3", "exon"))

EOF
