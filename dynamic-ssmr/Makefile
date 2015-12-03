LATEX  = pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error
BIBTEX = bibtex
EMBED  = ./embed_fonts.sh
PDFOUT = main
INPUTS = main.tex \
         abstract.tex \
         background-and-motivation.tex \
         dynamic-ssmr.tex \
         introduction.tex \
         model-and-definitions.tex

default: $(PDFOUT)

$(PDFOUT): $(INPUTS)
	$(LATEX) $(PDFOUT) && $(BIBTEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(EMBED) $(PDFOUT)

clean:
	for EXT in blg aux log bbl blg out idx log lot lof toc ; do rm -f *.$${EXT} */*.$${EXT} */*/*.$${EXT} $(MWPDF).pdf ; done
