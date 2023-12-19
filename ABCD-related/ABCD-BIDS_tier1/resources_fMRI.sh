#!/bin/bash -l
#SBATCH -J fMRI_ABCD-HCP
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=1
#SBATCH --mem=15gb
#SBATCH -t 12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -p small,amdsmall
#SBATCH -o output_logs/fMRI_%A_%a.out
#SBATCH -e output_logs/fMRI_%A_%a.err
#SBATCH -A miran045

cd run_files.fMRI

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}