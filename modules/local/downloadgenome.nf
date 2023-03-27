process DOWNLOADGENOME {
    label 'process_medium'

    container 'sviatsidorov/uniqmaptrack:1.1'

    output:
    tuple path("t2t-chm13-v1.1.fa"), path("t2t-chm13-v1.1.fa.fai"), emit: t2t
    path "versions.yml", emit: versions

    """
    wget https://t2t.gi.ucsc.edu/chm13/hub/t2t-chm13-v1.1/genome/t2t-chm13-v1.1.fa.gz && \
    gzip -d -c t2t-chm13-v1.1.fa.gz > t2t-chm13-v1.1.fa
    
    wget https://t2t.gi.ucsc.edu/chm13/hub/t2t-chm13-v1.1/genome/t2t-chm13-v1.1.fa.gz.fai && \
    mv t2t-chm13-v1.1.fa.gz.fai t2t-chm13-v1.1.fa.fai

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        wget: \$(wget --version | head -1)
    END_VERSIONS
    """
}