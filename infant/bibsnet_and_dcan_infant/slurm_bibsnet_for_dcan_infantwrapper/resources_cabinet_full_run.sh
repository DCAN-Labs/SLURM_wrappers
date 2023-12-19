#!/bin/bash -l
#SBATCH -J seg_pipe_dcaninfant
#SBATCH -N 1
#SBATCH --ntasks 4
#SBATCH --mem=80gb
#SBATCH --tmp=40gb
#SBATCH -t 12:00:00
#SBATCH -p v100
#SBATCH --gres=gpu:v100:1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lundq163@umn.edu
#SBATCH -o output_logs/cabinet_full_%A_%a.out
#SBATCH -e output_logs/cabinet_full_%A_%a.err
#SBATCH -A miran045

cd run_files.cabinet_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
