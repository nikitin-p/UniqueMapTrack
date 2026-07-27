include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK       } from '../modules/local/maptrack.nf'
include { SPECTRALPLOT   } from '../modules/local/spectralplot.nf'
include { SPECTRALPLOTR  } from '../modules/local/spectralplotr.nf'

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

    // Join mul and mur outputs by name for spectral analysis
    ch_wig = MAPTRACK.out.mul
        .join(MAPTRACK.out.mur)
        .map { name, mul, mur -> tuple(name, mul, mur) }

    SPECTRALPLOT(ch_wig)

    // Collect all spectral outputs and produce combined PDF
    ch_spectral_files = SPECTRALPLOT.out.binned
        .map { name, mul_tsv, mur_tsv -> [mul_tsv, mur_tsv] }
        .mix(SPECTRALPLOT.out.raw.map { name, mul_raw, mur_raw -> [mul_raw, mur_raw] })
        .mix(SPECTRALPLOT.out.max.map { name, mul_max, mur_max -> [mul_max, mur_max] })
        .flatten()
        .collect()

    SPECTRALPLOTR(ch_spectral_files)

}
