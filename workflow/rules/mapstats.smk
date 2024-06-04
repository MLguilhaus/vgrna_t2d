# Convert to gam to view mapping statistics, 
# note that this will take the best of the multipath alignment
# Unsure why 30 may 9am my wild cards for testsample were pulling both the SRR and srr.full
# fixed, it was due to output file in snakefile having incorrect syntax
rule gamp_convert:
    input:
        gamp = os.path.join(map_outpath, "{testsample}.full.gamp")
    output:
        gam = os.path.join(map_outpath, "{testsample}.gam")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "mpmap", "{testsample}.gampconvert.log") 
    threads: 32
    resources:
        runtime = "12h",
        mem_mb = 80000,

    shell:
        """

        vg view \
        -K -G \
        {input.gamp} > {output.gam} 2>> {log}

        """

# Get the stats of the best alignment from multipath
rule mapstats:
    input:
        gam = os.path.join(map_outpath, "{testsample}.gam")
    output: 
        stats = os.path.join(
            stats_outpath, "mapstats", "vcf_fa_build", "{testsample}.map.tsv")
    
    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "mpmap", "{testsample}.full.gampconvert.log") 
    threads: 32
    resources:
        runtime = "1h",
        mem_mb = 40000,

    shell:
        """

        vg stats \
        -a {input.gam} > {output.stats} \
        2>> {log}

        """