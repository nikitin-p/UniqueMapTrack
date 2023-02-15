include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK } from '../modules/local/maptrack.nf'

workflow NF_EXAMPLE {
    DOWNLOADGENOME(  )

    MAPTRACK( DOWNLOADGENOME.out.t2t )
}
