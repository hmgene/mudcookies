# Developing Pipelines
## a pseudo sc-RNA track
```
## completed
merge-cellranger.sh input.txt merged.rds
integrate-with-harmony.sh merged.rds merged-harmony.rds

## working pipeline
identify-celltype.sh merged.harmony.rds icell
icell/celltypes.txt  # chosen cell types
     /meta.txt       # celltype calls

```

# How to write codes
## Some rules
- each file must be independently runnable
- provide test examples in ../test directory if possible
- use proper suffices for different languages such as R, perl, python
- the runnable BASH wrapper must be independently runnable on BASH
- use issues for errors and installation  

## how to wrap with bash
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
