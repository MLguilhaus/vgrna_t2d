rule autoindex:
    input:
         gfa = graph_path
         gtf = gtf_path

    output: 
    gcsa    = os.path.join(index_outpath, "vg_rna.spliced.gcsa"),
    xg      = os.path.join(index_outpath, "vg_rna.spliced.xg"),
    dist    = os.path.join(index_outpath, "vg_rna.spliced.dist")

    conda: "../envs/autoindex.yml"
    log: os.path.join(log_path, "autoindex", "autoindex.log") 
    params:
        workflow = config['autoindex']['workflow'],
        out_prefix = os.path.join(index_outpath, "vg_rna"),
        temp_dir = os.path.join(index_outpath, "_indextmp")
    threads: 16
    resources:
        runtime = "10h",
        mem_mb = 120000,
        disk_mb = 10000
    shell:
        """
        vg autoindex \
            --workflow {params.workflow} \
            --threads {threads} \
            -prefix {params.out_prefix} \
            --gfa {input.gfa} \
            --tx-gff {input.gtf} \
            --tmp-dir {params.temp_dir}

        # ## Cleanup the temp_dir
        # if [[ -d {params.temp_dir} ]]; then
        #     echo -e "Deleting {params.temp_dir}" >> {log}
        #     rm -rf {params.temp_dir}
        # fi
        """
        



#     usage: ./vg autoindex [options]
# options:
#   output:
#     -p, --prefix PREFIX    prefix to use for all output (default: index)
#     -w, --workflow NAME    workflow to produce indexes for, can be provided multiple
#                            times. options: map, mpmap, rpvg, giraffe (default: map)
#   input data:
#     -r, --ref-fasta FILE   FASTA file containing the reference sequence (may repeat)
#     -v, --vcf FILE         VCF file with sequence names matching -r (may repeat)
#     -i, --ins-fasta FILE   FASTA file with sequences of INS variants from -v
#     -g, --gfa FILE         GFA file to make a graph from
#     -x, --tx-gff FILE      GTF/GFF file with transcript annotations (may repeat)
#     -H, --hap-tx-gff FILE  GTF/GFF file with transcript annotations of a named haplotype (may repeat)
#   configuration:
#     -f, --gff-feature STR  GTF/GFF feature type (col. 3) to add to graph (default: exon)
#     -a, --gff-tx-tag STR   GTF/GFF tag (in col. 9) for transcript ID (default: transcript_id)
#   logging and computation:
#     -T, --tmp-dir DIR      temporary directory to use for intermediate files
#     -M, --target-mem MEM   target max memory usage (not exact, formatted INT[kMG])
#                            (default: 1/2 of available)
#     -t, --threads NUM      number of threads (default: all available)
#     -V, --verbosity NUM    log to stderr (0 = none, 1 = basic, 2 = debug; default 1)
#     -h, --help             print this help message to stderr and exit