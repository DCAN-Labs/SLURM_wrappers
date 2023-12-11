#!/bin/bash -l
#SBATCH -J nibabies_full
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=1920G
#SBATCH -p amd2tb,ag2tb
#SBATCH -t 96:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -o output_logs/nibabies_full_%A_%a.out
#SBATCH -e output_logs/nibabies_full_%A_%a.err
#SBATCH -A rando149

cd run_files.nibabies_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
