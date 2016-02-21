# st-ito - simple terminal
# See LICENSE file for copyright and license details.

include config.mk

SRC = st-ito.c
OBJ = ${SRC:.c=.o}

all: options st-ito

options:
	@echo st-ito build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

config.h:
	cp config.def.h config.h

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

st-ito: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f st-ito ${OBJ} st-ito-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p st-ito-${VERSION}
	@cp -R LICENSE Makefile README config.mk config.def.h st-ito.info st-ito.1 arg.h ${SRC} st-ito-${VERSION}
	@tar -cf st-ito-${VERSION}.tar st-ito-${VERSION}
	@gzip st-ito-${VERSION}.tar
	@rm -rf st-ito-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f st-ito ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/st-ito
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < st-ito.1 > ${DESTDIR}${MANPREFIX}/man1/st-ito.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/st-ito.1
	@echo Please see the README file regarding the terminfo entry of st-ito.
	@tic -s st-ito.info

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/st-ito
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/st-ito.1

.PHONY: all options clean dist install uninstall
