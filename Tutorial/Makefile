## please modify the following line for naming the end products (PDFs, ZIPs, ...)
PROJECTNAME = "Tutorial_tugPoster"

## some Makefile-hints taken from: 
## http://www.ctan.org/tex-archive/help/uk-tex-faq/Makefile
## and
## Karl Voits Masterthesis Latex Template

MAINDOCUMENTBASENAME = main
MAINDOCUMENTFILENAME = ${MAINDOCUMENTBASENAME}.tex
## COMMANDS:
PDFLATEX_CMD = pdflatex
DATESTAMP = `/bin/date +%Y-%m-%d`
DATESTAMP_AND_PROJECT = ${DATESTAMP}_${PROJECTNAME}

TUTORIAL_SRC=$(wildcard src/*.tex)
TUTORIAL_PDF=$(TUTORIAL_SRC:.tex=.pdf)

.PHONY: all
all: tutorial

.PHONY: tutorial
tutorial: examples
	${PDFLATEX_CMD} ${MAINDOCUMENTFILENAME}
	${PDFLATEX_CMD} ${MAINDOCUMENTFILENAME}


.PHONY: examples
examples: $(TUTORIAL_PDF)

.PHONY: force
force:
	touch *.tex
	touch src/*.tex

src/%.pdf: src/%.tex
	cd src; ${PDFLATEX_CMD} $(notdir $<); ${PDFLATEX_CMD} $(notdir $<);

.PHONY: clean
clean: 
	-rm -f *.aux *.bbl ${MAINDOCUMENTBASENAME}.dvi *.ps *.blg *.idx *.ilg *.ind *.toc *.log *.brf *.out *.lof *.lot *.gxg *.glx *.gxs *.glo *.gls *.tdo
	-rm -f src/*.aux src/*.dvi src/*.ps src/*.idx src/*.ilg src/*.ind src/*.toc src/*.log src/*.brf src/*.out src/*.lof src/*.lot src/*.gxg src/*.glx src/*.gxs src/*.glo src/*.gls src/*.tdo
