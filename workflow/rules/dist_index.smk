rule trivial_snarls:
    input: 
        spl_pg = os.path.join(graph_outpath, "chr22." + graphbase + ".spliced.pg")
    output:
        trivial = os.path.join(index_outpath, "chr22.trivial.snarls"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "dist_index", "chr22.trivial_snarls.log") 
    params:
        algo = config['snarls']['algorithm'],
        temp_dir = ("/tmp")
    threads: 32
    resources:
        runtime = "5h",
        mem_mb = 100000,

    shell:
        """

        # Compute trivial (single edge) snarls for the .pg graph
        vg snarls \
        -t {threads} \
        -A {params.algo} \
        -T {input.spl_pg} \
        > {output.trivial} \
        &>> {log}


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
        xg = os.path.join(index_outpath, "chr22-spliced.xg"),
        snarls = os.path.join(index_outpath, "chr22.trivial.snarls")
    output:
        dist = os.path.join(index_outpath, "chr22-spliced.dist"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "dist_index", "chr22.dist_index.log") 
    params:
        algo = config['snarls']['algorithm'],
        temp_dir = ("/tmp")
    threads: 32
    resources:
        runtime = "1h",
        mem_mb = 10000,

    shell:
        """

        vg index \
        -t {threads} \
        -x {input.xg} \
        -s {input.snarls} \
        -j {output.dist} \
        -p >> {log} 

        """