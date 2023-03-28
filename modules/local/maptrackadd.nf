process MAPTRACKADD {
    label 'process_medium'

    container 'sviatsidorov/uniqmaptrack:1.1'

    input:
    tuple path(fasta1), path(fai1)
    tuple path(fasta2), path(fai2)
    tuple path(fasta3), path(fai3)
    tuple path(fasta4), path(fai4)

    output:
    path "*.fa.sa"     , emit: sa
    path "*.fa.refrev" , emit: refrev
    path "*.fa.mul.wig", emit: mul
    path "*.fa.mur.wig", emit: mur
    path "versions.yml"             , emit: versions
    
    """
    /minUniqueKmer/find_minUniqueKmer.sh ${fasta1} $task.cpus
    /minUniqueKmer/find_minUniqueKmer.sh ${fasta2} $task.cpus
    /minUniqueKmer/find_minUniqueKmer.sh ${fasta3} $task.cpus
    /minUniqueKmer/find_minUniqueKmer.sh ${fasta4} $task.cpus
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        minUniqueKmer: \$(/minUniqueKmer/bin/minUniqueKmer | head -1 | cut -d" " -f7)
    END_VERSIONS
    """
}
