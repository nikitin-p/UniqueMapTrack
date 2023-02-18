//include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK } from '../modules/local/maptrack.nf'

// t2t = [
//     [
//         "/home/nikitinp/hooman/results/genome/t2t-chm13-v1.1.fa.fai"
//     ],
//     [
//         "/home/nikitinp/hooman/results/genome/t2t-chm13-v1.1.fa"
//     ]
// ]

t2t = [
    [
        "/camp/home/sidoros/sidoros/projects/uniqmaptrack/results/genome/t2t-chm13-v1.1.fa.fai"
    ],
    [
        "/camp/home/sidoros/sidoros/projects/uniqmaptrack/results/genome/t2t-chm13-v1.1.fa"
    ]
]

workflow UNIQMAPTRACK {
    //DOWNLOADGENOME (  )

    MAPTRACK ( 
        t2t
        //DOWNLOADGENOME.out.t2t 
    )
}
