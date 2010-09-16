INSTALL      = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644
prefix       = /usr/local
datarootdir  = ${prefix}/share
datadir      = ${datarootdir}
infodir      = ${datarootdir}/info
lispdir      = $(prefix)/share/emacs/site-lisp/w3m
srcdir       = .
PACKAGEDIR   = NONE
ICONDIR      = $(prefix)/share/emacs/23.2/etc/images/w3m
ADDITIONAL_LOAD_PATH = NONE

SHELL        = /bin/sh


EMACS   = /usr/local/bin/emacs-23.2
VANILLA_FLAG = -q -no-site-file --no-unibyte
FLAGS   = $(VANILLA_FLAG) -batch -l $(srcdir)/w3mhack.el $(ADDITIONAL_LOAD_PATH)

## This is used to set the environment variable XEMACSDEBUG for XEmacs
## 21.5 in order to suppress warnings for Lisp shadows when XEmacs 21.5
## starts.  This is used also for not installing w3m-ems.el for XEmacs
## and w3m-xmas.el for GNU Emacs.
XEMACSDEBUG = 

IGNORES = w3mhack.el

PACKAGE = emacs-w3m
TARBALL = $(PACKAGE)-$(VERSION).tar.gz
DISTDIR = $(PACKAGE)-$(VERSION)

default: all

all: lisp info

all-en: lisp info-en

all-ja: lisp info-ja

lisp: Makefile
	env test ! -f w3m-util.elc -o w3m-util.elc -nt w3m-util.el || $(MAKE) clean
	env test ! -f w3m-proc.elc -o w3m-proc.elc -nt w3m-proc.el || $(MAKE) clean
	$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-compile

what-where:
	@$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-what-where\
	 "$(lispdir)" "$(ICONDIR)" "$(PACKAGEDIR)" "$(infodir)"

info:
	cd doc && $(MAKE) EMACS="$(EMACS)"

info-en:
	cd doc && $(MAKE) EMACS="$(EMACS)" en

info-ja:
	cd doc && $(MAKE) EMACS="$(EMACS)" ja

install: install-lisp install-info

install-en: install-lisp install-info-en

install-ja: install-lisp install-info-ja

install-lisp: lisp
	@$(SHELL) $(srcdir)/mkinstalldirs "$(lispdir)";\
	for p in ChangeLog ChangeLog.[1-9] ChangeLog.[1-9][0-9] *.el; do\
	  if test -f "$$p"; then\
	    case "$$p" in\
	      $(IGNORES)) ;;\
	      w3m-ems\.el) if test -z "$(XEMACSDEBUG)"; then\
	         echo "$(INSTALL_DATA) $$p \"$(lispdir)/$$p\"";\
	         $(INSTALL_DATA) $$p "$(lispdir)/$$p"; fi;;\
	      w3m-xmas\.el) if test -n "$(XEMACSDEBUG)"; then\
	         echo "$(INSTALL_DATA) $$p \"$(lispdir)/$$p\"";\
	         $(INSTALL_DATA) $$p "$(lispdir)/$$p"; fi;;\
	      *) echo "$(INSTALL_DATA) $$p \"$(lispdir)/$$p\"";\
	         $(INSTALL_DATA) $$p "$(lispdir)/$$p";;\
	    esac;\
	  fi;\
	done;\
	for p in *.elc; do\
	  if test -f "$$p"; then\
	    echo "$(INSTALL_DATA) $$p \"$(lispdir)/$$p\"";\
	    $(INSTALL_DATA) $$p "$(lispdir)/$$p";\
	  fi;\
	done;\
	if test -f shimbun/shimbun.elc; then\
	  for p in `cd shimbun && echo ChangeLog ChangeLog.[1-9] ChangeLog.[1-9][0-9]`; do\
	    if test -f "shimbun/$$p"; then\
	      echo "$(INSTALL_DATA) shimbun/$$p \"$(lispdir)/s$$p\"";\
	      $(INSTALL_DATA) shimbun/$$p "$(lispdir)/s$$p";\
	    fi;\
	  done;\
	  for p in `cd shimbun && echo *.el`; do\
	    echo "$(INSTALL_DATA) shimbun/$$p \"$(lispdir)/$$p\"";\
	    $(INSTALL_DATA) shimbun/$$p "$(lispdir)/$$p";\
	  done;\
	  for p in `cd shimbun && echo *.elc`; do\
	    echo "$(INSTALL_DATA) shimbun/$$p \"$(lispdir)/$$p\"";\
	    $(INSTALL_DATA) shimbun/$$p "$(lispdir)/$$p";\
	  done;\
	fi

install-icons:
	@if test "$(ICONDIR)" = NONE; then\
	  echo "You don't have to install icon files for \"$(EMACS)\".";\
	else\
	  $(SHELL) $(srcdir)/mkinstalldirs "$(ICONDIR)";\
	  for i in `cd icons && echo *.gif *.png *.xpm`; do\
	    echo "$(INSTALL_DATA) icons/$$i \"$(ICONDIR)/$$i\"";\
	    $(INSTALL_DATA) icons/$$i "$(ICONDIR)/$$i";\
	  done;\
	fi

install-icons30:
	@if test "$(ICONDIR)" = NONE; then\
	  echo "You don't have to install icon files for \"$(EMACS)\".";\
	else\
	  $(SHELL) $(srcdir)/mkinstalldirs "$(ICONDIR)";\
	  for i in `cd icons30 && echo *.gif *.png *.xpm`; do\
	    echo "$(INSTALL_DATA) icons30/$$i \"$(ICONDIR)/$$i\"";\
	    $(INSTALL_DATA) icons30/$$i "$(ICONDIR)/$$i";\
	  done;\
	fi

