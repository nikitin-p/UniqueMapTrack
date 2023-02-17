include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK } from '../modules/local/maptrack.nf'

//Uncomment the code below if you have already downloaded genome

// t2t = [
//     [
//         "/home/nikitinp/hooman/results/genome/t2t-chm13-v1.1.fa.fai"
//     ],
//     [
//         "/home/nikitinp/hooman/results/genome/t2t-chm13-v1.1.fa"
//     ]
// ]

workflow UNIQMAPTRACK {
    //Comment the code below if you have already downloaded genome
    DOWNLOADGENOME(  )

    MAPTRACK( 
        //Uncomment the code below if you have already downloaded genome
        // t2t
        DOWNLOADGENOME.out.t2t 
        )
}
