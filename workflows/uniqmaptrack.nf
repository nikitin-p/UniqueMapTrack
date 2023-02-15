include { DOWNLOADGENOME } from '../modules/local/downloadgenome.nf'
include { MAPTRACK } from '../modules/local/maptrack.nf'

reads = [
    [
        [
            id: "testx"
        ],
        "https://github.com/hartwigmedical/testdata/raw/master/100k_reads_hiseq/TESTX/TESTX_H7YRLADXX_S1_L001_R1_001.fastq.gz"
    ],
    [
        [
            id: "testy"
        ],
        "https://github.com/hartwigmedical/testdata/raw/master/100k_reads_hiseq/TESTY/TESTY_H7YRLADXX_S1_L001_R1_001.fastq.gz"
    ]
]

Channel
    .from( reads )
    .map{ row -> [ row[0], file(row[1], checkIfExists: true) ] }
    .set{ ch_reads }

workflow NF_EXAMPLE {
    DOWNLOADGENOME( ch_reads )

    MAPTRACK( ch_reads )
}
