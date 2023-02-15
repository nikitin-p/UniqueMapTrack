process MAPTRACK {
    tag "$meta.id"
    label 'process_high'

    container 'sviatsidorov/uniqmaptrack:1.1'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("*.bam"), emit: bam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    """
    ./bin/minUniqueKmer/find_minUniqueKmer.sh t2t-chm13-v1.1.fa 10

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        MAPTRACK: 1.0
    END_VERSIONS
    """
}
