#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR
cd ..
mkdir -p htdocs
mkdir -p tmp

WMK_HOME=$(wmk info . | grep wmk.home | awk '{print $4}')
WMK_VERSION=$(wmk --version|awk '{print $3}')

perl -i -pe "s/date: version [0-9\\.]+/date: version $WMK_VERSION/" data/pdf.yaml

# write pdf with pandoc+typst
#    NOTE:  --syntax-definition=data/mako.xml does not ssem to work
tail -n +7 "$WMK_HOME/readme.md" \
    | sed 's/^```mako$/```adp/' \
    | pandoc -d typ --metadata-file=data/pdf.yaml \
      --shift-heading-level-by=-1 --toc -o tmp/wmk.pdf
# optimize for size and add header info for web usage
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="htdocs/wmk.pdf" "tmp/wmk.pdf"
qpdf --linearize --replace-input "htdocs/wmk.pdf"
