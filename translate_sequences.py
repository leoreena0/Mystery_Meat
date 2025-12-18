import pandas as pd
from Bio.SeqUtils.ProtParam import ProteinAnalysis
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio import SeqIO

# -----------------------------
# Read sequences
# -----------------------------

input_fasta = "all_sequences.fasta"
records = list(SeqIO.parse(input_fasta, "fasta"))

# -----------------------------
# Translate DNA to protein
# (longest ORF, 3 forward frames)
# -----------------------------

aa_records = []

for record in records:
    dna_seq = record.seq.upper()

    best_orf = ""
    best_frame = None

    for frame in range(3):
        # Vertebrate mitochondrial genetic code
        protein = dna_seq[frame:].translate(
            table=2,
            to_stop=False
        )

        # Split at stop codons
        fragments = str(protein).split("*")
        longest_fragment = max(fragments, key=len)

        if len(longest_fragment) > len(best_orf):
            best_orf = longest_fragment
            best_frame = frame

    best_protein = Seq(best_orf)

    # Try to extract organism name, fallback to ID
    desc = record.description
    if "[organism=" in desc:
        start = desc.find("[organism=") + len("[organism=")
        end = desc.find("]", start)
        name = desc[start:end].replace(" ", "_")
    else:
        name = record.id

    aa_record = SeqRecord(
        best_protein,
        id=name,
        description=f"Longest ORF, frame {best_frame}",
        annotations={"frame": best_frame}
    )

    aa_records.append(aa_record)

# -----------------------------
# Write translated FASTA
# -----------------------------

SeqIO.write(aa_records, "translated.fasta", "fasta")
