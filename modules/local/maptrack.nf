process MAPTRACK {
    label 'process_high'

    container 'sviatsidorov/uniqmaptrack:1.1'

    input:
    tuple path(fasta), path(fai)

    output:
    path "*.fa.sa"     , emit: sa
    path "*.fa.refrev" , emit: refrev
    path "*.fa.mul.wig", emit: mul
    path "*.fa.mur.wig", emit: mur
    // path "t2t-chm13-v1.1.fa.sa"     , emit: sa
    // path "t2t-chm13-v1.1.fa.refrev" , emit: refrev
    // path "t2t-chm13-v1.1.fa.mul.wig", emit: mul
    // path "t2t-chm13-v1.1.fa.mur.wig", emit: mur
    path "versions.yml"             , emit: versions
    
    """
    /minUniqueKmer/find_minUniqueKmer.sh ${fasta} $task.cpus
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        minUniqueKmer: \$(/minUniqueKmer/bin/minUniqueKmer | head -1 | cut -d" " -f7)
    END_VERSIONS
    """
}
