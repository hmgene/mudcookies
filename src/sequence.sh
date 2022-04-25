## extract n-mers from fasta 
echo -e ">id\nACGTAAACC" > in,fa
n=3; cat in.fa | perl -ne 'map { print $_,"\n";} $_=~/[ACGTacgt]{'$n'}/g;'
