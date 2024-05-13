rule convertpg:
    input: 
        vg = os.path.join(graph_outpath, "chr22." + graphbase + ".vg")

    output:
        pg = os.path.join(graph_outpath, "chr22." graphbase + ".pg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "chr22.convertpg.log") 
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 100000,

     shell:
        """

        vg convert \
        -p {input.vg} > {output.pg}

        """
# This rule was bugged, unsure why. 
# Something about the indent either in this file or the snakefile