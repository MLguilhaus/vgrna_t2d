rule constructspl:
    input:
        # gtf = gtf_path,
        # gtf = os.path.join(annotation_outpath, "chr22.renamed.gtf")
        gtf = os.path.join(annotation_outpath, "chr22." + annotationbase + ".gtf"),
        # pg = os.path.join(graph_outpath, "chr22." + graphbase + ".pg")
        pg = os.path.join(graph_outpath, "hprc_gfa_build", "chr22.d9.pg")

    output:
        spl_pg = os.path.join(graph_outpath, "chr22.d9.spliced.pg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "constructspl", "chr22.d9.constructspl.log") 
    threads: 32
    resources:
        runtime = "2h",
        mem_mb = 20000

    shell:
        """

        vg rna \
        -t {threads} \
        -e \
        -p \
        -n {input.gtf} \
        {input.pg} > {output.spl_pg} \
  

        """