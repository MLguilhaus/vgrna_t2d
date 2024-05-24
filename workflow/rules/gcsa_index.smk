# Generalised compressed suffix array index, like .sa from bwa index
# Again do with each chr (add an expand once I'm at that point)
# Note from 13.May - it uses ~ 140GB of ram to generate but needs 
# 1-4TB of tmp space. I think.  
# for 1 chr22 it should be significantly less...
rule gcsa_index:
    input: 
        pruned = expand(
            os.path.join(graph_outpath, "{build}", "{chrnum}." + graphbase + ".pruned.vg"),
            build = ['vcf_fa_build'],
            chrnum = ['chr22'])
    output:
        gcsa = expand(
            os.path.join(index_outpath, "{subdir}", "{chrnum}.gcsa"),
            subdir = ['chr22'],
            chrnum = ['chr22'])

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "gcsa_index.log") 
    params:
        temp_dir = ("/hpcfs/users/a1627307/vgrna_t2d/config/tmp") # maybe best to specify a dir in local dir as /tmp has only 70G total
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 200000,

    shell:
        """

        vg index \
        -t {threads} \
        -b {params.temp_dir} \
        -p 2>> {log} \
        {input.pruned} \
        -g {output.gcsa} \
  

        """


