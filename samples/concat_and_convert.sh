#!/bin/bash

for f in *.FASTQ *.fastq; do
    # If no file exists, skip
    [ -e "$f" ] || continue

    # sed -i '$a\' adds a newline at the end of file
    sed -i -e '$a\' "$f"
done


# Detect all sample names
# FASTQ parts are named like:
#  sampleA_part1.FASTQ
#       sampleA_part2.FASTQ

# Stripping "_partX.FASTQ". So sampleA_part123.FASTQ > sampleA

samples=$(ls *_part*.FASTQ 2>/dev/null | sed 's/_part[0-9]*\.FASTQ//' | sort -u)
#this lists the files in the directory (doesn't modify any files)
#sed removes _partX.FASTQ from each filename as text
# -u removes duplicates

#Loop through each detected sample (sampleA, sampleB, …)

for sample in $samples; do
    # Define output file names
    combined_fastq="${sample}.fastq"
    output_fasta="${sample}.fasta"

    # Combine all parts for each sample
    # Example:
    # cat sampleA_part1.FASTQ sampleA_part2.FASTQ sampleA_part3.FASTQ > sampleA.fastq
    # DO NOT assume each file is 4-line FASTQ because some are broken.

    cat ${sample}_part*.FASTQ > "$combined_fastq"


 # Detect headers starting with "@sample"
 # treat following lines as sequence until we find "+"
 # ignore all quality lines

    {
        echo ">${sample}"
# First line in FASTA = >sampleName

        # awk parser:
        # /^@sample/   → when a header begins, start capturing sequence
        # next lines   → sequence until we hit "+"
        # "+" line     → quality begins → stop capturing

        awk '
            # If line starts with @sample, we expect sequence next
            /^@'"$sample"'/ { inseq=1; next }

            # When we hit a plus line, sequence is finished
            inseq==1 && $0=="+" { inseq=0; next }

            # If in sequence mode, print the line
            inseq==1 { print; next }
        ' "$combined_fastq"

    } > "$output_fasta"

done
