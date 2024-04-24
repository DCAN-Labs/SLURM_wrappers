#!/bin/bash -l
#SBATCH -J nnunet
#SBATCH -t 2:00:00
#SBATCH -p v100
#SBATCH --gres=gpu:v100:2
#SBATCH --mem=150gb
#SBATCH --ntasks 1
#SBATCH --cpus-per-task=24
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stoye003@umn.edu
#SBATCH -o output_logs/nnunet_%A_%a.out
#SBATCH -e output_logs/nnunet_%A_%a.err
#SBATCH -A feczk001

cd run_files.nnunet_full

## build script here
module load gcc cuda/11.2
source /panfs/roc/msisoft/anaconda/anaconda3-2018.12/etc/profile.d/conda.sh
conda activate /home/support/public/torch_cudnn8.2

export nnUNet_raw_data_base="/home/feczk001/shared/data/nnUNet/nnUNet_raw_data_base"
export nnUNet_preprocessed="/home/feczk001/shared/data/nnUNet/nnUNet_raw_data_base/nnUNet_preprocessed"
export RESULTS_FOLDER="/home/feczk001/shared/data/nnUNet/nnUNet_raw_data_base/nnUNet_trained_models"

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
