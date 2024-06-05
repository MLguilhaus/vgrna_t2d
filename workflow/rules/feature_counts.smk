rule feature_counts:
    input:
        bam = expand(
            os.path.join(map_outpath, "{sample}", "{bam}"),
            bam = ["mpmap.sortedByCoord.bam"],
            sample = testsamples
        ),
        bai = expand(
            os.path.join(map_outpath, "{sample}", "{bai}"),
            bai = ["mpmap.sortedByCoord.bam.bai"],
            sample = testsamples
        ),

        gtf = gtf_path
    output:
        counts = os.path.join(fcount_path, "mpmap.counts.out"),
        summary = os.path.join(fcount_path, "mpmap.counts.out.summary")
    conda: "../envs/feature_counts.yml"
    log: os.path.join(log_path, "feature_counts", "mpmap.counts.log")
    threads: 16
    resources:
        runtime = "10h",
        mem_mb = 120000,
        disk_mb = 10000
    params:
        minOverlap = config['featureCounts']['minOverlap'],
        fracOverlap = config['featureCounts']['fracOverlap'],
        q = config['featureCounts']['minQual'],
        s = config['featureCounts']['strandedness'],
        extra = config['featureCounts']['extra']
    shell:
       """
       featureCounts \
         {params.extra} \
         -Q {params.q} \
         -s {params.s} \
         --minOverlap {params.minOverlap} \
         --fracOverlap {params.fracOverlap} \
         -T {threads} \
         -a {input.gtf} \
         -o {output.counts} \
         {input.bam} &>> {log}
       """