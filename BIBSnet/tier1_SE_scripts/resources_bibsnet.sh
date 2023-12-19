#!/bin/bash -l
#SBATCH -J seg_pipe
#SBATCH -N 1
#SBATCH --ntasks 20
#SBATCH --gres=gpu:1
#SBATCH --mem=80gb
#SBATCH -t 2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -p v100
#SBATCH -o output_logs/bibsnet_%A_%a.out
#SBATCH -e output_logs/bibsnet_%A_%a.err
#SBATCH -A miran045

cd run_files.cabinet

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
