#!/bin/bash -l

#SBATCH -J template_matching
#SBATCH --ntasks=164
#SBATCH --tmp=120gb
#SBATCH --mem=120gb
#SBATCH -t 04:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lundq163@umn.edu
#SBATCH -p ag2tb,agsmall,aglarge
#SBATCH -o output_logs/TM_%A_%a.out
#SBATCH -e output_logs/TM_%A_%a.err
#SBATCH -A aopitz

cd run_files.TM_full

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
