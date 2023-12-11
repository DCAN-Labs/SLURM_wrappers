#!/bin/bash -l
#SBATCH -J move_subjects
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=12gb
#SBATCH --tmp=200gb
#SBATCH -t 8:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -p msismall
#SBATCH -o output_logs/abcd-hcp-pipeline_full_%A_%a.out
#SBATCH -e output_logs/abcd-hcp-pipeline_full_%A_%a.err
#SBATCH -A rando149

cd run_files.move_subjects

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}

# mesabi partitions for -p are amdsmall,amd512,amd2tb,ram256g,ram1t
