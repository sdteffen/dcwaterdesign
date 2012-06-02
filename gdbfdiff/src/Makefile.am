## Process this file with automake to produce Makefile.in

INCLUDES = \
	-DPACKAGE_PREFIX=\""$(prefix)"\" \
	-DPACKAGE_DATA_DIR=\""$(datadir)"\" \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	@PACKAGE_CFLAGS@

bin_PROGRAMS = gdbfdiff

gdbfdiff_SOURCES = \
	main.c \
	support.c support.h \
	interface.c interface.h \
	callbacks.c callbacks.h

gdbfdiff_LDADD = @PACKAGE_LIBS@ $(INTLLIBS)

