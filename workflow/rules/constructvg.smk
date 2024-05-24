# Need to make a spliced pg from same things used in autoinex
rule constructvg:
    input:
        fa = refpath,
        vcf = vcfpath

    output:
        vg = os.path.join(graph_outpath, "vcf_fa_build", "{chrnum}." + graphbase + ".vg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gcsa_index", "{chrnum}.constructvg.log") 
    threads: 32
    resources:
        runtime = "8h",
        mem_mb = 200000,

    shell:
        """

        vg construct \
        -p -t {threads} \
        -R {wildcards.chrnum} \
        -C -a \
        -v {input.vcf} \
        -r {input.fa} > {output.vg}

        """
# Construct graph for each chr by specifyting the region of VCF -R
# -C, --region-is-chrom  don't attempt to parse the regions (use when the reference
# sequence name could be inadvertently parsed as a region)
#     -a, --alt-paths        save paths for alts of variants by SHA1 hash
# Used the same code as the Sibbessen paper, the -a makes the paths pretty unreadable but may be required? 