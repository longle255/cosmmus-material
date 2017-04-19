LATEX     = pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error
BIBTEX    = bibtex
EMBED     = ./embed_fonts.sh
PDFOUT    = main
INPUTS    = main.tex

default: $(PDFOUT)

$(PDFOUT): $(INPUTS)
	$(LATEX) $(PDFOUT) && $(BIBTEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(EMBED) $(PDFOUT)

clean:
	for EXT in blg aux log bbl blg out idx lot lof toc synctex.gz; do rm -f *.$${EXT} */*.$${EXT} */*/*.$${EXT} $(PDFOUT).pdf ; done

