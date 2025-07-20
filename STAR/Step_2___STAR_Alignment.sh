
#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Load STAR and Samtools modules

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

# Path to the genome FASTA file:
Genome_FASTA=""

# Path to the annotation GTF file:
Annotation_GTF=""

# Path to the input directory containing FASTQ files:
Input_Directory=""

# Output directory for alignment results:
Output_Directory=""

# Created the STAR reference genome directory:
Reference=""

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

# Choose the number of threads (15 is placed here but it can be changed)
Number_Of_Threads=15

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Loop through each pair of paired FASTQ files in the input directory and subdirectories
for forward_file in "${Input_Directory}"/*_R1.fq; do
    # Extract the file name without extension
    file_name=$(basename "${forward_file}" _R1.fq)

    # Path to the corresponding reverse FASTQ file
    reverse_file="${forward_file/_R1/_R2}"

    echo "Forward File: ${forward_file}"
    echo "Reverse File: ${reverse_file}"
    echo "Output Directory: ${Output_Directory}"

    # Create a unique temporary directory for this sample
    TMPDIR="${Output_Directory}/${file_name}___STARtmp"

    echo "The temporary directory is: ${TMPDIR}"

    # Change working directory to the output directory
    cd "${Output_Directory}"

    echo "Made temporary directory: ${TMPDIR}"

    echo "Output Directory + Prefix: ${Output_Directory}/${file_name}___"

    # Run STAR alignment
    STAR \
        --genomeDir "${Reference}" \
        --readFilesIn "${forward_file}" "${reverse_file}" \
        --outFileNamePrefix "${Output_Directory}/${file_name}_" \
        --runThreadN "${Number_Of_Threads}" \
        --genomeLoad NoSharedMemory \
        --outSAMtype BAM SortedByCoordinate \
        --outTmpDir "${TMPDIR}" \
        --outStd Log \
        --outSAMunmapped Within \
        --outSAMattributes Standard

done

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
