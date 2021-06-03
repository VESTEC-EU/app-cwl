# Some tools for transforming CWL files

Each pass is a transformer that walks the tree of a YAML-ish
representation of a CWL file and returns a new one.

Passes available are:

- IMPORT: replace an object like {"$IMPORT": "rel/path/to/file"} with
  the literal contents of the referred file. This is much like SALAD
  "$import" but it doesn't do anything fancy with namespaces etc.

- scatter: help to do scatter workflows over one input from many.

- template: Read one or more template declaration files and then make
  them available for use
