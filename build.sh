#!/bin/bash

if [[ $# -ne 1 ]]; then 
  echo "No file provided, exiting";
  exit 1;
fi;
engine=weasyprint;

pandoc $1 -o out.pdf --pdf-engine=$engine
