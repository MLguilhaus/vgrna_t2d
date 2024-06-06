#!/bin/bash
# rpvg


#SBATCH -p icelake
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --ntasks-per-core=2
#SBATCH --time=6:00:00
#SBATCH --mem=80GB
#SBATCH --job-name vgconv
#SBATCH -o /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.out
#SBATCH -e /hpcfs/users/a1627307/vgrna_t2d/workflow/slurm/%x_%j.err


# Notification configuration
#SBATCH --mail-type=ALL
#SBATCH --mail-user=monica.guilhaus@gmail.com

# Load container
module load Singularity/3.10.5

# Set inputs
WORKDIR="/hpcfs/users/a1627307/vgrna_t2d"
SAMPLE=("$WORKDIR/output/mpmap/*.full.gamp") 
XG="$WORKDIR/data/index/vcf_fa_full/blackochre/hprc-v1.1-mc-grch38-gencode45.spliced.xg"
GBWT="$WORKDIR/data/index/vcf_fa_full/blackochre/hprc-v1.1-mc-grch38-gencode45.haplotx.gbwt"
INFO="$WORKDIR/data/index/vcf_fa_full/blackochre/hprc-v1.1-mc-grch38-gencode45.txorigin.tsv"

THREADS=16        # Set the number of threads as needed
SEED=622797          # Set the seed parameter as needed


for SAMPLE in "${SAMPLES[@]}"; do
  #Base name of the sample file
  BASENAME=$(basename "$SAMPLE" .full.gamp)
  
  # Define the log file path based on the sample base name
  LOG="$WORKDIR/workflow/logs/rpvg/${BASENAME}.sh.log"
  
  # Your command here, for example:
  echo "Processing $SAMPLE, logging to $LOG"

    singularity run /hpcfs/users/a1627307/vgrna_t2d/rpvg/rpvg_latest.sif \
    rpvg \
        -t "$THREADS" \
        -r "$SEED" \
        -i haplotype-transcripts \
        -g "$XG" \
        -p "$GBWT" \
        -a "$SAMPLE" \
        -f "$INFO" \
        -o "$WORKDIR/workflow/output/${BASENAME}_rpvg" \
        2>> "$LOG"
done