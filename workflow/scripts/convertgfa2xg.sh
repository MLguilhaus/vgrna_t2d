#!/bin/bash
# convert gfa 


#SBATCH -p icelake
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --ntasks-per-core=2
#SBATCH --time=3:00:00
#SBATCH --mem=80GB
#SBATCH --job-name vgconv
#SBATCH -o /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.out
#SBATCH -e /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.err


# Notification configuration
#SBATCH --mail-type=ALL
#SBATCH --mail-user=monica.guilhaus@gmail.com
source /home/a1627307/.bashrc
mamba activate ./hpcfs/users/a1627307/envs/8a9599ed8d4fd695445e03e783eab8c5_

# Set input files and threads
GFA="/hpcfs/users/a1627307/genome/hprc-v1.1-mc-grch38.gfa"
OUTXG="/hpcfs/users/a1627307/vgrna_t2d/data/index/HPRC/hprc-v1.1-mc-grch38.xg"
LOG="/hpcfs/users/a1627307/vgrna_t2d/workflow/logs/scripts/convertgfa2xg.log"
CPU=32

# use vg convert to convert the HPRC GFA to an xg to compare to the vcf fa build
vg convert \
    -g ${GFA} \
    -x > ${OUTXG} 2>> ${LOG}