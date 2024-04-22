#!/bin/bash
# find gtf paths


#SBATCH -p icelake
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --ntasks-per-core=2
#SBATCH --time=3:00:00
#SBATCH --mem=50GB
#SBATCH --job-name vgpath
#SBATCH -o /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.out
#SBATCH -e /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.err


# Notification configuration
#SBATCH --mail-type=ALL
#SBATCH --mail-user=monica.guilhaus@gmail.com
mamba init
mamba activate ./hpcfs/users/a1627307/envs/8a9599ed8d4fd695445e03e783eab8c5_

vg paths -M -x /hpcfs/users/a1627307/genome/hprc-v1.1-mc-grch38.gfa | head > /hpcfs/users/a1627307/genome/hprc-v1.1-mc-grch38_paths.txt