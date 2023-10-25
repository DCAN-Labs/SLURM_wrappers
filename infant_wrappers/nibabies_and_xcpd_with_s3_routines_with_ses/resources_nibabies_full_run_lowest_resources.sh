#!/bin/bash -l
#SBATCH -J nibabies_full_lowest
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=240G
#SBATCH -t 8:00:00
#SBATCH -p msismall
#SBATCH -o output_logs/nibabies_full_lowest%A_%a.out
#SBATCH -e output_logs/nibabies_full_lowest%A_%a.err
#SBATCH -A rando149

cd run_files.nibabies_full_low_resources

module load singularity
echo `pwd`
file=run${SLURM_ARRAY_TASK_ID}
echo `pwd`
echo `ls`
bash ${file}
