rule constructspl:
    input:
        # gtf = gtf_path,
        # gtf = os.path.join(annotation_outpath, "chr22.renamed.gtf")
        gtf = os.path.join(annotation_outpath, "chr22." + annotationbase + ".gtf"),
        pg = os.path.join(graph_outpath, "chr22." + graphbase + ".pg")

    output:
        spl_pg = os.path.join(graph_outpath, "chr22." + graphbase + ".spliced.pg")

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