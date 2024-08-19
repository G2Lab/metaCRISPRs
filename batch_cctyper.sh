#!/bin/bash
#SBATCH --mem=750G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=cctyper_crisprdata4_batch17_200
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=knurge@nygenome.org
#SBATCH --output=stdout_%j.log
#SBATCH --partition=bigmem

source activate cctyper

# Set the directory paths
input_directory="/gpfs/commons/groups/gursoy_lab/knurge/crisprdata4"
output_directory="/gpfs/commons/groups/gursoy_lab/knurge/crisprdata4/cctyper_output_batch17"

# Function to process a single file
process_file() {

    file="$1"
    echo "STARTED RUNNING: $file"

    if [[ -f $file ]]; then

        # Create the output folders
        filename=$(basename "$file" | sed 's/\(_\|.\)contigs_ftd\.fasta//')
        output_folder="/gpfs/commons/groups/gursoy_lab/knurge/crisprdata4/cctyper_output_batch17/${filename}"
        
        # Run cctyper
        stdbuf -oL -eL cctyper "$file" "$output_folder" --prodigal meta --no_plot  -t 40 2>&1
        echo "FINISHED RUNNING: $filename" >> "/gpfs/commons/groups/gursoy_lab/knurge/crisprdata4/cctyper_output_batch17/cctyper_batch17_finished.log"
        
    fi
}

export -f process_file  # Export the function for use with parallel

# List files and pass to parallel for processing
batch_files=$(find "$input_directory" -maxdepth 1 -name "*.fasta*" -type f -print0 | du --files0-from=- | sort -nk1,1 | awk '$1 >= 1000000' | cut -f2- | head -n 300)
echo "$batch_files" | parallel --tmpdir /gpfs/commons/scratch -j20 process_file