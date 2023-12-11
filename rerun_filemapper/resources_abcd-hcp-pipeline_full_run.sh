#!/bin/bash -l
#SBATCH -J abcd-hcp-pipeline_full
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=24gb
#SBATCH --tmp=200gb
#SBATCH -t 2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -p msismall
#SBATCH -o output_logs/abcd-hcp-pipeline_full_%A_%a.out
#SBATCH -e output_logs/abcd-hcp-pipeline_full_%A_%a.err
#SBATCH -A rando149

cd run_files.abcd-hcp-pipeline_s3error_rerun

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}

# mesabi partitions for -p are amdsmall,amd512,amd2tb,ram256g,ram1t
