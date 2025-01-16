#!/bin/bash -l
#SBATCH -J xcpd
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -c 8
#SBATCH --mem=100G
#SBATCH -t 8:00:00
#SBATCH -p ag2tb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=EMAIL
#SBATCH -o output_logs/xcpd_full_%A_%a.out
#SBATCH -e output_logs/xcpd_full_%A_%a.err
#SBATCH -A GROUP

cd run_files.xcpd

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
