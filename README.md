# UniqueMapTrack
A Nextflow pipeline for creating a mappability track for a set of fasta sequences.

This pipeline is based on Michael Sauria's [tool](https://github.com/msauria/minUniqueKmer) for creating minimum unique k-mer wiggle tracks from a set of fasta sequences.

To run pipeline use the following:

```
nextflow run UniqueMapTrack/main.nf -profile singularity
```