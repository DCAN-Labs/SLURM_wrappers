#!/bin/bash -l
#SBATCH -J customclean
#SBATCH --mem=60gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=reine097@umn.edu
#SBATCH -o output_logs/customclean_%A_%a.out
#SBATCH -e output_logs/customclean_%A_%a.err
#SBATCH -A faird
#SBATCH --time=5:00:00
#SBATCH -p msismall,ram256g

cd run_files.abcd-hcp-pipeline_infant

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}

#--ntasks=24
#--tmp=200gb