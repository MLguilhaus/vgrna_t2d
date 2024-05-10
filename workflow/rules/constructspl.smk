rule constructspl:
    input:
        gtf = gtf_path,
        pg = os.path.join(graph_outpath, graphbase + ".pg")

    output:
        spl_pg = os.path.join(graph_outpath, graphbase + "spliced.pg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "constructspl.log") 
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 200000

    shell:
        """

        vg rna \
        -t {threads} \
        -e \
        -p \
        -n {input.gtf} \
        {input.pg} > {output.spl_pg} \
  

        """