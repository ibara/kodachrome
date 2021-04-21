# kodachrome Makefile

PROG =	kodachrome
OBJS =	app.o kodachrome/png.o kodachrome/x.o x11/X.o x11/Xlib.o

DFLAGS =	-O2 -pipe -frelease -finline

all: ${OBJS}
	${DC} ${LDFLAGS} -o ../${PROG} ${OBJS} -lX11 -lpng

clean:
	rm -f ../${PROG} ${OBJS}
