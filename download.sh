#!/usr/bin/env bash
# Download weights for this model from Hugging Face.
# No token / no credentials needed (public repo, gated=false).
# Usage:
#   ./download.sh                # download default quant (Q4_K_M)
#   ./download.sh <quant>        # download another quant, e.g. ./download.sh AD-Q2_K
#   ./download.sh --list         # list all available quants and sizes
#   ./download.sh --mmproj       # download mmproj file(s) only
set -euo pipefail

HF_REPO="HauhauCS/Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced"
BASE="https://huggingface.co/$HF_REPO/resolve/main"
DEFAULT_QUANT="Q4_K_M"

list_quants() {
  echo "Available quants (from HF, verified 2026-11-09):"
  echo "  Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M  7.38 GB  Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf"
  echo "  mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf  0.18 GB  (extra file)"
  echo "  mtp-gemma-4-12B-it.gguf  0.25 GB  (extra file)"
}

files_for() {
  case "$1" in
    Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M|Q4_K_M) echo "Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf|7381381760|59656d7494d6376ca97e9e20b64ea2e16cd97f12ec6d47bfccba91cb785b5134" ;;
    mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf|mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16) echo "mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf|175115264|b59e815479b7e5f0665bd29e6784c104a368092bcbc63120148c606f9276ab8e" ;;
    mtp-gemma-4-12B-it.gguf|mtp-gemma-4-12B-it|mtp) echo "mtp-gemma-4-12B-it.gguf|253707328|c50c91c35f04903815b2e8930cbb8c8c5bee0e1aa00748c30a7b8ff05d2310b4" ;;
    *) echo "unknown quant: $1 (run ./download.sh --list)" >&2; exit 1 ;;
  esac
}

if [ "${1:-}" = "--list" ]; then list_quants; exit 0; fi
if [ "${1:-}" = "--mmproj" ]; then
  WANT="mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf|175115264|b59e815479b7e5f0665bd29e6784c104a368092bcbc63120148c606f9276ab8e"
else
  WANT="$(files_for "${1:-$DEFAULT_QUANT}")"
fi

# total size reminder
TOTAL=0
for spec in $WANT; do
  sz="${spec#*|}"; sz="${sz%%|*}"
  TOTAL=$((TOTAL + sz))
done
echo "Total download size: $((TOTAL / 1000000000)) GB ($TOTAL bytes) — make sure you have enough disk space."
echo "Source: https://huggingface.co/$HF_REPO"

for spec in $WANT; do
  fname="${spec%%|*}"
  rest="${spec#*|}"
  fsize="${rest%%|*}"
  fsha="${rest##*|}"
  echo "== $fname ($((fsize / 1000000000)) GB)"
  curl -L --fail --retry 3 -o "$fname" "$BASE/$fname"
  actual_size="$(wc -c < "$fname" | tr -d " ")"
  if [ "$actual_size" != "$fsize" ]; then
    echo "SIZE MISMATCH for $fname: expected $fsize, got $actual_size" >&2
    rm -f "$fname"; exit 1
  fi
  actual_sha="$(sha256sum "$fname" | cut -d" " -f1)"
  if [ "$actual_sha" != "$fsha" ]; then
    echo "SHA256 MISMATCH for $fname: expected $fsha, got $actual_sha" >&2
    rm -f "$fname"; exit 1
  fi
  echo "OK $fname (size + sha256 verified)"
done
echo "All files downloaded and verified."
