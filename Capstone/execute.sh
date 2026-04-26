#!/bin/bash

# Find all notebooks within the Notebooks folder, sort them to ensure top-down execution, and process them
find ./Notebooks -type f -name "*.ipynb" | sort | while read -r file; do
  echo "Executing: $file"

  # Execute the notebook and save the outputs directly back into the same file
  jupyter nbconvert --execute --inplace "$file"

  echo "Finished: $file"
done