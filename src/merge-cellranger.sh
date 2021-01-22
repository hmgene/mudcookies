#!/bin/bash

usage="
	$BASH_SOURCE <input> <output>

	input: a table two columns with columan names (id, cellranger_dir) 
	output: seurat object <output>.rds
"
if [ $# -lt 1 ];then echo "$usage"; return; fi
cat<<'EOF'| sed s#OUTPUT#$2# | sed s#INPUT#$1#  > $2.rcmd
input="INPUT";
output="OUTPUT"; 
require(Seurat)
require(dplyr)
inp=read.table(input,header=T);
d.list=list();
j=1; for( i in 1:nrow(inp)){ 
	f=inp[i,]$cellranger_dir;
	id=inp[i,]$id;
	if( file.exists(f) ){	
		d=Read10X(data.dir=f)
		d.list[[j]]= CreateSeuratObject(counts=d,project=id,min.cells=3,min.features=200)	
		j = j + 1
	}else{
		warning(paste0(f," doesnot exist!"));
	}
}
d = merge(d.list[[1]],d.list[2:length(d.list)])
saveRDS(d,file=paste0(output,".rds"))
EOF
R --no-sve -f $2.rcmd


