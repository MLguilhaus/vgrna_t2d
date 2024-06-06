rule gfa2xg:
    input: 
        gfa = gfa_path,
    output: 
        xg = os.path.join(graph_outpath, "HPRC", graphbase + ".xg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gfa2xg", "convert2xg.log"),
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 80000,
    
    shell:
        """

        vg convert \
        -g {input.gfa} \
        -o > {output.xg} \
        2>> {log}

        """