#!/bin/bash -l
#SBATCH -J Rtemp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5gb
#SBATCH --tmp=10gb
#SBATCH -t 00:20:00
#SBATCH -o output_logs/Rtemp_%A_%a.out
#SBATCH -e output_logs/Rtemp_%A_%a.err
#SBATCH -A GROUP

cd run_files.Rtemp

module load R

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}