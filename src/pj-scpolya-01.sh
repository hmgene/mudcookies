
sam_to_bed12(){
usage="$FUNCNAME <sam> [-x]
"
# reference from https://samtools.github.io/hts-specs/SAMv1.pdf
if [ $# -lt 1 ]; then echo "$usage"; return; fi
        cat $1 | perl -ne 'chomp; my @a=split/\t/,$_; my $print_seq="'${2:-}'";
                if($_=~/^@/){ next;}
                my $id=$a[0];
                my $flag=$a[1];
                my $chrom=$a[2];
                next if $chrom eq "*";
                my $start=$a[3]-1;
                my $mapq=$a[4]; # -10log10 Pr( wrong )
                my $cigar=$a[5];
                my $seq=$a[9];
                my $len=0;
                my $strand="+"; if ( $flag & (0x10) ){ $strand="-"; }
                my $gseq=""; # genomic sequence 
                #\*|([0-9]+[MIDNSHPX=])+ 
                my $cb=""; #single-cell barcode
                if($_=~/CB:Z:([\w\d-]+)/){ $cb=$1;};

                my @starts=(); 
                my @sizes=(); 
                my @seqs=();
                my $gpos=0; 
                my $spos=0; ## sequence offset
                my $prev_c="";
                while($cigar=~/(\d+)([MIDNSHPX=])/g){ 
                        my ($x,$c)=($1,$2);
                        if($c=~/[MX=]/){
                                if($prev_c eq "D" or $prev_c eq "I"){
                                        $sizes[$#sizes] += $x;
                                        $seqs[$#seqs] .= substr($seq,$spos,$x);
                                }else{
                                        push @starts, $gpos; 
                                        push @sizes, $x;
                                        push @seqs, substr($seq,$spos,$x);
                                }
                                $spos += $x;
                                $gpos += $x;
                        }elsif($c=~/[DN]/){
                                if( $c eq "D" ){
                                        $seqs[$#seqs] .= "-"x$x;
                                        $sizes[$#sizes] += $x; ## ignore deletions
                                }else{ ## splicing?
                                }
                                $gpos += $x; 
                       }elsif($c=~/[SI]/){
                                ## note that soft/hard clipping does not affect genomic coordinates 
                                $spos += $x;
                        }else{
                                ## P is not handled
                        }
                        $prev_c=$c;
                }
                my $end=$start+$starts[$#starts]+$sizes[$#sizes];
                my $str_sizes=join(",",@sizes);
                my $str_starts=join(",",@starts);
                my $str_seqs=join(",",@seqs);
                if($print_seq eq "-x"){
                        $str_starts .= "\t".$str_seqs;
                }
                print join("\t",( 
                        $chrom,$start,$end,$cb,$mapq,$strand,
                        $start,$end,"0,0,0",scalar @starts,
                        $str_sizes,$str_starts
                )),"\n";
        '
}

for bam in bam/*.bam;do
        n=${bam#*\.}
        n=${n%\.bam}
      samtools view $bam | sam_to_bed12 -  | perl -ne 'use strict;
                my %r=();
                while(<STDIN>){chomp; my@d=split/\t/,$_;
                        my @l=split/,/,$d[10];
                        my @s=split/,/,$d[11];
                        map {
                                my $k=$d[0].":".$d[5];
                                $r{$k}{$d[1]+$s[$_]} ++;
                                $r{$k}{$d[1]+$s[$_] + $l[$_]} --;
                        }0..$#l;
                }
                ## bedgraph output
                foreach my $k (keys %r){
                        my ($c,$t)=split /:/,$k;
                        my $s=0; my @x=sort {$a<=>$b} keys %{$r{$k}};
                        map {
                                $s+=$r{$k}{$x[$_]};
                                print join("\t",$c,$x[$_],$x[$_+1],$s,$t),"\n";
                        } 0..($#x-1);
                }
        '
        exit
        exit
done
