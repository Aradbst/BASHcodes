ml singularity 
singularity pull fastqc.sif docker://biocontainers/fastqc
singularity exec fastqc.sif fastqc [my file].fastq.gz
https://hub.docker.com/r/biocontainers/fastqc
