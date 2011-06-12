
# A terribly simple latex makefile.
# DCJ // 2011.01.12

TEXINPUTS=.:bioinformatics:
TEX=pdflatex
BIB=bibtex

#figs = $(shell ls fig/*.svg | sed 's/svg$$/pdf/')
figs =
docs = $(shell ls *.tex | sed 's/tex$$/pdf/')

# keep intermediate files (i.e. bbl and aux files)
.SECONDARY :

all : $(docs)

#%.aux : %.tex
	#$(TEX) $*

%.bbl : %.bib %.aux
	$(BIB) $*

#%.pdf : %.tex %.bbl $(figs)
	#$(TEX) $*
	#$(TEX) $*

seqbias-paper.pdf : seqbias-paper.tex $(figs)
	$(TEX) $<
	$(TEX) $<

seqbias-supplement.pdf : seqbias-supplement.tex $(figs)
	$(TEX) $<
	$(TEX) $<

fig/%.pdf : fig/%.svg
	inkscape $< --export-pdf=$@

clean :
	rm -f *.aux *.bbl *.blg *.log *.pdf


