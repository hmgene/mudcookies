# Developing Pipelines
## a pseudo sc-RNA track
```
# input.txt : inventory file( id, cellranger_dir )
# save Seurat object after integration (normalization, reduction, batch-correction)
cat input.txt | harmony.sh - > harmony.rds
# unsupervised cell-identification
cat harmony.rds | clustering.sh - some.parameters.txt > clusters.txt
# supervised cell-identification
cat harmony.rds | classification.sh - cellmarkers.txt > classes.txt
# some functional analysis
cat harmony.rds | gsea.sh "control" "treatment" > gsea.txt

```

# How to write codes
## Some rules
- each script should be independent 
- provide test examples in ../test directory if possible
- use the corresponding suffices for different languages such as R, perl, python
- the runnable BASH wrapper must be independently runnable on BASH
- use issues for errors and installation  

### hello-r.sh
``` 
#!/bin/bash
R --no-save - <<'EOF'
print("hello")
EOF
```
### hello-python.sh
```
#!/bin/bash
python - <<'EOF'
#careful indentation
print("hello")
EOF
```
### hello-perl.sh
```
#!/bin/bash
perl -e '
  print("hello\n")
'
```
