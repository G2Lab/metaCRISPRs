#!/bin/bash

# Get the list of files ending in _processed.tsv in the directory
files=$(find . -maxdepth 1 -type f -name '*_processed.tsv')

# Iterate over each file
for file in $files; do
    # Run the ktImportText command
    output_file="${file%_processed.tsv}.html"
    ktImportText "$file" -o "$output_file"
done
