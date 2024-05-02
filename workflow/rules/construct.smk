rule construct:
    input:
        # gbz = gbz_path, #gbz need original annotations, #gfa>pg convert needs renamed
        gtf = os.path.join(
            annotation_outpath, "chr22." + annotationbase + "-renamed.gtf"
        ),
        pg = os.path.join(graph_outpath, "chr22.pg")

    output:
        spl_pg = os.path.join(graph_outpath, "chr22-spliced.pg")

    params:
        maxnode = "32"

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "construct", "chr22.construct.log") 
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 100000

    shell:
        """

        vg rna \
        -t {threads} \
        -k {params.maxnode} \
        -n {input.gtf} \
        {input.pg} > {output.spl_pg} \
        -p &>> {log} 

        """