# Prune complex regions of graph for gcsa index
#will do this for each spl_chr .pg
rule prune:
    input: 
        spl_pg = os.path.join(graph_outpath, "chr22-spliced.pg")
    output:
        pruned = os.path.join(index_outpath, "chr22-pruned.vg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "chr22.prune.log") 
    params:
        temp_dir = ("/tmp")
    threads: 32
    resources:
        runtime = "1h",
        mem_mb = 10000,

    shell:
        """
        vg prune \
        -t {threads} \
        -r {input.spl_pg} \
        > {output.pruned} \
        -p > {log}

        """

# Generalised compressed suffix array index, like .sa from bwa index
# Again do with each chr (add an expand once I'm at that point)
rule gcsa_index:
    input: 
        pruned = os.path.join(index_outpath, "chr22-pruned.vg")
    output:
        gcsa = os.path.join(index_outpath, "chr22-pruned.gcsa"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "xg_index", "chr22.gcsa_index.log") 
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
        {input.pruned} \
        -g {output.gcsa} \
        -p > {log} 

        """


# # Generate gcsa index
# 'vg index -p -t '"${CPU}"' -g '"${OUT_PREFIX}.gcsa"' 
#  $(for i in $(seq 1 22; echo X; echo Y; echo MT; echo SCA); 
#  do echo '"${GRAPH_PREFIX}"'_${i}_pruned.vg; done); rm *_pruned.vg'