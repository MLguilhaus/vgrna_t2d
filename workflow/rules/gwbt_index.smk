# We may not need this, more for pantranscriptome construction, may require the VCF
# Can use the HPRC VCF?
# It also goes, construct graphs, join graphs then project transcripts (so I would need to do all chr grahs first)
# I think no, as its more about comparing alignments between linear and SPGG
rule gbwt_index:
    input: 
        gbz = ("/hpcfs/users/a1627307/genome/hprc-v1.1-mc-grch38.gbz")
    output:
        gbwt = os.path.join(index_outpath, "haplotypes.gbwt"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gbwt_index", "gbwt_index.log") 
    params:
        temp_dir = ("/tmp/vgrna")
    threads: 32
    resources:
        runtime = "5h",
        mem_mb = 100000,

    shell:
        """

        # Note that this is not how it was done in sibbessen paper,
        # They used vg index with a joined .pg of the chr.pg & the exon variants from 1000GP

        vg gbwt \
        --num-threads {threads} \
        -G {input.gbz} \
        -o {output.gbwt} \
        -p >> {log} 

        """
