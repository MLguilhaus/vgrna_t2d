# All stats and paths diagnostics in here, explanations above rules 

# Statistics of graph after building from vcf, fa and gtf
# rule vg_stats:
#     input: 
#         vg = os.path.join(graph_outpath, "vcf_fa_build", "vg", "{chrnum}." + graphbase + ".vg")

#     output:
#         stats = os.path.join(stats_outpath, "vgstats", "vcf_fa_build", "{chrnum}.vg.tsv"),

#     conda: "../envs/vg.yml"
#     log: os.path.join(log_path, "stats", "{chrnum}.vgstats.log") 
#     threads: 32
#     resources:
#         runtime = "2h",
#         mem_mb = 40000,

#     shell: 
#         """

#         vg stats \
#         -z -l -r \
#         {input.vg} > {output.stats}

#         """

# Check the conversion from vg to pg retained the same stats (only built for chr22 on Phoenix)
rule pg_stats:
    input: 
        pg = os.path.join(graph_outpath, "vcf_fa_build", "chr22." + graphbase + ".pg")

    output:
        stats = os.path.join(stats_outpath, "pgstats", "vcf_fa_build", "chr22.pg.tsv"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "stats", "chr22.pgstats.log") 
    threads: 32
    resources:
        runtime = "2h",
        mem_mb = 40000,

    shell: 
        """

        vg stats \
        -z -l -r \
        {input.pg} > {output.stats}

        """

# Print the path metadata of the xg indexes into tsv files and the count of the lines into a seperate file to compare
    # ## Below is the attempt to includeit all in one rule, gave up
# rule full_xg_paths:
#     input: 
#         xg = expand(os.path.join(
#             index_outpath, "{build}", "{hpc}", graphbase + "{base}.xg"),
#             build = ['vcf_fa_full', 'HPRC'],
#             hpc = ['blackochre', 'phoenix', 'DL'],
#             base = ['.spliced.spliced', '-gencode45.spliced', '-non-spliced']
#         )
#     output: 
#         paths = expand(os.path.join(
#             stats_outpath, "{build}", "xgpaths", "{hpc}.xg.tsv"),
#             build = ['vcf_fa_build', 'HPRC'],
#             hpc = ['blackochre', 'phoenix', 'DL']
#         )

#     conda: "../envs/vg.yml"
#     log: os.path.join(log_path, "stats", "{hpc}.xgpaths.log"),
#     threads: 32
#     resources:
#         runtime = "6h",
#         mem_mb = 60000,

#     shell: 
#         """

#         vg paths \
#         -M -x \
#         {input.xg} > {output.paths} 2>> {log}

#         """

rule BODL_xg_paths:
    input: 
        xg = os.path.join(
            index_outpath, "vcf_fa_full", "blackochre", graphbase + "-gencode45.spliced.xg"),

    output: 
        paths = os.path.join(
            stats_outpath, "xgpaths", "vcf_fa_build", "BODL.xg.tsv")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "stats", "BODL.xgpaths.log"),
    threads: 32
    resources:
        runtime = "6h",
        mem_mb = 60000,

    shell: 
        """

        vg paths \
        -M -x \
        {input.xg} > {output.paths} 2>> {log}

        """


rule phoenix_xg_paths:
    input: 
        xg = os.path.join(
            index_outpath, "vcf_fa_full", "phoenix", graphbase + ".spliced.spliced.xg"),

    output: 
        paths = os.path.join(
            stats_outpath, "xgpaths", "vcf_fa_build", "phoenix.xg.tsv")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "stats", "phoenix.xgpaths.log"),
    threads: 32
    resources:
        runtime = "6h",
        mem_mb = 60000,

    shell: 
        """

        vg paths \
        -M -x \
        {input.xg} > {output.paths} 2>> {log}

        """


rule HPRC_paths:
    input: 
        # xg = os.path.join(
        #     index_outpath, "HPRC", "DL", graphbase + "-non-spliced.xg"),
        gfa = gfa_path

    output: 
        paths = os.path.join(
            stats_outpath, "xgpaths", "HPRC", "HPRC.gfa.tsv")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "stats", "HPRC.xgpaths.log"),
    threads: 32
    resources:
        runtime = "6h",
        mem_mb = 60000,

    shell: 
        """

        vg paths \
        -M -x \
        {input.gfa} > {output.paths} 2>> {log}

        """

rule graph_stats:
    input:
        graph = os.path.join(
            index_outpath, "vcf_fa_full", "{build}", graphbase + "-gencode45.spliced.xg"),
    
    output: 
        stats = os.path.join(stats_outpath, "graph_stats", "{build}.graphstats.tsv"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "stats", "{build}.graphstats.log") 
    threads: 16
    resources:
        runtime = "4h",
        mem_mb = 40000,

    shell: 
        """

        vg stats \
        -z -l -r -L -s -A\
        {input.graph} > {output.stats}

        """ 

rule HPRC_stats:
    input:
        graph = gfa_path
    
    output: 
        stats = os.path.join(stats_outpath, "graph_stats", "HPRC.graphstats.tsv"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "stats", "HPRC.graphstats.log") 
    threads: 16
    resources:
        runtime = "6h",
        mem_mb = 130000,

    shell: 
        """

        vg stats \
        -z -l -r -L -A \
        {input.graph} > {output.stats}

        """ 