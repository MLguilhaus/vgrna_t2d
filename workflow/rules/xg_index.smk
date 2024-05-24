rule xg_index:
    input: 
        spl_pg = os.path.join(graph_outpath, "vcf_fa_build", 
            "chr22." + graphbase + ".htupdated.pg")
    output:
        xg = os.path.join(index_outpath, "chr22", "chr22.spliced.htupdated.xg"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "xg_index", "chr22", "chr22.xg_index.log") 
    params:
        temp_dir = ("/tmp")
    threads: 32
    resources:
        runtime = "1h",
        mem_mb = 100000,

    shell:
        """

        vg index \
        -t {threads} \
        -p 2>> {log} \
        -b {params.temp_dir} \
        {input.spl_pg} \
        -x {output.xg} 

        """

