include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK } from '../modules/local/maptrack.nf'
include { DOWNLOADMOREGENOMES } from '../modules/local/downloadmoregenomes.nf'
include { MAPTRACKADD } from '../modules/local/maptrackadd.nf'

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

    // Comment the code below if you wish to analyze only T2T-CHM13

    DOWNLOADMOREGENOMES (  ) 

    MAPTRACKADD ( 
        DOWNLOADMOREGENOMES.out.ecoli,
        DOWNLOADMOREGENOMES.out.hm,
        DOWNLOADMOREGENOMES.out.osc,
        DOWNLOADMOREGENOMES.out.sc2
    )

    // T2T-CHM13 modules

    DOWNLOADGENOME (  )

    MAPTRACK ( 
        // t2t
        DOWNLOADGENOME.out.t2t 
    )

}
