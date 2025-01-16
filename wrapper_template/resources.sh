#!/bin/bash -l
#SBATCH -J process
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100gb
#SBATCH -t 24:00:00
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=ALL
#SBATCH --tmp=100gb
#SBATCH -p agsmall,ag2tb
#SBATCH -o output_logs/process_%A_%a.out
#SBATCH -e output_logs/process_%A_%a.err
#SBATCH -A GROUP

cd run_files

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
