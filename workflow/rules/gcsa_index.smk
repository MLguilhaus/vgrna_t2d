# Generalised compressed suffix array index, like .sa from bwa index
# Again do with each chr (add an expand once I'm at that point)
# Note from 13.May - it uses ~ 140GB of ram to generate but needs 
# 1-4TB of tmp space. I think.  
# for 1 chr22 it should be significantly less...
rule gcsa_index:
    input: 
        pruned = os.path.join(graph_outpath, graphbase + ".pruned.vg")
    output:
        gcsa = os.path.join(index_outpath, graphbase + ".gcsa"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "gcsa_index.log") 
    params:
        temp_dir = ("/tmp") # maybe best to specify a dir in local dir as /tmp has only 70G total
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


