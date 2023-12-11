#!/bin/bash -l
#SBATCH --job-name=ABCDdua
#SBATCH --time=0:30:00
#SBATCH --mem-per-cpu=30gb
#SBATCH --tmp=40gb
#SBATCH --output=output_logs/ABCCdua_%A_%a.out
#SBATCH --error=output_logs/ABCCdua_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -A smnelson
#SBATCH -p small,amdsmall,amd512,ram256g

cd run_files.dua

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}

#agate partitions: agsmall,ag2tb