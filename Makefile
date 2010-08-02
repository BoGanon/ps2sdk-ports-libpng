# makefile for libpng.a and ps2 with gcc
# Copyright (C) 1998, 1999, 2002 Greg Roelofs and Glenn Randers-Pehrson
# Copyright (C) 1996, 1997 Andreas Dilger
# For conditions of distribution and use, see copyright notice in png.h

EE_LIB = libpng.a

PNGMAJ = 14
RELEASE = 3

EE_CFLAGS  += -DPNG_NO_WRITE_tIME
EE_LDFLAGS += -L. -L$(PS2SDK)/ports/lib
EE_INCS    += -I./include -I$(PS2SDK)/ports/include
EE_LIBS    += -lz -lm

# library files
EE_OBJS = png.o pngset.o pngget.o pngrutil.o pngtrans.o pngwutil.o \
	      pngread.o pngrio.o pngwio.o pngwrite.o pngrtran.o \
	      pngwtran.o pngmem.o pngerror.o pngpread.o

# pngtest files
PNG_TEST_OBJS = pngtest.o
PNG_TEST_BIN = pngtest.elf
PNG_TEST_CFLAGS = -DPNG_NO_WRITE_tIME -I$(PS2SDK)/ports/include -I./
PNG_TEST_LIBS = -lz -lm -lc -lkernel
PNG_TEST_LDFLAGS = -L$(PS2SDK)/ee/lib -L$(PS2SDK)/ports/lib libpng.a

all: $(EE_LIB) $(PNG_TEST_BIN)
	@echo ".LIBPNG Built."

$(PNG_TEST_BIN) : $(PNG_TEST_OBJS) $(PS2SDK)/ee/startup/crt0.o
	$(EE_CC) -mno-crt0 -T$(PS2SDK)/ee/startup/linkfile $(PNG_TEST_CFLAGS) \
		-o $(PNG_TEST_BIN) $(PS2SDK)/ee/startup/crt0.o $(PNG_TEST_OBJS) $(PNG_TEST_LDFLAGS) $(PNG_TEST_LIBS)

install: all
	mkdir -p $(DESTDIR)$(PS2SDK)/ports/include
	mkdir -p $(DESTDIR)$(PS2SDK)/ports/lib
	cp -f $(EE_LIB) $(DESTDIR)$(PS2SDK)/ports/lib
	cp -f png.h $(DESTDIR)$(PS2SDK)/ports/include
	cp -f pngconf.h $(DESTDIR)$(PS2SDK)/ports/include

clean:
	/bin/rm -f $(EE_OBJS_LIB) $(EE_OBJS) $(EE_BIN) $(EE_LIB) $(PNG_TEST_BIN) $(PNG_TEST_OBJS) 

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
