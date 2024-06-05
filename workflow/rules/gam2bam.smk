rule gam2bam:
    input:
        gam = os.path.join(map_outpath, "{testsample}.gam"),
        xg = expand(
            os.path.join(index_outpath, "{build}", "blackochre", "{base}.{suffix}"),
            build = ['vcf_fa_full'],
            base = ['hprc-v1.1-mc-grch38-gencode45.spliced'],
            suffix = ['xg']
        )
    output:
        temp_bam = os.path.join(map_outpath, "{testsample}", "unsorted.bam")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gam2bam", "{testsample}.log"),
    threads: 32
    resources:
        runtime = "6h",
        mem_mb = 60000,
    
    shell:
        """

        vg surject \
        -t {threads} \
        -x {input.xg} \
        -i \
        {input.gam} \
        -b > {output.temp_bam} \
        2>> {log} 

        """

rule bam_sort:
    input:
        temp_bam = os.path.join(map_outpath, "{testsample}", "unsorted.bam")

    output: 
        sortbam = os.path.join(map_outpath, "{testsample}", "mpmap.sortedByCoord.bam")
    
    conda: "../envs/samtools.yml"
    log: os.path.join(log_path, "bam_sort", "{testsample}.log"),
    threads: 16
    resources:
        runtime = "1h",
        mem_mb = 10000,

      
    shell:
        """

        samtools sort \
        {input.temp_bam} \
        -o {output.sortbam} \
        2>> {log}


        """

        # if !{output.sortbam}
        #     echo "{output.sortbam} incomplete, try again"
        # else
        #     echo "{output.sortbam} complete, removing unsorted {input.bam}" |
        #     rm {input.bam}
        # fi
        
rule index_bam:
    input: 
        bam = os.path.join(map_outpath, "{testsample}", "mpmap.sortedByCoord.bam")

    output: 
        bai = os.path.join(map_outpath, "{testsample}", "mpmap.sortedByCoord.bam.bai"), 
        stat = os.path.join(map_outpath, "{testsample}", "mpmap.sortedByCoord.samtools.flagstat")

    conda: "../envs/samtools.yml"
    log: os.path.join(log_path, "index_bam", "{testsample}.log"),
    threads: 16
    resources:
        runtime = "1h",
        mem_mb = 10000,

    shell:
        """
        samtools index {input.bam} > {output.bai}

        samtools flagstat {input.bam} > {output.stat}

        """