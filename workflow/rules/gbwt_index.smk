# We may not need this, more for pantranscriptome construction, may require the VCF
# Can use the HPRC VCF?
# It also goes, construct graphs, join graphs then project transcripts (so I would need to do all chr grahs first)
# I think no, as its more about comparing alignments between linear and SPGG
# We do need it for rpvg though
# But it has to be the pantranscriptome gbwt so need to be generated the same way as in sibbessen

rule gbwt_index:
    input: 
        gbz = gbz_path,
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

        # Note that this is not how it was done in sibbessen paper,
        # They used vg index with a joined .pg of the chr.pg & the exon variants from 1000GP

        vg gbwt \
        --num-threads {threads} \
        -G {input.gbz} \
        -o {output.gbwt} \
        -p 2>> {log} 

        ## Sibbessen here 

        # Set projection mode. 
        # 	"def": Default
        # 	"redu": Keep redundant haplotype-specific transcripts
        # 	"bidi": Create bi-directional pantranscriptome
        MODE="def"

        # Create gbwt index of all haplotypes
        vg index 
        -p -t ${CPU} 
        -G haplotypes.gbwt 
        -v ${VARIANTS_PREFIX}.vcf.gz 
        ${GRAPH_PREFIX}.pg

        # Find contig transcripts
        grep -P '^${CHR}\t' ${TRANSCRIPTS_PREFIX}.gtf > ${CHR}.gtf

        # Calculate graph statistics (pre-rna) 
        vg stats -z -l -r ${GRAPH_PREFIX}.pg

        if [ "${MODE}" = "def" ]; then 
        # Create haplotype-specific transcripts and update graph
        vg rna -p -t ${CPU} 
        -o -r -n ${CHR}.gtf 
        -l haplotypes.gbwt 
        -b ${OUT_PREFIX}.gbwt 
        -f ${OUT_PREFIX}.fa 
        -i ${OUT_PREFIX}.txt ${GRAPH_PREFIX}.pg 
        > ${OUT_PREFIX}_tmp.pg; 
        
        mv ${OUT_PREFIX}_tmp.pg ${OUT_PREFIX}.pg; 
        rm haplotypes.gbwt"

        elif [ "${MODE}" = "redu" ]; then

    	# Create haplotype-specific transcripts and update graph
	    vg rna -p -t ${CPU} 
        -o -c -r -a -u -g -n ${CHR}.gtf 
        -l haplotypes.gbwt 
        -b ${OUT_PREFIX}.gbwt 
        -f ${OUT_PREFIX}.fa 
        -i ${OUT_PREFIX}.txt ${OUT_PREFIX}.pg 
        > ${OUT_PREFIX}_tmp.pg; 
        
        mv ${OUT_PREFIX}_tmp.pg ${OUT_PREFIX}.pg; 
        rm haplotypes.gbwt"

        elif [ "${MODE}" = "bidi" ]; then

	    # Create haplotype-specific transcripts and update graph
	    vg rna -p -t ${CPU} 
        -o -r -g -n ${CHR}.gtf 
        -l haplotypes.gbwt 
        -b ${OUT_PREFIX}.gbwt 
        -f ${OUT_PREFIX}.fa 
        -i ${OUT_PREFIX}.txt ${GRAPH_PREFIX}.pg 
        > ${OUT_PREFIX}_tmp.pg; 
        
        mv ${OUT_PREFIX}_tmp.pg ${OUT_PREFIX}.pg; 
        rm haplotypes.gbwt"
        
        fi

        # Calculate graph statistics (post-rna) 
        vg stats -z -l -r ${OUT_PREFIX}.pg"

        """
