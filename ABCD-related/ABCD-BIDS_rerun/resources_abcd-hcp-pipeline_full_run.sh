#!/bin/bash -l
#SBATCH -J abcd-hcp-pipeline_full
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --cpus-per-task=1
#SBATCH --mem=100gb
#SBATCH --tmp=100gb
#SBATCH -t 72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -p amd512,amdsmall,ram1t,ram256g
#SBATCH -o output_logs/abcd-hcp-pipeline_full_%A_%a.out
#SBATCH -e output_logs/abcd-hcp-pipeline_full_%A_%a.err
#SBATCH -A rando149

cd run_files.abcd-hcp-pipeline_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
