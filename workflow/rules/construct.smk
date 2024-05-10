rule construct:
    input:
        # gbz = gbz_path, #gbz need original annotations, #gfa>pg convert needs renamed
        # gtf = os.path.join(
        #     annotation_outpath, "chr22." + annotationbase + "_renamed.gtf"
        # ),
        gtf = os.path.join(
            annotation_outpath, "chr22." + annotationbase + ".gtf"),
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
        -e \
        -n {input.gtf} \
        {input.pg} > {output.spl_pg} \
        -p &>> {log} 


        """

    # max node length set as sibessen paper does mention in paper but not in scripts think we leave it out.    
    #     -k {params.maxnode} \ 