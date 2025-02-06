# BASHcodes

# /projects/baker-lab/containers/fastqc/0.11.9.sif
01.runArray_FastQC.slurm 
I want to store my codes here
  GNU nano 5.6.1                                                                                                                      01.runArray_FastQC.slurm
#!/bin/bash
#SBATCH --job-name=run_fastQC # job name
#SBATCH --partition=compute  # ==queue
#SBATCH --nodes=1            # number of nodes
#SBATCH --ntasks=1          # number of cores
#SBATCH --mem-per-cpu=4G
#SBATCH --time=2:00:00      # time (HH:MM:SS)
#SBATCH --output=%x.o%A_%a      # stdout and stderr
#SBATCH --array=0-11

module load singularity

cd $SLURM_SUBMIT_DIR

module load fastqc

## Set directories
DIR="$(dirname "$(pwd)")" ## Get current parent dir=project dir
FASTQDIR=$DIR/fastqs
QCDIR=$FASTQDIR/fastqc
mkdir -p $QCDIR

## Get unique sample names
## Find all fastq.gz's, cut off GES extension, reverse and cut off path, keep sample name, sort for uniques
SAMPLES=$(find $FASTQDIR -maxdepth 1 -name "*.fastq.gz" | cut -d "_" -f 1 | rev | cut -d "/" -f1 | rev | sort -u)
##Turn the SAMPLES string into an array
ARRAY=($SAMPLES)

##Initiate job array, one job per sample in $ARRAY starting with [0]
#echo "Working on job array number $N"
## Get sample name, use as basename
SAMPLE=${ARRAY[$SLURM_ARRAY_TASK_ID]}
echo "Working on sample $SAMPLE"
## Perform FASTQC
FASTQ=$(find $FASTQDIR -maxdepth 1 -name "*$SAMPLE*")
echo $FASTQ

## Run FastQC
fastqc $FASTQ -o $QCDIR

## Chmod fastQC file
chmod -R 775 $QCDIR

