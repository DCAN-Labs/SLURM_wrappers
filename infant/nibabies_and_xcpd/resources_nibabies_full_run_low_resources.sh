#!/bin/bash -l
#SBATCH -J nibabies_low
#SBATCH -c 32
#SBATCH --mem=240G
#SBATCH -t 12:00:00
#SBATCH -p msismall
#SBATCH -o output_logs/nibabies_low_%A_%a.out
#SBATCH -e output_logs/nibabies_low_%A_%a.err
#SBATCH -A rando149
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com

cd run_files.nibabies_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}