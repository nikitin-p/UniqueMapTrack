process SPECTRALPLOT {
    label 'process_medium'

    container 'nikitinpavel/python_bedtools_machine:latest'

    publishDir { "${params.outdir}/spectral/${name}" }, mode: params.publish_dir_mode, saveAs: { it == 'versions.yml' ? null : it }

    input:
    tuple val(name), path(mul), path(mur)

    output:
    tuple val(name), path("*_mul_spectral_plot.tsv"), path("*_mur_spectral_plot.tsv"), emit: binned
    tuple val(name), path("*_mul_raw.tsv"), path("*_mur_raw.tsv"), emit: raw
    tuple val(name), path("*_mul_max.txt"), path("*_mur_max.txt"), emit: max
    path "versions.yml", emit: versions

    """
    spectral_plot.py ${mul} ${mur} ${name}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | cut -d' ' -f2)
    END_VERSIONS
    """
}
