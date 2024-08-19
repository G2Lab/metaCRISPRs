#!/bin/bash
#SBATCH --job-name=merge_directories_crisprdata2
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=knurge@nygenome.org
#SBATCH --output=stdout_%j.log

for project_folder in /gpfs/commons/groups/gursoy_lab/knurge/crisprdata2/*; do
    proj_name=$(basename "$project_folder")

    export proj_name

    find "$project_folder" -mindepth 1 -maxdepth 5 -type f \( -name "*.fna" -o -name "*.fasta" \) -exec bash -c '
        for data; do
            file_name=$(basename "$data")
            dest="/gpfs/commons/groups/gursoy_lab/knurge/crisprdata2/${proj_name}__${file_name%.*}.fna"
            mv "$data" "$dest"
        done
    ' bash {} +
    rm -rf "$project_folder"
done
