#!/usr/bin/env python
"""
Compute spectral k-mer length distributions from WIG mappability tracks.

Usage: spectral_plot.py <mul.wig> <mur.wig> <name>

Outputs:
  {name}_mul_spectral_plot.tsv  - binned counts (fixed bins for compatibility)
  {name}_mur_spectral_plot.tsv
  {name}_mul_raw.tsv            - raw value counts (for adaptive binning in R)
  {name}_mur_raw.tsv
  {name}_mul_max.txt            - true max k-mer value observed
  {name}_mur_max.txt
"""
import sys
from collections import Counter

BINS = [15, 20, 25, 35, 50, 100, 300, 1000, 10000, 97700]


def parse_wig(path):
    """Read WIG file, skip headers, yield integer k-mer values."""
    with open(path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('fixedStep') or line.startswith('track'):
                continue
            yield int(line)


def bin_values(values):
    """Bin values into fixed ranges. Returns dict with bin labels as keys."""
    counts = {str(b): 0 for b in BINS}
    counts['more'] = 0

    for v in values:
        if v <= 0:
            continue
        for b in BINS:
            if v <= b:
                counts[str(b)] += 1
                break
        else:
            counts['more'] += 1

    return counts


def process_wig(path, name, suffix):
    """Process a single WIG file, output all TSVs and max file."""
    values = list(parse_wig(path))

    if not values:
        max_val = 0
    else:
        max_val = max(values)

    # Raw value counts
    raw_counts = Counter(values)
    with open(f"{name}_{suffix}_raw.tsv", 'w') as f:
        f.write("kmer_length\tcount\n")
        for k in sorted(raw_counts.keys()):
            f.write(f"{k}\t{raw_counts[k]}\n")

    # Max value
    with open(f"{name}_{suffix}_max.txt", 'w') as f:
        f.write(str(max_val))

    # Binned counts (compatible with original format)
    binned = bin_values(values)
    with open(f"{name}_{suffix}_spectral_plot.tsv", 'w') as f:
        f.write("\tbin\tcount\n")
        for i, b in enumerate(BINS):
            f.write(f"{i}\t{b}\t{binned[str(b)]}\n")
        f.write(f"{len(BINS)}\tmore\t{binned['more']}\n")

    return max_val, len(values)


def main():
    if len(sys.argv) != 4:
        print(__doc__)
        sys.exit(1)

    mul_path = sys.argv[1]
    mur_path = sys.argv[2]
    name = sys.argv[3]

    mul_max, mul_count = process_wig(mul_path, name, 'mul')
    mur_max, mur_count = process_wig(mur_path, name, 'mur')

    print(f"{name}: {mul_count} positions, max_mul={mul_max}, max_mur={mur_max}")


if __name__ == '__main__':
    main()
