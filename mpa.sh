#!/bin/bash

# Set the directory containing the fastq files
input_dir=$(pwd)
# Set the output directory for contigs
output_dir=$(pwd)

# Loop through the fastq files in the input directory
for fastq_file in "$input_dir"/*.fastq; do
    if [ -f "$fastq_file" ]; then
        # Extract the SRR number from the file name
        SRR_NUMBER=$(basename "$fastq_file" .fastq)

        # Run the spades.py command
        metaphlan "${SRR_NUMBER}.fastq" --bowtie2out "metagenome_${SRR_NUMBER}.bowtie2.bz2" --bt2_ps sensitive-local --nproc 8 --input_type fastq --stat_q 0.05 -o "profiled_${SRR_NUMBER}.txt"
        echo "Processed $srr_number"
    fi
done