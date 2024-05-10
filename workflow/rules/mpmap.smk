rule mpmap:
    input:
        gcsa = os.path.join(index_outpath, "hprc-v1.1-mc-grch38.spliced.gcsa"),
        xg = os.path.join(index_outpath, "hprc-v1.1-mc-grch38.spliced.xg"),
        dist = os.path.join(index_outpath, "hprc-v1.1-mc-grch38.spliced.dist"),
        read1 = os.path.join(trim_path, "{testsample}_1.fastq.gz"),
        read2 = os.path.join(trim_path, "{testsample}_2.fastq.gz"),


    output: 
        gamp = os.path.join(map_outpath, "{testsample}.gamp")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "mpmmap", "{testsample}.mpmap.log") 
    params:
        nt = config['mpmap']['nt_type']
    threads: 32
    resources:
        runtime = "6h",
        mem_mb = 140000,

    shell:
        """
        # Map reads to spliced graphs without multimapping
        # Add -M 10 -U (from Sibbessen paper), unsure what the -U is. 
        vg mpmap \
        -t {threads} \
        -n {params.nt} \
        -x {input.xg} \
        -g {input.gcsa} \
        -d {input.dist} \
        -f {input.read1} \
        -f {input.read2} > {output.gamp}

        """

# vg mpmap
# usage: vg mpmap [options] -x graph.xg -g index.gcsa [-f reads1.fq [-f reads2.fq] | -G reads.gam] > al
# n.gamp
# Multipath align reads to a graph.
# basic options:
# graph/index:
#   -x, --graph-name FILE     graph (required; XG format recommended but other formats are valid, see `vg convert`) 
#   -g, --gcsa-name FILE      use this GCSA2/LCP index pair for MEMs (required; both FILE and FILE.lcp, see `vg index`)
#   -d, --dist-name FILE      use this snarl distance index for clustering (recommended, see `vg index`)
#   -s, --snarls FILE         align to alternate paths in these snarls (unnecessary if providing -d, see `vg snarls`)
# input:
#   -f, --fastq FILE          input FASTQ (possibly gzipped), can be given twice for paired ends (for stdin use -)
#   -i, --interleaved         input contains interleaved paired ends
# algorithm presets:
#   -n, --nt-type TYPE        sequence type preset: 'DNA' for genomic data, 'RNA' for transcriptomic data [RNA]
#   -l, --read-length TYPE    read length preset: 'very-short', 'short', or 'long' (approx. <50bp, 50-500bp, and >500bp) [short]
#   -e, --error-rate TYPE     error rate preset: 'low' or 'high' (approx. PHRED >20 and <20) [low]
# output:
#   -F, --output-fmt TYPE     format to output alignments in: 'GAMP for' multipath alignments, 'GAM' or 'GAF' for single-path
#                             alignments, 'SAM', 'BAM', or 'CRAM' for linear reference alignments (may also require -S) [GAMP]
#   -S, --ref-paths FILE      paths in the graph either 1) one per line in a text file, or 2) in an HTSlib .dict, to treat as
#                             reference sequences for HTSlib formats (see -F) [all paths]
#   -N, --sample NAME         add this sample name to output
#   -R, --read-group NAME     add this read group to output
#   -p, --suppress-progress   do not report progress to stderr
# computational parameters:
#   -t, --threads INT         number of compute threads to use [all available]

# advanced options:
# algorithm:
#   -X, --not-spliced         do not form spliced alignments, even if aligning with --nt-type 'rna'
#   -M, --max-multimaps INT   report (up to) this many mappings per read [10 rna / 1 dna]
#   -a, --agglomerate-alns    combine separate multipath alignments into one (possibly disconnected) alignment
#   -r, --intron-distr FILE   intron length distribution (from scripts/intron_length_distribution.py)
#   -Q, --mq-max INT          cap mapping quality estimates at this much [60]
#   -b, --frag-sample INT     look for this many unambiguous mappings to estimate the fragment length distribution [1000]
#   -I, --frag-mean FLOAT     mean for a pre-determined fragment length distribution (also requires -D)
#   -D, --frag-stddev FLOAT   standard deviation for a pre-determined fragment length distribution (also requires -I)
#   -G, --gam-input FILE      input GAM (for stdin, use -)
#   -u, --map-attempts INT    perform (up to) this many mappings per read (0 for no limit) [24 paired / 64 unpaired]
#   -c, --hit-max INT         use at most this many hits for any match seeds (0 for no limit) [1024 DNA / 100 RNA]
# scoring:
#   -A, --no-qual-adjust      do not perform base quality adjusted alignments even when base qualities are available
#   -q, --match INT           use this match score [1]
#   -z, --mismatch INT        use this mismatch penalty [4 low error, 1 high error]
#   -o, --gap-open INT        use this gap open penalty [6 low error, 1 high error]
#   -y, --gap-extend INT      use this gap extension penalty [1]
#   -L, --full-l-bonus INT    add this score to alignments that align each end of the read [mismatch+1 short, 0 long]
#   -w, --score-matrix FILE   read a 4x4 integer substitution scoring matrix from a file (in the order ACGT)
#   -m, --remove-bonuses      remove full length alignment bonuses in reported scores