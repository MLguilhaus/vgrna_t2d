rule convertpg:
    input: 
        vg = os.path.join(graph_outpath, graphbase + ".vg")

    output:
        pg = os.path.join(graph_outpath, graphbase + ".pg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "convertpg.log") 
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 100000,

     shell:
        """

        vg convert \
        -p {input.vg} > {output.pg}

        """