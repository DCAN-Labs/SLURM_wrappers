#!/bin/bash -l
#SBATCH -J QSIprep
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=20gb
#SBATCH --tmp=30gb
#SBATCH -t 24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -p small,amdsmall
#SBATCH -o output_logs/QSIprep_%A_%a.out
#SBATCH -e output_logs/QSiprep_%A_%a.err
#SBATCH -A faird

cd run_files.QSIprep

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}

