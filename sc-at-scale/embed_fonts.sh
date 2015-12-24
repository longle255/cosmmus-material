#!/bin/bash

set -x

file=$1
if [ -z "$1" ]
  then
    echo "No argument supplied. Using \"dssmr\"."
    file="main"
fi

pdf2ps ${file}.pdf && ps2pdf14 -dPDFSETTINGS=/prepress -dEmbedAllFonts=true ${file}.ps ${file}_embedded.pdf && rm ${file}.ps
