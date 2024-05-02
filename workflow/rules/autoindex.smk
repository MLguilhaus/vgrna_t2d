rule autoindex:
    input:
        gfa = os.path.join(graph_outpath, "chr22.gfa"),
        chr_gtf = os.path.join(
            annotation_outpath, "chr22." + annotationbase + "-renamed.gtf" 
        ),

    output: 
        gcsa = os.path.join(index_outpath, "chr22_autoindex_spliced.gcsa"),
        xg = os.path.join(index_outpath, "chr22_autoindex_spliced.xg"),
        dist = os.path.join(index_outpath, "chr22_autoindex_spliced.dist")
    # input:
    #     #  gfa = gfa_path,
    #     gfa = gfa_full_path,
    #     gtf = gtf_rn,

    # output: 
    #     gcsa = os.path.join(index_outpath, "hprc-v1.1-mc-grch38_spliced.gcsa"),
    #     xg = os.path.join(index_outpath, "hprc-v1.1-mc-grch38_spliced.xg"),
    #     dist = os.path.join(index_outpath, "hprc-v1.1-mc-grch38_spliced.dist")   

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "autoindex", "chr22.autoindex.log") 
    params:
        workflow = config['autoindex']['workflow'],
        out_prefix = os.path.join(index_outpath, "vg_rna"),
        temp_dir = ("/tmp/vgrna")
    threads: 32
    resources:
        runtime = "5h",
        mem_mb = 100000,

    shell:
        """

        vg autoindex \
            -w {params.workflow} \
            -t {threads} \
            -T {params.temp_dir}
            -p {params.out_prefix} \
            -g {input.gfa} \
            -x {input.chr_gtf} \
            -V 2 &>> {log}

        """
        
# rule copy_index_logs:
#     input:
#         "logs/autoindex.log"
#     output:
#         "logs/autoindex--{jobid}.log"
#     params:
#         jobid=lambda wildcards: cluster.jobid,
#         rule = "{autoindex}"
    
#     threads: 1
#     resources:
#         runtime = "1m"
#     shell:
#         """
#         cp {input} {output}
  
#         """

### May be able to run this still with GFA but need to check gtf file
### Also will need to use unclipped graph and ensure #0 is removed from path names?
### https://github.com/vgteam/vg/issues/4015

            #--tmp-dir {params.temp_dir}

        # ## Cleanup the temp_dir
        # if [[ -d {params.temp_dir} ]]; then
        #     echo -e "Deleting {params.temp_dir}" >> {log}
        #     rm -rf {params.temp_dir}
        # fi

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