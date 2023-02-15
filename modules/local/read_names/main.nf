process READ_NAMES {
    tag "$meta.id"
    label 'process_low'

    conda (params.enable_conda ? "conda-forge::python=3.8" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.8--1' :
        'quay.io/biocontainers/python:3.8--1' }"

    input:
    tuple val(meta), path(reads)

    output:
    path "*_read_names", emit: read_names

    script:
    """
    get_read_names.py $reads > ${meta.id}_read_names
    """
}
