#!/bin/bash -l
#SBATCH -J nibabies_full
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -c 120
#SBATCH --mem=960G
#SBATCH -t 48:00:00
#SBATCH -p ag2tb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=EMAIL
#SBATCH -o output_logs/nibabies_full_%A_%a.out
#SBATCH -e output_logs/nibabies_full_%A_%a.err
#SBATCH -A GROUP

cd run_files.nibabies_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
