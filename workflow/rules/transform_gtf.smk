rule transform_gtf:
    input:
        gtf_file = os.path.join(
            annotation_outpath, "{chrnum}." + annotationbase + ".gtf"),
    output:
        transformed_gtf = os.path.join(
            annotation_outpath, "{chrnum}." + annotationbase + "_renamed.gtf"),
    
    log: os.path.join(log_path, "transform", "{chrnum}.transform.log") 
    threads: 16
    resources:
        runtime = "1h",
        mem_mb = 5000,

    shell:
        """
        # FIlter for full length transcripts and rename contigs
        cat {input.gtf_file} | \
        sed -e 's/^chrM/chrMT/g' \
        | grep -v "mRNA_start_NF" \
        | grep -v "mRNA_end_NF" > {output.transformed_gtf} \
        &>> {log} 

        # Remove chr from the 
        sed -i -e 's/^chr//g' {output.transformed_gtf} \
        &>> {log}

        # Sort and merge exons
        bedtools sort -i ${OUT_PREFIX}_exons.txt 
        > ${OUT_PREFIX}_exons_sort.txt;
        bedtools merge -i ${OUT_PREFIX}_exons_sort.txt 
        > ${OUT_PREFIX}_exons.bed; 
        rm ${OUT_PREFIX}_exons*.txt

        """