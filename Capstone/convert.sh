#!/bin/bash

PDF_ROOT="./Notebook PDFs"

# Clean out previous PDFs for a fresh start
rm -rf "$PDF_ROOT"

find . -type f -name "*.ipynb" | while read -r file; do
  # Extract the file path without the .ipynb extension
  base="${file%.ipynb}"
  filename="$(basename "$base")"
  dirpath="$(dirname "$file")"

  # Build output directory under "Notebook PDFs", mirroring the source folder structure
  outdir="$PDF_ROOT/$dirpath"
  mkdir -p "$outdir"
  outpdf="$outdir/$filename.pdf"

  echo "Processing: $file"

  # 1. Export the notebook to HTML
  jupyter nbconvert --to html "$file"

  # 2. Inject custom CSS to force full width and a wide custom page size
  sed -i "" "s|</head>|<style> .container, .jp-Notebook, #notebook-container { width: 100% !important; max-width: 100% !important; } @page { size: 16in 11in; margin: 0.5in; } </style></head>|g" "$base.html"

  # 3. Open HTML in Headless Chrome, remove headers/footers, and export to PDF
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf="$outpdf" \
    "$base.html"

  # 4. Delete the intermediate HTML file
  rm "$base.html"

  echo "Successfully created clean PDF: $outpdf"
done