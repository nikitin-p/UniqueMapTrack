include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK       } from '../modules/local/maptrack.nf'

workflow UNIQMAPTRACK {

    // --- Input validation ---
    def has_input       = params.input       != null
    def has_genome      = params.genome      != null
    def has_genome_name = params.genome_name != null

    if (!has_input && !has_genome) {
        error "No input provided. Use --input <samplesheet.csv> or --genome <url> --genome_name <name>"
    }
    if (has_input && (has_genome || has_genome_name)) {
        error "Conflicting inputs: provide either --input or --genome/--genome_name, not both"
    }
    if (has_genome && !has_genome_name) {
        error "Missing --genome_name: required when using --genome"
    }
    if (has_genome_name && !has_genome) {
        error "Missing --genome: required when using --genome_name"
    }

    // --- Build unified [name, url] channel ---
    if (has_input) {
        ch_genomes = Channel
            .fromPath(params.input)
            .splitCsv(header: true)
            .map { row -> tuple(row.name, row.fasta_url) }
    } else {
        ch_genomes = Channel.of(tuple(params.genome_name, params.genome))
    }

    // --- Run pipeline ---
    DOWNLOADGENOME(ch_genomes)

    MAPTRACK(DOWNLOADGENOME.out.genome)

}
