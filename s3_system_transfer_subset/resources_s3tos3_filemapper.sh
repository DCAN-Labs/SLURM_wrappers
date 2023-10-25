#!/bin/bash -l
#SBATCH -J s3tos3_filemap
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb
#SBATCH --tmp=20gb
#SBATCH -t 00:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fayzu001@umn.edu
#SBATCH -p amdsmall,amdlarge,amd512,amd2tb,small,large,ram256g,ram1t
#SBATCH -o output_logs/s3tos3_filemapper_%A_%a.out
#SBATCH -e output_logs/s3tos3_filemapper_%A_%a.err
#SBATCH -A feczk001

cd run_files.s3tos3_filemap

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
