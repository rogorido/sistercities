# No está mal: http://www.physics.wm.edu/~norman/thesis/Makefile
# posibles mejoras: 
# -- aquí http://www.takeonthecity.nl/wp-content/uploads/2009/06/Makefile
#    por ejemplo escogen el nombre del archivo a compilar
#    mirando qué fichero tiene \begin{document}
# tengo varias variables que no uso (QUIET, DISPLAYERROR, etc.)
# las he cogido de http://www.acoustics.hut.fi/u/mairas/UltimateLatexMakefile

# uno de los asuntos que me ha vuelto loco es cómo saber si hay un proceso
# con un zathura abierto, por lo que haría innecesario abrirlo de nuevo
# al final tengo esta solución con lo de shell pgrep y luego comprueba con
# if [ -z VIEWEROPEN ] si esa cadena está vacía o no. Luego también ha sido problemático 
# que arrancara el proceso en el background dentro de ese if. AL final lo he conseguido 
# poniendo un & depués de fi.... PERO: no funciona bien del todo. Da un error cuando ya está abierto

# otra de las cuestiones son las llamadas Target-specific Variable Values. (6.11 del manual)
# el asunto es el siguiente: yo solo defino una variable LATEX, pero a veces quiero que sea 
# pdflatex y otras xelatex. El asunto parece que es fácil, sólo hay que poner otra entrada antes
# que redefine la variable. 

# TODO: 
# [1] cuando se ha compilado con xelatex o pdflatex y compilamos
# con el otro sin borrar los ficheros temporales se puede quedar
# colgado. Lo ideal sería comprobar con pdfinfo antes de compilar: a)
# qué compilador estamos usando y b) borrar todo lo temporal si no es
# el mismo.

# Eine tolle Idee, das Target zu erraten:
ifndef DATEI
  DATEI=$(basename $(shell egrep -l 'documentclass' *.tex) )
  target_guessed=true
endif

LATEX	                = pdflatex
BIBTEX	                = biber
PDFVIEW                 = zathura
CONVERT                 = convert
SHELL			= /usr/bin/sh
CLEAN_FILES		= *.aux *.bbl *.bcf *.blg *-blx.bib *.dvi \
			  *.idx *.ilg *.ind *.log *.out *.run.xml *.toc *~ \
			  *.nav *.snm *.vrb

VIEWEROPEN :=$(shell pgrep -f "zathura.*$(DATEI)")


RERUN = "(Rerun to get (cross-references|the bars) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"

#Colors
gray=\e[1;30m
red=\e[0;31m
RED=\e[1;31m
blue=\e[0;34m
BLUE=\e[1;34m
green=\e[0;32m
GREEN=\e[1;32m
cyan=\e[0;36m
CYAN=\e[1;36m
NC=\e[0m # No Color

QUIET= &>/dev/null
DISPLAYERROR= || ( echo -e "$(BLUE)====> $(RED)Errors encountered:$(NC)" && perl -0 -ne '$$now=0;$$previous=0;@matches=/(![^.]*[.]\s*\n(?:[^l].*\n)*(l[.][0-9]+.*)\n)/g;foreach $$text (@matches) { if ($$text =~ /^l[.][0-9]+.*$$/) { $$previous = $$text } else { $$text =~ /\n(l[.][0-9]+.*)/; $$now=$$1; if ( $$previous ne  $$now ) { print "\n$$text\n" } } }' $(<:%.tex=%.log) && false )


.PHONY: pdf xelatex clean 

pdf: LATEX = pdflatex
pdf: $(DATEI).pdf

xelatex: LATEX = xelatex
xelatex: $(DATEI).pdf

$(DATEI).pdf: $(DATEI).tex
	git pull
	@echo -e "$(BLUE)====> $(green)Generando información de git$(NC)";\
	./vc $(QUIET)
	@echo -e "$(BLUE)====> $(green)Compilando$(NC)$(DATEI)";\
	$(LATEX) $(DATEI) $(QUIET) $(DISPLAYERROR)

	@if(grep "Citation" $(DATEI).log >/dev/null);\
	then \
		echo -e "$(BLUE)====> $(green)Extrayendo la bibliografía$(NC)";\
		$(BIBTEX) $(DATEI) $(QUIET) $(DISPLAYERROR);\
		echo -e "$(BLUE)====> $(green)Compilando$(NC)$(DATEI)$(green) para introducir biblio$(NC)";\
		$(LATEX) $(DATEI) $(QUIET) $(DISPLAYERROR);\
	fi

	@if(grep "Rerun to get" $(DATEI).log >/dev/null);\
	then \
		echo -e "$(BLUE)====> $(green)Compilando de nuevo$(NC)$(DATEI)$(NC)";\
		$(LATEX) $(DATEI) $(QUIET);\
	fi

	@if(grep "Page breaks" $(DATEI).log >/dev/null);\
	then \
		echo -e "$(BLUE)====> $(green)Compilando una última vez$(NC)$(DATEI)";\
		$(LATEX) $(DATEI) $(QUIET);\
	fi

# IMPORTANTE es el & después del fi pues hace que mande el proceso al
# background; PERO: no funciona bien del todo. Da un error cuando ya
# está abierto... de hecho lo he QUITADO!
read: pdf
	@if [ -z $(VIEWEROPEN) ]; then \
		echo -e "$(BLUE)====> $(green)Abriendo el PDF $(NC)";\
		$(PDFVIEW) $(DATEI).pdf $(QUIET) 2>&1; \
	else \
		echo -e "$(BLUE)====> $(green)PDF ya está abierto$(NC)";\
	fi

aread:  pdf
	@acroread ${DATEI}.pdf $(QUIET) &

clean:
	@rm -f $(CLEAN_FILES) && echo -e "$(BLUE)====> $(green)Borrados todos los ficheros temporales$(NC)";\

distclean: clean
	@rm -f $(DATEI).pdf && echo -e "$(BLUE)====> $(green)Borrado el PDF$(NC)";\
