target=
host=sftp.mcgillgenomecentre.ca
port=22
user=user
password=password
w=output_dir
i=input_dir
nohup lftp -u $user,$password sftp://$host <<EOF >> log.txt 2>&1  &
lcd $w
mget $i/*
bye
EOF
