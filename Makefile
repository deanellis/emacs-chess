SPECIAL = chess-auto.el
SOURCE	= $(filter-out $(SPECIAL),$(wildcard *.el))
TARGET	= $(patsubst %.el,%.elc,$(SPECIAL) $(SOURCE))
EMACS   = emacs

MAKEINFO = makeinfo
TEXI2DVI = texi2dvi
ENVADD = TEXINPUTS="$(TEXINPUTS)" MAKEINFO="$(MAKEINFO) -I$(srcdir)"

all: $(TARGET) chess.info

chess-auto.el: chess-auto.in $(SOURCE)
	cp chess-auto.in chess-auto.el
	-rm chess-auto.elc
	$(EMACS) --no-init-file --no-site-file -batch \
		-l $(shell pwd)/chess-auto \
		-f generate-autoloads \
		$(shell pwd)/chess-auto.el .

%.elc: %.el
	$(EMACS) --no-init-file --no-site-file -batch \
		-l $(shell pwd)/chess-maint \
		-f batch-byte-compile $<

chess.info: chess.texi
	$(MAKEINFO) chess.texi

chess.dvi: chess.texi
	$(ENVADD) $(TEXI2DVI) chess.texi

clean:
	rm -f $(TARGET) *~ chess.dvi chess.info
	rm -f *.aux *.cp *.cps *.fn *.fns *.ky *.log *.pg *.toc *.tp *.vr

fullclean: clean
	-rm *.elc chess-auto.el
