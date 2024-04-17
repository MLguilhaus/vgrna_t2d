rule transform_gtf:
    input:
        gtf_file = gtf_path
    output:
        transformed_gtf = os.path.join(transform_outpath, "transformed_GENCODEv45.gtf"),
    
    log: os.path.join(log_path, "autoindex", "autoindex.log") 
    threads: 16
    resources:
        runtime = "1h",
        mem_mb = 5000,

    shell:
        """
        printf "##gtf-version 3\n" > {log} \
        echo "Processed GTF file: {input.gtf_file}" >> {log} \

        awk -F '\t' '$3 == "transcript" {{ \
            split($9, attrs, ";") \
            gene_id = transcript_id = "" \
            for (i in attrs) {{ \
                if (match(attrs[i], /gene_id "([^"]+)"/)) {{ \
                    gene_id = substr(attrs[i], RSTART+9, RLENGTH-10) \
                }} \
                if (match(attrs[i], /transcript_id "([^"]+)"/)) {{ \
                    transcript_id = substr(attrs[i], RSTART+16, RLENGTH-17) \
                }} \
            }} \
            split($1, parts, " ") \
            split(parts[1], chr_parts, ":") \
            split(chr_parts[1], chr_name, "chr") \
            print chr_name[2]"#"parts[4]"#"chr_name[2]"_"parts[4]"#0\t" parts[2] "\tgene\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" "gene_id \\"" gene_id "\\"; ID \\"" gene_id "\\"" \
            print chr_name[2]"#"parts[4]"#"chr_name[2]"_"parts[4]"#0\t" parts[2] "\ttranscript\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" "gene_id \\"" gene_id "\\"; transcript_id \\"" transcript_id "\\"" \
        }}' {input.gtf_file} >> {output.transformed_gtf} 
        
        """