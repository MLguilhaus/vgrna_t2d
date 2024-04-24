rule subset_gtf:
    input:
        full_gtf = gtf_path, # it was running without the renamed file... check the pg
    output:
        chr_gtf = os.path.join(
            annotation_outpath, "{chrnum}." + annotationbase + ".gtf" #ask stevie how to basename
        ),
    log: os.path.join(log_path, "subset", "{chrnum}.subset_gtf.log")
    threads: 1
    resources:
        runtime = "1h",
        mem_mb = 5000, 
    shell: 
        """

        grep '^{wildcards.chrnum}\t' {input.full_gtf} > {output.chr_gtf}

        """

# rule subset_gfa:
#     input: 
#         full_gfa = gfa_full_path,
#     output:
#         chr_gfa = os.path.join(
#             graph_outpath, "{chrnum}." + graphbase + .gfa"
#             <BASENAME>-<i>-<name>-<start>-<length>.<ext> 
#         ),

#     conda: "../envs/vg.yml"
#     params: 
#         outfmt = config['chunk']['out_format']
#         outpfx = 
#     log: os.path.join(log_path, "subset", "subset_gtf.log")
#     threads: 32
#     resources:
#         runtime = "6h",
#         mem_mb = 120000, 

#     shell: 
#         """

#         vg chunk \
#         -t {threads} \
#         -x {input.full_gfa} \
#         -b {params.outpfx} \
#         -C -O {params.outfmt} \
        
#         """

# # -C create chunk for each connected component - unsure how to split this up n do one at a time.. 
       


    