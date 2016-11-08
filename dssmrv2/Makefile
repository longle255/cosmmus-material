LATEX     = pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error
BIBTEX    = bibtex
EMBED     = ./embed_fonts.sh
PDFOUT    = main
INPUTS    = abstract.tex \
            background.tex \
            centralized.tex \
            conclusion.tex \
            correctness.tex \
            experiments.tex \
            implementation.tex \
            intro.tex \
            main.tex \
            model.tex \
            related_work.tex

default: $(PDFOUT)

$(PDFOUT): $(INPUTS)
	$(LATEX) $(PDFOUT) && $(BIBTEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(LATEX) $(PDFOUT) && $(EMBED) $(PDFOUT)

clean:
	for EXT in blg aux log bbl blg out idx lot lof toc synctex.gz; do rm -f *.$${EXT} */*.$${EXT} */*/*.$${EXT} $(PDFOUT).pdf ; done

