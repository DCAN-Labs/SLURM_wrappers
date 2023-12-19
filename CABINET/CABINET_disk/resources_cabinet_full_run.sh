#!/bin/bash -l

#SBATCH -t 48:00:00
#SBATCH -N 1
#SBATCH -c 24
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=240gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lundq163@umn.edu@umn.edu
#SBATCH -p a100-4
#SBATCH -o output_logs/cabinet_full_%A_%a.out
#SBATCH -e output_logs/cabinet_full_%A_%a.err
#SBATCH -J cabinet
#SBATCH -A faird

cd run_files.cabinet_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
