#!/bin/bash -l

#SBATCH -J crossotope
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=8gb
#SBATCH --tmp=100G
#SBATCH --time=35:00:00
#SBATCH -p amd512,amdsmall,amdlarge,ram256g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mmahmoud@umn.edu
#SBATCH -o output_logs/crossotope_%A_%a.out
#SBATCH -e output_logs/crossotope_%A_%a.err
#SBATCH -A feczk001

cd run_files.crossotope_full

module purge
module load python3 matlab/R2019a

export PATH="/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/:${PATH}"
which wb_command

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
