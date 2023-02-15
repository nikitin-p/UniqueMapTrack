process DOWNLOADGENOME {
    tag "$meta.id"
    label 'process_medium'

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
    wget https://t2t.gi.ucsc.edu/chm13/hub/t2t-chm13-v1.1/genome/t2t-chm13-v1.1.fa.gz
    wget https://t2t.gi.ucsc.edu/chm13/hub/t2t-chm13-v1.1/genome/t2t-chm13-v1.1.fa.gz.fai
    wget https://t2t.gi.ucsc.edu/chm13/hub/t2t-chm13-v1.1/cenSat/cenSatAnnotation.bigBed
    bigBedToBed cenSatAnnotation.bigBed cenSatAnnotation.tmp
    awk 'BEGIN{{ OFS="\t" }}{{ split($4,A,"_"); print $1,$2,$3,A[1] }}' \
    cenSatAnnotation.tmp > cenSatAnnotation.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        DOWNLOADGENOME: 1.0
    END_VERSIONS
    """
}
