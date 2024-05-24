rule trivial_snarls:
    input: 
        spl_pg = os.path.join(graph_outpath, "vcf_fa_build", "chr22." + graphbase + ".htupdated.pg")
    output:
        # trivial = os.path.join(index_outpath, "chr22", "chr22.trivial.snarls"),
        snarls = os.path.join(index_outpath, "chr22", "chr22.snarls"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "dist_index", "chr22.trivial_snarls.log") 
    params:
        algo = config['snarls']['algorithm'],
    threads: 32
    resources:
        runtime = "5h",
        mem_mb = 100000,

    shell:
        """

        # Compute trivial (single edge) snarls for each .pg graph
        # Include trivial snarls -T
        vg snarls \
        -t {threads} \
        -A {params.algo} \
        -T {input.spl_pg} \
        > {output.snarls} 


        """

## This will only be done when we have all chr.pg
# rule combine_snarls:
#     input: 
#         trivial = os.path.join(index_outpath, "chr22-trivial.snarls")
#     output:
#         snarls = os.path.join(index_outpath, "trivial.snarls")

#     log: os.path.join(log_path, "dist_index", "combine_snarls.log") 
#     threads: 16
#     resources:
#         runtime = "2h",
#         mem_mb = 10000,

#     shell:
#         """

#         cat $(for i in $(seq 1 22; echo X; echo Y; echo MT; echo SCA); 
#         do echo ${i}_trivial.snarls; done) 
#         > trivial.snarls; rm *_trivial.snarls'

#         """

# again for whole genome graph, remove the chr and do on the mergered xg & snarls
rule dist_index:
    input: 
        xg = os.path.join(index_outpath, "chr22", "chr22.spliced.htupdated.xg"),
        # snarls = os.path.join(index_outpath, "chr22", "chr22.trivial.snarls")
    output:
        dist = os.path.join(index_outpath, "chr22", "chr22.spliced.htupdated.dist"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "dist_index", "chr22.dist_index.log") 
    params:
        algo = config['snarls']['algorithm'],
    threads: 32
    resources:
        runtime = "1h",
        mem_mb = 10000,

    shell:
        """

        vg index \
        -t {threads} \
        -x {input.xg} \
        -j {output.dist} \
        -p 2>> {log} 

        """
#         -s {input.snarls} \
## -s should be an option but it has been removed?