rule xg_index:
    input: 
        spl_pg = os.path.join(graph_outpath, "chr22." + graphbase + ".spliced.pg")
    output:
        xg = os.path.join(index_outpath, "chr22-spliced.xg"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "xg_index", "chr22.xg_index.log") 
    params:
        temp_dir = ("/tmp")
    threads: 32
    resources:
        runtime = "1h",
        mem_mb = 10000,

    shell:
        """

        vg index \
        -t {threads} \
        -p >> {log} \
        -b {params.temp_dir} \
        {input.spl_pg} \
        -x {output.xg} 

        """

