# Generalised compressed suffix array index, like .sa from bwa index
# Again do with each chr (add an expand once I'm at that point)
rule gcsa_index:
    input: 
        pruned = os.path.join(graph_outpath, graphbase + ".pruned.vg")
    output:
        gcsa = os.path.join(index_outpath, graphbase + ".gcsa"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "gcsa_index.log") 
    params:
        temp_dir = ("/tmp")
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 200000,

    shell:
        """

        vg index \
        -t {threads} \
        -p \
        {input.pruned} \
        -g {output.gcsa} \
  

        """