install-info: info
	cd doc && $(MAKE) EMACS="$(EMACS)" infodir="$(infodir)" install

install-info-en: info-en
	cd doc && $(MAKE) EMACS="$(EMACS)" infodir="$(infodir)" install-en

install-info-ja: info-ja
	cd doc && $(MAKE) EMACS="$(EMACS)" infodir="$(infodir)" install-ja

install-package:
	@if test $(PACKAGEDIR) = NONE; then\
	  echo "What a pity!  Your \"$(EMACS)\" does not support"\
		"the package system.";\
	else\
	  $(MAKE) lispdir="$(PACKAGEDIR)/lisp/w3m" install-lisp;\
	  $(MAKE) ICONDIR="$(PACKAGEDIR)/etc/images/w3m" install-icons30;\
	  $(MAKE) infodir="$(PACKAGEDIR)/info" install-info;\
	  echo "$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-make-package $(PACKAGEDIR)";\
	  $(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-make-package $(PACKAGEDIR);\
	fi

install-package-ja:
	@if test $(PACKAGEDIR) = NONE; then\
	  echo "What a pity!  Your \"$(EMACS)\" does not support"\
		"the package system.";\
	else\
	  $(MAKE) lispdir="$(PACKAGEDIR)/lisp/w3m" install-lisp;\
	  $(MAKE) ICONDIR="$(PACKAGEDIR)/etc/images/w3m" install-icons30;\
	  $(MAKE) infodir="$(PACKAGEDIR)/info" install-info-ja;\
	  echo "$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-make-package $(PACKAGEDIR)";\
	  $(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-make-package $(PACKAGEDIR);\
	fi

Makefile: Makefile.in config.status
	$(srcdir)/config.status

config.status: configure
	$(srcdir)/config.status --recheck

configure: configure.in aclocal.m4
	autoconf

dist: Makefile w3m.elc
	$(MAKE) tarball \
	  VERSION=`$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-version 2>/dev/null` \
	  BRANCH=`cvs status Makefile.in|grep "Sticky Tag:"|awk '{print $$3}'|sed 's,(none),HEAD,'`

tarball: CVS/Root CVS/Repository
	-rm -rf $(DISTDIR) $(TARBALL) `basename $(TARBALL) .gz`
	cvs -d `cat CVS/Root` -w export -d $(DISTDIR) -r $(BRANCH) `cat CVS/Repository`
	-cvs diff |( cd $(DISTDIR) && patch -p0 )
	for f in BUGS.ja; do\
	  if [ -f $(DISTDIR)/$${f} ]; then\
	    rm -f $(DISTDIR)/$${f} || exit 1;\
	  fi;\
	done
	find $(DISTDIR) -name .cvsignore | xargs rm -f
	find $(DISTDIR) -type d | xargs chmod 755
	find $(DISTDIR) -type f | xargs chmod 644
	cd $(DISTDIR) && autoconf
	chmod 755 $(DISTDIR)/configure $(DISTDIR)/install-sh
	tar -cf `basename $(TARBALL) .gz` $(DISTDIR)
	gzip -9 `basename $(TARBALL) .gz`
	rm -rf $(DISTDIR)

clean:
	-rm -rf $(PACKAGE)* ;\
	rm -f *~ *.elc shimbun/*.elc w3m-load.el ;\
	rm -f doc/*~ doc/*.info doc/*.info-[0-9] doc/*.info-[0-9][0-9]\
 doc/version.texi

distclean: clean
	-rm -f config.log config.status config.cache Makefile doc/Makefile;\
	rm -fr autom4te*.cache

## Rules for the developers to check the portability for each module.
.SUFFIXES: .elc .el

.el.elc:
	echo "$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f batch-byte-compile $*.el";\
	$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f batch-byte-compile $*.el

slow: Makefile
	@for i in `$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-examine-modules 2>/dev/null`;\
	do $(MAKE) -s $$i; done

very-slow: clean Makefile
	@args="$(VANILLA_FLAG) -batch";\
	args="$$args -l $(srcdir)/attic/addpath.el $(ADDITIONAL_LOAD_PATH)";\
	echo "=============================================";\
	echo "Compiling the 1st stage-----without elc files";\
	echo "=============================================";\
	for i in `$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-examine-modules 2>/dev/null`;\
	  do\
	  j=`echo $$i| sed 's/elc$$/el/g'`;\
	  echo "$(XEMACSDEBUG)$(EMACS) ARGS -f batch-byte-compile $$j";\
	  $(XEMACSDEBUG)$(EMACS) $$args -f batch-byte-compile $$j;\
	  mv $$i $$j"x";\
	done;\
	for i in `echo *.elx shimbun/*.elx`; do\
	  j=`echo $$i| sed 's/elx$$/elc/g'`;\
	  if test -f $$i; then mv $$i $$j; fi;\
	done;\
	echo "==============================================";\
	echo "Compiling the 2nd stage-----with all elc files";\
	echo "==============================================";\
	for i in `$(XEMACSDEBUG)$(XEMACSDEBUG)$(EMACS) $(FLAGS) -f w3mhack-examine-modules 2>/dev/null`;\
	  do\
	  j=`echo $$i| sed 's/elc$$/el/g'`;\
	  echo "$(XEMACSDEBUG)$(EMACS) ARGS -f batch-byte-compile $$j";\
	  $(XEMACSDEBUG)$(EMACS) $$args -f batch-byte-compile $$j;\
	done
