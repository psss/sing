#export LANG=cz
STRANEK_NA_SVAZEK=20
MAX_STRANEK=500
#RAMECKOVAT=-d
TARGETS=zpevnik.obs zpevnik.srt zpevnik.ps zpevnik.2.ps zpevnik.4.ps \
        songbook.obs songbook.srt songbook.ps songbook.2.ps songbook.4.ps \
        harlem.obs harlem.srt harlem.ps harlem.2.ps harlem.4.ps \
        truhla.obs truhla.srt truhla.ps truhla.2.ps truhla.4.ps

all: $(TARGETS)

zpevnik: zpevnik.dvi zpevnik.4.ps

songbook: songbook.dvi songbook.4.ps

harlem: harlem.dvi harlem.4.ps

#
#  zaklad -- texovani, dvipsovani, obsahovani
#

%.dvi: %.tex %.obs %.srt
	@echo
	@echo "texuju $*..."
	@csplain $*.tex

%.pdf: %.tex %.obs %.srt
	@echo
	@echo "převádím do pdf..."
	@pdfcsplain $*.tex

%.srt: %.tex
	@echo
	@echo "třídím obsah..."
	@sort +1 $*.obs >$*.srt

%.ps: %.dvi %.srt
	@echo
	@echo "převádím do ps..."
	@dvips $*.dvi -o $*.ps

%.book.ps: %.ps Makefile
	@echo
	@echo "dělám knížku..."
	@psbook -s$(STRANEK_NA_SVAZEK) $*.ps $*.book.ps

#  neni vubec zadny obsah
%.obs: %.tex
	@if [ ! -e $*.obs ]; then \
	    echo; \
	    echo "texuju $* kvuli obsahu..."; \
	    touch $*.srt; \
	    pdfcsplain $*.tex; \
	    rm $*.srt; \
	fi

#
#  dve strany na stranu
#

%.2.ps: %.book.ps
	@echo ""
	@echo "skládám po dvou..."
	@pstops '2:1R@.65(1cm,14.6cm)+0R@.65(1cm,29cm)' $(RAMECKOVAT) $*.book.ps $*.2.ps
	
#
#  ctyri strany na stranu
#

%.bookr.ps: %.book.ps prehod.pl
	@echo
	@echo "menší úprava řazení..."
	@psselect -p`./prehod.pl $(MAX_STRANEK)` $*.book.ps $*.bookr.ps

%.4.ps: %.bookr.ps
	@echo
	@echo "skládám po čtyřech..."
	@pstops '4:0@.45(0.8cm,16.3cm)+1@.45(10.8cm,16.3cm)+2@.45(0.8cm,1.5cm)+3@.45(10.8cm,1.5cm)' $(RAMECKOVAT) $*.bookr.ps $*.4.ps

#
#  sestnact stran na stranu
#

%.book16.ps: %.4.ps Makefile
	@echo
	@echo "dělám knížku ze čtyřstránek..."
	@psbook -s$(STRANEK_NA_SVAZEK) $*.4.ps $*.book16.ps

%.bookr16.ps: %.book16.ps prehod.pl
	@echo
	@echo "menší úprava řazení čtyřstránek..."
	@psselect -p`./prehod.pl $(MAX_STRANEK)` $*.book16.ps $*.bookr16.ps

%.16.ps: %.bookr16.ps
	@echo
	@echo "skládám po šestnácti..."
#	@pstops '4:0@.5(0cm,14.85cm)+1@.5(10.5cm,14.85cm)+2@.5(0cm,0cm)+3@.5(10.5cm,0cm)' $(RAMECKOVAT) $*.bookr16.ps $*.16.ps
	@pstops '4:0@.45(0.525cm,15.593cm)+1@.45(11.025cm,15.593cm)+2@.45(0.525cm,0.743cm)+3@.45(11.025cm,0.743cm)' $(RAMECKOVAT) $*.bookr16.ps $*.16.ps


#
#  uklid
#

clean:
	@-rm -f *.dvi *.obs *.srt *.log *.ps *.pdf 2>/dev/null
