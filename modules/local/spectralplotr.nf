process SPECTRALPLOTR {
    label 'process_low'

    container 'sviatsidorov/r_machine:1.1'

    publishDir "${params.outdir}/spectral", mode: params.publish_dir_mode

    input:
    path(spectral_files)

    output:
    path "spectral_plot.pdf", emit: pdf
    path "versions.yml", emit: versions

    """
    spectral_plot.R . spectral_plot.pdf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -1 | cut -d' ' -f3)
        ggplot2: \$(Rscript -e "cat(as.character(packageVersion('ggplot2')))")
    END_VERSIONS
    """
}
