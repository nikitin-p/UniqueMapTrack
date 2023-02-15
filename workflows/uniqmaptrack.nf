include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK } from '../modules/local/maptrack.nf'

workflow UNIQMAPTRACK {
    DOWNLOADGENOME(  )

    MAPTRACK( DOWNLOADGENOME.out.t2t )
}
