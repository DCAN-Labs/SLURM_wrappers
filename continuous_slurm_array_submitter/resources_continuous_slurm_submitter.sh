#!/bin/bash -l
#SBATCH -J continuous_slurm_submitter
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --cpus-per-task=1
#SBATCH --mem=6gb
#SBATCH -t 168:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -p max
#SBATCH -o continuous_slurm_submitter_%A.out
#SBATCH -e continuous_slurm_submitter_%A.err
#SBATCH -A ACCOUNT

source /home/umii/hendr522/SW/miniconda3/etc/profile.d/conda.sh

python continuous_slurm_submitter.py --partition small,amdsmall --job-name abcd-hcp-pipeline_full --log-dir cont_slurm_submitter_logs --run_folder /home/miran045/hough129/Documents/ABIDE_processing/slurm_abcd-hcp-pipeline_scripts_with_s3_routines_with_ses/run_files.abcd-hcp-pipeline_full/ --n_cpus 8 --time_limit 48:00:00 --total_memory 20 --tmp_storage 100 --array-size 1000 --submission-interval 300 --account-name feczk001 
