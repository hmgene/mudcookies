## Overview
### sc-RNA track
```
#input.txt : ( id, cellranger_dir )
cat input.txt | harmony.sh - > harmony.rds
cat harmony.rds | clustering.sh - some.parameters.txt > clusters.txt 
gsea.sh clustering.txt > gsea.txt
```

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
