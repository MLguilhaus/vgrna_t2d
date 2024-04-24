#!/bin/bash
# subset gfa


#SBATCH -p icelake
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --ntasks-per-core=2
#SBATCH --time6:00:00
#SBATCH --mem=100GB
#SBATCH --job-name subset_gfa
#SBATCH -o /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.out
#SBATCH -e /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.err


# Notification configuration
#SBATCH --mail-type=ALL
#SBATCH --mail-user=monica.guilhaus@gmail.com

source /home/a1627307/.bashrc
mamba activate /hpcfs/users/a1627307/envs/8a9599ed8d4fd695445e03e783eab8c5_

# Set input files and threads
INPUTGFA="/hpcfs/users/a1627307/genome/hprc-v1.1-mc-grch38.full.gfa"
OUTDIR="/hpcfs/users/a1627307/vgrna_t2d/data/graph"
CPU=32


# Split gfa file into chr chunks
        vg chunk \
        -t $CPU\
        -x $INPUTGFA \
        -C -O gfa \
        > "$OUTDIR/chunk.gfa"