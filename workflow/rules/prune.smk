# Prune complex regions of graph for gcsa index
#will do this for each spl_chr .pg
rule prune:
    input: 
        spl_pg = os.path.join(graph_outpath, graphbase + "spliced.pg")
        # gbwt = os.path.join(
        #     index_outpath, graphbase + "spliced.haplotx.gbwt")
    output:
        pruned = os.path.join(
            graph_outpath, graphbase + "spliced.pruned.vg")
        # nodemap = os.path.join(
        #     graph_outpath, graphbase + "spliced.node_mappings")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "prune.log") 
    params:
        temp_dir = ("/tmp")
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 150000,

    shell:
        """
        vg prune \
        -t {threads} \
        -p \
        -r \
        {input.spl_pg} \
        > {output.pruned} \
        
        """

## Below is the wiki way, above is sibbessen way
        # vg prune \
        # -t {threads} \
        # -p \
        # -u \
        # -g {input.gbwt} \
        # -m {output.nodemap} \
        # {input.spl_pg} \
        # > {output.pruned} \
