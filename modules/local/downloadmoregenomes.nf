process DOWNLOADMOREGENOMES {
    label 'process_low'
    
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.16.1--h6899075_1' :
        'quay.io/biocontainers/samtools:1.16.1--h6899075_1' }"

    output:
    tuple path("e_coli.fa"), path("e_coli.fa.fai"), emit: ecoli
    tuple path("human_mitochondrion.fa"), path("human_mitochondrion.fa.fai"), emit: hm
    tuple path("oryza_sativa_chloroplast.fa"), path("oryza_sativa_chloroplast.fa.fai"), emit: osc
    tuple path("sars_cov2.fa"), path("sars_cov2.fa.fai"), emit: sc2
    path "versions.yml"           , emit: versions

    script:
    
    """
    wget "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NC_000913.3&rettype=fasta" -O e_coli.fa
    wget "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NC_012920.1&rettype=fasta" -O human_mitochondrion.fa
    wget "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NC_001320.1&rettype=fasta" -O orzyza_sativa_chloroplast.fa
    wget "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NC_045512.2&rettype=fasta" -O sars_cov2.fa

    samtools \\
        faidx \\
        e_coli.fa \\
        -o e_coli.fa.fai

    samtools \\
        faidx \\
        human_mitochondrion.fa \\
        -o human_mitochondrion.fa.fai

    samtools \\
        faidx \\
        oryza_sativa_chloroplast.fa \\
        -o oryza_sativa_chloroplast.fa.fai

    samtools \\
        faidx \\
        sars_cov2.fa \\
        -o sars_cov2.fa.fai

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        wget: \$(wget 2>&1 | head -1 | cut -d" " -f1,2)
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}
