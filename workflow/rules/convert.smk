rule convert:
    input:
        vg = os.path.join(graph_outpath, "chr1.vg")

    output: 
        # pg = os.path.join(graph_outpath, "hprc-v1.1-mc-grch38.pg")
        chrpg = os.path.join(graph_outpath, "chr1.pg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "convert", "chr1.convert.log") 
    threads: 32
    resources:
        runtime = "2h",
        mem_mb = 10000,

    shell:
        """

        echo -e "starting at $(date)" > {log}

        vg convert \
        -t {threads} \
        {input.vg} \
        > {output.chrpg} &>> {log}

        echo -e "conversion completed at $(date)" >> {log}

        """

# rule convert:
#     input:
#         gfa = gfa_full_path,

#     output: 
#         pg = os.path.join(graph_outpath, "hprc-v1.1-mc-grch38.pg")

#     conda: "../envs/vg.yml"
#     log: os.path.join(log_path, "convert", "convert.log") 
#     threads: 16
#     resources:
#         runtime = "4h",
#         mem_mb = 100000,

#     shell:
#         """

#         echo -e "starting at $(date)" > {log}

#         set -x

#         vg convert \
#         -t {threads} \
#         --gfa-in {input.gfa} \
#         -p  > {output.pg} 2>> {log}

#         set +x

#         echo -e "conversion completed at $(date)" >> {log}

#         """

# vg convert
# usage: vg convert [options] <input-graph>
# input options:
#     -g, --gfa-in           input in GFA format
#     -r, --in-rgfa-rank N   import rgfa tags with rank <= N as paths [default=0]
#     -b, --gbwt-in FILE     input graph is a GBWTGraph using the GBWT in FILE
#         --ref-sample STR   change haplotypes for this sample to reference paths (may repeat)
# gfa input options (use with -g):
#     -T, --gfa-trans FILE   write gfa id conversions to FILE
# output options:
#     -v, --vg-out           output in VG's original Protobuf format [DEPRECATED: use -p instead].
#     -a, --hash-out         output in HashGraph format
#     -p, --packed-out       output in PackedGraph format [default]
#     -x, --xg-out           output in XG format
#     -f, --gfa-out          output in GFA format
#     -H, --drop-haplotypes  do not include haplotype paths in the output
#                            (useful with GBWTGraph / GBZ inputs)
# gfa output options (use with -f):
#     -P, --rgfa-path STR    write given path as rGFA tags instead of lines
#                            (multiple allowed, only rank-0 supported)
#     -Q, --rgfa-prefix STR  write paths with given prefix as rGFA tags instead of lines
#                            (multiple allowed, only rank-0 supported)
#     -B, --rgfa-pline       paths written as rGFA tags also written as lines
#     -W, --no-wline         Write all paths as GFA P-lines instead of W-lines.
#                            Allows handling multiple phase blocks and subranges used together.
#     --gbwtgraph-algorithm  Always use the GBWTGraph library GFA algorithm.
#                            Not compatible with other GFA output options or non-GBWT graphs.
#     --vg-algorithm         Always use the VG GFA algorithm. Works with all options and graph types,
#                            but can't preserve original GFA coordinates.
#     --no-translation       When using the GBWTGraph algorithm, convert the graph directly to GFA.
#                            Do not use the translation to preserve original coordinates.
# alignment options:
#     -G, --gam-to-gaf FILE  convert GAM FILE to GAF
#     -F, --gaf-to-gam FILE  convert GAF FILE to GAM
# general options:
#     -t, --threads N        use N threads (defaults to numCPUs)