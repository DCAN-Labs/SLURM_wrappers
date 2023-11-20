#!/bin/bash -l
#SBATCH -J abcd-hcp-pipeline_full
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=100gb
#SBATCH --tmp=100gb
#SBATCH -t 50:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lundq163@umn.edu
#SBATCH -p ag2tb,aglarge
#SBATCH -o output_logs/abcd-hcp-pipeline_full_%A_%a.out
#SBATCH -e output_logs/abcd-hcp-pipeline_full_%A_%a.err
#SBATCH -A smnelson

cd run_files.abcd-hcp-pipeline_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
