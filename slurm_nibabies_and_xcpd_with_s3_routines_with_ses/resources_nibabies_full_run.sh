#!/bin/bash -l
#SBATCH -J nibabies_full
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=1920G
#SBATCH -p msismall
#SBATCH -t 96:00:00
#SBATCH -o output_logs/nibabies_full_%A_%a.out
#SBATCH -e output_logs/nibabies_full_%A_%a.err
#SBATCH -A rando149
#SBATCH --mail-type=ALL
#SBATCH --mail-user=USER@umn.edu

cd run_files.nibabies_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
