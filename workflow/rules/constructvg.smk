# Need to make a spliced pg from same things used in autoinex
rule constructvg:
    input:
        fa = refpath,
        vcf = vcfpath

    output:
        vg = os.path.join(graph_outpath, graphbase + ".vg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "constructvg.log") 
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 200000,

    shell:
        """

        vg construct 
        -t {threads} \
        -a -p \
        -v {input.vcf} \
        -r {input.fa} > {output.vg}

        """