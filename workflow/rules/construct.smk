rule construct:
    input:
        gbz = gbz_path,
        gtf = gtf_path

    output:
        spl_pg = os.path.join(pg_outpath, "spliced-hprc-v1.1-mc-grch38.pg")

    conda: "../envs/vg.yml"
    log: os.path.join(log_path, "construct", "construct.log") 
    threads: 16
    resources:
        runtime = "20m",
        mem_mb = 100000

    shell:
        """

        vg rna \
        -t {threads} \
        --transcripts {input.gtf} \
        --gbz-format {input.gbz} > {output.spl_pg} \
        --progress &>> {log} 

        """


# usage: vg rna [options] graph.[vg|pg|hg|gbz] > splicing_graph.[vg|pg|hg]

# General options:
#     -t, --threads INT          number of compute threads to use [1]
#     -p, --progress             show progress
#     -h, --help                 print help message

# Input options:
#     -n, --transcripts FILE     transcript file(s) in gtf/gff format; may repeat
#     -m, --introns FILE         intron file(s) in bed format; may repeat
#     -y, --feature-type NAME    parse only this feature type in the gtf/gff (parses all if empty) [exon]
#     -s, --transcript-tag NAME  use this attribute tag in the gtf/gff file(s) as id [transcript_id]
#     -l, --haplotypes FILE      project transcripts onto haplotypes in GBWT index file
#     -z, --gbz-format           input graph is in GBZ format (contains both a graph and haplotypes (GBWT index))

# Construction options:
#     -j, --use-hap-ref          use haplotype paths in GBWT index as reference sequences (disables projection)
#     -e, --proj-embed-paths     project transcripts onto embedded haplotype paths
#     -c, --path-collapse TYPE   collapse identical transcript paths across no|haplotype|all paths [haplotype]
#     -k, --max-node-length INT  chop nodes longer than maximum node length (0 disables chopping) [0]
#     -d, --remove-non-gene      remove intergenic and intronic regions (deletes all paths in the graph)
#     -o, --do-not-sort          do not topological sort and compact the graph
#     -r, --add-ref-paths        add reference transcripts as embedded paths in the graph
#     -a, --add-hap-paths        add projected transcripts as embedded paths in the graph

# Output options:
#     -b, --write-gbwt FILE      write pantranscriptome transcript paths as GBWT index file
#     -f, --write-fasta FILE     write pantranscriptome transcript sequences as fasta file
#     -i, --write-info FILE      write pantranscriptome transcript info table as tsv file
#     -q, --out-exclude-ref      exclude reference transcripts from pantranscriptome output
#     -g, --gbwt-bidirectional   use bidirectional paths in GBWT index construction
