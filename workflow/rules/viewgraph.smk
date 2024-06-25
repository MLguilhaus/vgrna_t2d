rule viewgraph:
    input:
        graph = os.path.join(
            index_outpath, "vcf_fa_full", "blackochre", graphbase + "-gencode45.vg"),
    
    output: 
        dot = os.path.join("output", "BODLgraph.dot"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "viz", "BODLdot.log") 
    threads: 16
    resources:
        runtime = "12h",
        mem_mb = 60000,

    shell: 
        """

        vg view \
        -dps \
        {input.graph} > {output.dot} \
        2>> {log}

        """ 

