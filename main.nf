#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { UNIQMAPTRACK } from './workflows/uniqmaptrack.nf'

workflow {
    UNIQMAPTRACK()
}
