#! /bin/bash

############################################
# Run this script in a directory containing:
# - The encrypted `*.gpg` files
# - The `samples.md5` file
# - The `gpg.keys` file.
############################################

KEYS_FILE=gpg.keys
MD5_FILE=samples.md5
INDIR=`pwd`
OUTDIR=`pwd`/outdir

mkdir -p $OUTDIR

# Decrypt and decompress
while read -r SAMPLE KEY; do

        echo 'Decrypting' $SAMPLE'.tar.gz.gpg'
        echo $KEY | gpg --batch --passphrase-fd 0 --armor --decrypt $INDIR/$SAMPLE.tar.gz.gpg > $OUTDIR/$SAMPLE.tar.gz

        echo 'Decompressing' $SAMPLE'.tar.gz'
        tar -xvzf $OUTDIR/$SAMPLE.tar.gz -C $OUTDIR

done < $KEYS_FILE

echo 'Checking data integrity with md5 checksum'
RESULTS=$OUTDIR/md5_checks.txt
cp $MD5_FILE $OUTDIR/$MD5_FILE
cd $OUTDIR

md5sum -c $MD5_FILE > $RESULTS

# Check all files are OK
if [ `cat $RESULTS | wc -l` -eq `cat $RESULTS | grep OK | wc -l` ]; then
        echo 'All files are OK';
else
        echo ""
        echo "The following files didn't pass the md5 checksum:"
        echo ""
        cat $RESULTS | grep -v OK;
fi
