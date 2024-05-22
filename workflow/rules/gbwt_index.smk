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
        vcf = vcfpath,
        spl_pg = os.path.join(graph_outpath, "vcf_fa_build",
         "chr22." + graphbase + ".spliced.pg")
    output:
        gbwt = os.path.join(index_outpath, "chr22", "chr22.haplotypes.gbwt"),

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gbwt_index", "chr22.gbwt_index.log") 
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
        -G {output.gbwt} \
        -p 2>> {log} 


        """

rule hst_gen:
    input: 
        gtf = os.path.join(annotation_outpath, "chr22." + annotationbase + ".gtf"),
        spl_pg = os.path.join(graph_outpath, "vcf_fa_build",
         "chr22." + graphbase + ".spliced.pg"),
        hapgbwt = os.path.join(index_outpath, "chr22", "chr22.haplotypes.gbwt")

    output:
        fa = os.path.join(index_outpath, "chr22", "chr22.pt.seq.fa"),
        info = os.path.join(index_outpath, "chr22", "hpltx.info.txt"),
        up_pg = os.path.join(graph_outpath, "chr22." + graphbase + ".htupdated.pg"),
        gbwt = os.path.join(index_outpath, "chr22", "chr22.gbwt")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "gbwt_index", "gbwt_index.log") 
    threads: 32
    resources:
        runtime = "5h",
        mem_mb = 100000,

    shell:
        """

        # Create haplotype-specific transcripts and update graph with default mode
        # Different combinaation of options can give a bi-directional PT or 
        # Keep redundant haplotype-specific transcripts
        # -o do not topological sort and compact the graph
        # -r add reference transcripts as embedded paths in the graph
        # -n transcripts file
        # -l project transcripts into haplotypes gbwt file
        # -b write out pantranscriptome as gbwt file, -f fasta file, and -i tsv info table

        vg rna \
        -p -t {threads} \
        -o -r -n {input.gtf} \
        -l {input.hapgbwt} \
        -b {output.gbwt} \
        -f {output.fa} \
        -i {output.info} {input.spl_pg} \
        > {output.up_pg}


        """
