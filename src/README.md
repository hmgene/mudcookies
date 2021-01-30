

# How to write codes
## Some rules
- tag your name or id,   <yourid>-<toolgroupname>-<functionname>.sh
- provide test examples in ../test directory if possible
- use proper suffices for different languages such as R, perl, python
- the runnable BASH wrapper must be independently runnable on BASH

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
