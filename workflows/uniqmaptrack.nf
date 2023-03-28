include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK } from '../modules/local/maptrack.nf'

// Uncomment the code below if you have already downloaded genome

// t2t = [
//     [
//         "your_path.fa"
//     ],
//     [
//         "your_path.fa.fai"
//     ]
// ]

workflow UNIQMAPTRACK {
    DOWNLOADGENOME (  )

    MAPTRACK ( 
        // t2t
        DOWNLOADGENOME.out.t2t 
    )
}
