rule transform_gtf:
    input:
        gtf_file = gtf_path
    output:
        transformed_gtf = os.path.join(annotation_outpath, "gencode.v45.primary_assembly.annotation_renamed.gtf"),
    
    log: os.path.join(log_path, "transform", "transform.log") 
    threads: 16
    resources:
        runtime = "1h",
        mem_mb = 5000,

    shell:
        """
        cat {input.gtf_file} | \
        sed -e 's/^chrM/chrMT/g' \
        | grep -v "mRNA_start_NF" \
        | grep -v "mRNA_end_NF" > {output.transformed_gtf} &>> {log} \
        sed -i -e 's/^chr//g' {output.transformed_gtf} &>> {log}

        """