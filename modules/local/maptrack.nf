process MAPTRACK {
    label 'process_high'

    container 'sviatsidorov/uniqmaptrack:1.1'

    input:
    tuple val(name), path(fasta), path(fai)

    output:
    tuple val(name), path("*.fa.sa")     , emit: sa
    tuple val(name), path("*.fa.refrev") , emit: refrev
    tuple val(name), path("*.fa.mul.wig"), emit: mul
    tuple val(name), path("*.fa.mur.wig"), emit: mur
    path "versions.yml"                  , emit: versions

    """
    /minUniqueKmer/find_minUniqueKmer.sh ${fasta} $task.cpus

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        minUniqueKmer: \$(/minUniqueKmer/bin/minUniqueKmer | head -1 | cut -d" " -f7)
    END_VERSIONS
    """
}
