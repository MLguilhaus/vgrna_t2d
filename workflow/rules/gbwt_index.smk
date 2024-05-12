# We may not need this, more for pantranscriptome construction, may require the VCF
# Can use the HPRC VCF?
# It also goes, construct graphs, join graphs then project transcripts (so I would need to do all chr grahs first)
# I think no, as its more about comparing alignments between linear and SPGG
# We do need it for rpvg though
# But it has to be the pantranscriptome gbwt so need to be generated the same way as in sibbessen
# which means we need variants... from 1000GP (same as sibb?) Or VCF from HPRC?
# would need to join graphs first and do for all not seperately
# would also need to process the variants first

rule gbwt_index:
    input: 
        vcf = vcfpath
        spl_pg = os.path.join(graph_outpath, "chr22-spliced.pg")
    output:
        gbwt = os.path.join(index_outpath, "haplotypes.gbwt"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gbwt_index", "chr22.gbwt_index.log") 
    params:
        temp_dir = ("/tmp/vgrna")
    threads: 32
    resources:
        runtime = "5h",
        mem_mb = 100000,

    shell:
        """

        # first create a gwbt index of all haplotypes
        vg index \
        -t {threads} \
        -v {input.vcf} \
        {input.spl_pg} \
        -G {outut.gbwt} \
        -p 2>> {log} 


        """

rule hst_gen:
    input: 
        gtf = ("unsure yet if the spl will be with renamed or not update once we know")
        spl_pg = os.path.join(graph_outpath, "chr22-spliced.pg")
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

        # Create haplotype-specific transcripts and update graph with default mode
        # Different combinaation of options can give a bi-directional PT or 
        # Keep redundant haplotype-specific transcripts
        vg rna \
        -p -t {threads} \
        -o -r -n ${CHR}.gtf 
        -l haplotypes.gbwt 
        -b ${OUT_PREFIX}.gbwt 
        -f ${OUT_PREFIX}.fa 
        -i ${OUT_PREFIX}.txt ${GRAPH_PREFIX}.pg 
        > ${OUT_PREFIX}_tmp.pg; 


        """
