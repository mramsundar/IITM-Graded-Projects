#!/bin/bash

PDF_ROOT="./Notebook PDFs"

# Clean out previous PDFs for a fresh start
rm -rf "$PDF_ROOT"

find ./Notebooks -type f \( -name "*.ipynb" -o -name "*.py" -o -name "*.html" \) | while read -r file; do
  ext="${file##*.}"
  base="${file%.*}"
  filename="$(basename "$base")"
  dirpath="$(dirname "$file")"

  # Build output directory under "Notebook PDFs", mirroring the source folder structure
  outdir="$PDF_ROOT/$dirpath"
  mkdir -p "$outdir"
  outpdf="$outdir/$filename.pdf"

  echo "Processing: $file"

  if [ "$ext" = "ipynb" ]; then
    # 1. Export the notebook to HTML
    jupyter nbconvert --to html "$file"
    html_file="$base.html"
  elif [ "$ext" = "py" ]; then
    # Convert .py to HTML via pygments (syntax-highlighted)
    pygmentize -f html -O full,style=friendly -o "$base.html" "$file"
    html_file="$base.html"
  else
    # Already an HTML file — use directly
    html_file="$file"
  fi

  # 2. Inject custom CSS to force full width and a wide custom page size
  sed -i "" "s|</head>|<style> .container, .jp-Notebook, #notebook-container { width: 100% !important; max-width: 100% !important; } @page { size: 16in 11in; margin: 0.5in; } </style></head>|g" "$html_file"

  # 3. Open HTML in Headless Chrome, remove headers/footers, and export to PDF
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf="$outpdf" \
    "$html_file"

  # 4. Delete the intermediate HTML file (only if we created it)
  if [ "$ext" != "html" ]; then
    rm "$html_file"
  fi

  echo "Successfully created clean PDF: $outpdf"
done