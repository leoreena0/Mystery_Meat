## Mystery Meat Assessment
### Overview
This repository contains GitBash nano file scripts used to concatenate initial samples and convert to fasta format. Also Python scripts with the sequence data used to analyse mitochondrial DNA sequences and identify the phylogenetic placement of unknown (“mystery”) samples. The project uses Biopython to translate nucleotide sequences, explore open reading frames (ORFs) and generate protein sequences for comparison. Nucleotide and amino-acid alignments are then used to construct phylogenetic trees to infer the identity of each of the samples.

### Repository contents
| File / Folder              | Description                                                                          |
| -------------------------- | ------------------------------------------------------------------------------------ |
| `all_sequences.fasta`      | Combined FASTA file containing reference mitochondrial sequences and mystery samples |
| `translate_sequences.py`   | Python script to translate DNA sequences and extract the longest ORF                 |
| `translated.fasta`         | Output FASTA file containing translated protein sequences                            |
| `aligned_translated.txt`   | Aligned amino-acid sequences (generated using Jalview/MAFFT)                         |
| `all_aligned_sequences/`   | Folder containing aligned nucleotide sequences                                       |
| `samples/`                 | Original FASTA files for individual mystery samples                                  |
| `Nucleotide Mystery Meat/` | Folder containing nucleotide alignments and phylogenetic trees                       |
| `Translated Mystery Meat/` | Folder containing protein alignments and phylogenetic trees                          |
| `env/`                     | Local Python environment (not required for assessment submission)                    |

### Required packages
This project requires GitBash, Python and the following packages:

`pip install biopython`
`pip install pandas`

Jalview was used separately for alignment and tree construction

### Workflow Summary
#### 1. Sequence Preparation
Reference sequences and mystery samples were combined into a single FASTA file (all_sequences.fasta).
Sequences were visually inspected for quality and ambiguous regions.

#### 2. ORF Detection and Translation
DNA sequences were translated using translate_sequences.py.
The script translates all three forward reading frames and selects the longest ORF.
This step was used to assess coding integrity and data quality, not as the primary phylogenetic dataset.

#### 3. Alignment
Nucleotide sequences were aligned using MAFFT via Jalview.
Protein sequences were also aligned to explore amino-acid-level similarity.
Alignments were trimmed to remove poorly aligned or unreliable regions.

#### 4. Phylogenetic Analysis
Neighbour-Joining trees were generated in Jalview.
Nucleotide trees were used as the primary evidence for sample identification.
Protein trees were used for comparison but interpreted with caution due to ambiguous residues and poor alignment.
