#!/bin/bash -l
#SBATCH -J fmriprep_full_low
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -c 24
#SBATCH --mem=240G
#SBATCH -t 48:00:00
#SBATCH -p msismall
#SBATCH --mail-type=ALL
#SBATCH --mail-user=EMAIL
#SBATCH -o output_logs/fmriprep_full_%A_%a.out
#SBATCH -e output_logs/fmriprep_full_%A_%a.err
#SBATCH -A GROUP

cd run_files.fmriprep_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
