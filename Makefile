# Makefile to build the ORP NP-hardness PDFs from their LaTeX sources.
#
# One PDF per .tex file:
#   orp_np_hardness_statements.pdf
#   orp_np_hardness_simplified.pdf
#   orp_np_hardness_appendix.pdf
#   orp_blocks_slots_figure.pdf
#
# Bibliographies are inline (thebibliography), so no BibTeX/biber is needed.
# latexmk runs pdflatex as many times as required to resolve labels and
# hyperref/xr cross-references.

LATEXMK := latexmk
LATEXMKFLAGS := -pdf -interaction=nonstopmode -halt-on-error

TEX := orp_np_hardness_statements orp_np_hardness_simplified orp_np_hardness_appendix orp_blocks_slots_figure
PDF := $(addsuffix .pdf,$(TEX))

.PHONY: all clean cleanall

all: $(PDF)

# simplified pulls cross-references from the appendix via xr-hyper, so the
# appendix .aux should exist first.
orp_np_hardness_simplified.pdf: orp_np_hardness_appendix.aux

%.pdf: %.tex
	$(LATEXMK) $(LATEXMKFLAGS) $<

%.aux: %.tex
	$(LATEXMK) $(LATEXMKFLAGS) $<

# Remove auxiliary files but keep the PDFs.
clean:
	$(LATEXMK) -c $(TEX)

# Remove auxiliary files and the PDFs.
cleanall:
	$(LATEXMK) -C $(TEX)
