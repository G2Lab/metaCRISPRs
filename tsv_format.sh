#!/bin/bash

# Get the list of files with .tsv extension in the directory
files=$(find . -maxdepth 1 -type f -name '*.tsv')

# Iterate over each file
for file in $files; do
    # Run the awk and cut commands
    awk -F '\t|;' 'BEGIN{OFS="\t"} FNR > 2 {$1=""; print $0}' "$file" | cut -f 2- > "${file%.tsv}_processed.tsv"
done
