process DOWNLOADGENOME {
    label 'process_low'

    container 'sviatsidorov/uniqmaptrack:1.1'

    input:
    tuple val(name), val(url)

    output:
    tuple val(name), path("${name}.fa"), path("${name}.fa.fai"), emit: genome
    path "versions.yml", emit: versions

    script:
    def is_gz = url.endsWith('.gz')
    """
    if ${is_gz}; then
        wget -O genome.fa.gz '${url}'
        gzip -d -c genome.fa.gz > ${name}.fa
    else
        wget -O ${name}.fa '${url}'
    fi

    samtools faidx ${name}.fa -o ${name}.fa.fai

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        wget: \$(wget --version | head -1)
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}
