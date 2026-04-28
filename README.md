# UniqueMapTrack

A Nextflow DSL2 pipeline that computes **minimal unique k-mer mappability tracks** for reference genomes and outputs WIG files (convertible to BigWig).

This pipeline is based on Michael Sauria's [tool](https://github.com/msauria/minUniqueKmer) for creating minimum unique k-mer wiggle tracks from a set of fasta sequences.

## What It Does

For each genomic position, the pipeline finds the shortest k-mer that maps uniquely to the genome. The result is a per-base mappability score stored as:

- `*.fa.mul.wig` — minimal unique left k-mer length per position
- `*.fa.mur.wig` — minimal unique right (reverse complement) k-mer length per position
- `*.fa.sa` — suffix array (intermediate)
- `*.fa.refrev` — reverse reference (intermediate)

The core computation runs inside `sviatsidorov/uniqmaptrack:1.1` (Singularity/Docker), which contains the compiled `minUniqueKmer` tool.

## Workflow

1. `DOWNLOADGENOME` — downloads FASTA from a URL (handles `.gz` or plain), generates FAI via `samtools faidx`
2. `MAPTRACK` — runs `find_minUniqueKmer.sh` on the FASTA; outputs `*.fa.{sa,refrev,mul.wig,mur.wig}`

## Usage

Provide exactly one of:

```bash
# Samplesheet (CSV with header: name,fasta_url)
nextflow run main.nf -profile singularity --input samplesheet.csv
```

Example `samplesheet.csv`:

```csv
name,fasta_url
chm13,https://t2t.gi.ucsc.edu/chm13/hub/t2t-chm13-v1.1/genome/t2t-chm13-v1.1.fa.gz
ecoli,https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
```

```bash
# Single genome shortcut
nextflow run main.nf -profile singularity \
    --genome_name chm13 \
    --genome https://t2t.gi.ucsc.edu/chm13/hub/t2t-chm13-v1.1/genome/t2t-chm13-v1.1.fa.gz
```

The workflow fails early with a clear message if neither or both are supplied.

## Outputs

All results land in `results/`:

- `results/genome/{name}/` — downloaded reference FASTA + FAI
- `results/wig_track/{name}/` — WIG mappability tracks and intermediate files
- `results/pipeline_info/` — execution timeline, report, trace, DAG

## Dependencies

- Nextflow ≥ 21.04.0
- Singularity (or Docker/Podman) for container execution
- `sviatsidorov/uniqmaptrack:1.1` — core computation container
