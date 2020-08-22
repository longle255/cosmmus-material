LATEX     = pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error
BIBTEX    = bibtex
EMBED     = ./embed_fonts.sh
PDFOUT    = main
INPUTS    = main.tex

default: $(PDFOUT) clean

$(PDFOUT): $(INPUTS)
	$(LATEX) $(PDFOUT) && $(BIBTEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(EMBED) $(PDFOUT)

clean:
	for EXT in ilg blg aux log bbl blg out idx lot lof toc synctex.gz fls fdb_latexmk; do rm -f *.$${EXT} */*.$${EXT} */*/*.$${EXT} ; done

