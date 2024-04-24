#!/bin/bash -l
#SBATCH --job-name=dcm2bids
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=80gb
#SBATCH -o output_logs/dcm2bids_%A_%a.out
#SBATCH -e output_logs/dcm2bids_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -A faird
#SBATCH -p agsmall,ag2tb

cd run_files.dcm2bids

source /home/faird/shared/code/external/envs/miniconda3/load_miniconda3.sh
conda activate dcm2bids

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
