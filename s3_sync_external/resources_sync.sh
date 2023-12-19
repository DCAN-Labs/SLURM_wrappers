#!/bin/bash -l
#SBATCH -J ABIDE_sync
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=1
#SBATCH --mem=20gb
#SBATCH --tmp=20gb
#SBATCH -t 2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hough129@umn.edu
#SBATCH -p small,amdsmall
#SBATCH -o output_logs/sync_%A_%a.out
#SBATCH -e output_logs/sync_%A_%a.err
#SBATCH -A miran045

cd run_files.sync

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
