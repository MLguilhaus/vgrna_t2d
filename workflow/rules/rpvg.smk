rule rpvg:
    input:
        gamp = os.path.join(map_outpath, "{testsample}.full.gamp"),
        xg = expand(
            os.path.join(index_outpath, "{build}", "blackochre", "{base}.{suffix}"),
            build = ['vcf_fa_full'],
            base = ['hprc-v1.1-mc-grch38-gencode45.spliced'],
            suffix = ['xg']
            ),
        gbwt = expand(
            os.path.join(index_outpath, "{build}", "blackochre", "{base}.{suffix}"),
            build = ['vcf_fa_full'],
            base = ['hprc-v1.1-mc-grch38-gencode45.haplotx'],
            suffix = ['gbwt']
            ),
        info = expand(
            os.path.join(index_outpath, "{build}", "blackochre", "{base}.{suffix}"),
            build = ['vcf_fa_full'],
            base = ['hprc-v1.1-mc-grch38-gencode45.txorigin'],
            suffix = ['tsv']
            ),
    output:
        rpvg = os.path.join(count_path, "rpvg", "{testsample}.rpvg.txt"),
        joint = os.path.join(count_path, "rpvg", "{testsample}.rpvg_joint.txt"),

    singularity: "/hpcfs/users/a1627307/vgrna_t2d/rpvg_latest.sif"
    log: os.path.join(log_path, "rpvg", "{testsample}.rpvg.log") 
    params:
        seed = "622797",
        inf_mod = "haplotype-transcripts",
        prefix = "rpvg"
    threads: 16
    resources:
        runtime = "6h",
        mem_mb = 80000,

    shell:
        """

        rpvg \
        -t {threads} \
        -r {params.seed} \
        -i {params.inf_mod} \
        -g {input.xg} \
        -p {input.gbwt} \
        -a {input.gamp} \
        -f {input.info} \
        -o {params.prefix} \
        2>> {log}

        """
