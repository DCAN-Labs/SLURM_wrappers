#!/bin/bash -l
#SBATCH -J nibabies_low
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=240G
#SBATCH -t 48:00:00
#SBATCH -p msismall
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -o output_logs/nibabies_low_%A_%a.out
#SBATCH -e output_logs/nibabies_low_%A_%a.err
#SBATCH -A rando149

cd run_files.nibabies_full_low_resources

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
