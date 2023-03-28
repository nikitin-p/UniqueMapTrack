// include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { DOWNLOADMOREGENOMES } from '../modules/local/downloadmoregenomes.nf'
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
    // DOWNLOADGENOME (  )

    DOWNLOADMOREGENOMES (  )

    MAPTRACK ( 
        // t2t
        // DOWNLOADGENOME.out.t2t 
        DOWNLOADMOREGENOMES.out.ecoli,
        DOWNLOADMOREGENOMES.out.hm,
        DOWNLOADMOREGENOMES.out.osc,
        DOWNLOADMOREGENOMES.out.sc2
    )
}
