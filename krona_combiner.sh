#!/bin/bash

# Directory path where the files are located
directory=($pwd)

# Output file name
output_file="combined.html"

# Collect all the filenames in the directory ending with ".html"
files=()
while IFS= read -r -d '' file; do
    files+=("$file")
done < <(find . -maxdepth 1 -type f -name "*_processed.tsv" -print0)

# Check if any files are found
if [ ${#files[@]} -eq 0 ]; then
    echo "No HTML files found in the directory."
    exit
fi

# Run ktImportKrona command on each file
ktImportKrona_cmd="ktImportText -c ${files[*]} -o $output_file"
echo "$ktImportKrona_cmd"
eval "$ktImportKrona_cmd"

echo "Combined file created: $output_file"
