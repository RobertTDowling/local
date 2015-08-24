RES=$(wildcard *.tex)
GVS=$(wildcard *.gv)
PNGS=$(subst .gv,.png,$(GVS))
PDFS=$(subst .tex,.pdf,$(RES))

CMD=fdp
CMD=neato
CMD=dot 

all: $(PNGS) $(PDFS)

clean:
	rm -f $(PNGS) *~

%.png: %.gv
	$(CMD) -Tpng -o $@ $<

%.eps: %.gv
	dot -Teps -o $@ $<

%.eps: %.m
	octave $<

%.pdf: %.tex
	./tops $<
