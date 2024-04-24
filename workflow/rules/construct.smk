rule construct:
    input:
        # gbz = gbz_path, #gbz need original annotations, #gfa>pg convert needs renamed
        gtf = gtf_path,
        pg = os.path.join(graph_outpath, "hprc-v1.1-mc-grch38.pg")

    output:
        spl_pg = os.path.join(graph_outpath, "spliced-hprc-v1.1-mc-grch38.pg")

    params:
        maxnode = "32"

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "construct", "construct.log") 
    threads: 32
    resources:
        runtime = "14h",
        mem_mb = 300000

    shell:
        """

        vg rna \
        -t {threads} \
        -k {params.maxnode} \
        -n {input.gtf} \
        {input.pg} > {output.spl_pg} \
        -p &>> {log} 

        """