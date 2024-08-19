#!/bin/bash

# Get the list of files with .biom extension in the directory
files=$(find . -maxdepth 1 -type f -name '*.biom')

# Iterate over each file
for file in $files; do
    # Extract the file name without extension
    filename=$(basename "$file" .biom)
    
    # Run the biom convert command
    biom convert -i "$file" -o "$filename.tsv" --to-tsv --table-type "OTU table" --header-key taxonomy
done

