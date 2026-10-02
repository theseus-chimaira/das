PREFIX ?= /usr/local
PDP10_PREFIX = ${PREFIX}
BINDIR = ${PDP10_PREFIX}/bin

CC = cc
CFLAGS = -O2
HOST_CPPFLAGS = -DDAS_HOST
LN = ln -sf
RM = rm -f
RMR = rm -rf

BINARIES = das das2 dxrcheck dxrconvert s6filter s6text
ALIAS = pdp10-dec-none-as
PROGRAMS = ${BINARIES} ${ALIAS}
.PHONY: all manual-check native native-driver native-phases install uninstall clean help FORCE

DAIMOS_REPO ?= ../DAIMOS
NATIVE_BUILD_DIR ?= build-native-v1
PDP10_KCC ?= ${PDP10_PREFIX}/bin/kcc
PDP10_DLINK ?= ${PDP10_PREFIX}/bin/dlink
NATIVE_DAS ?= ./das
NATIVE_KCCFLAGS ?= -Pgnu99 -O -x=pdp6 -m=gas

# All resident DAS images use KCC.  The native profile omits the host-only
# peephole optimizer and phase 1 avoids phase-2-only instruction decoding so
# both large phase images stay below the 034000-word resident budget.
SIXMD_CHECK ?= ${PDP10_PREFIX}/bin/sixmd-check
MANUAL = DAS.SIXMD
MANUALDIR ?= ${PDP10_PREFIX}/share/daimos/manual
NATIVE_CPPFLAGS = \
	-I${DAIMOS_REPO}/system/kernel/boot \
	-I${DAIMOS_REPO}/system/kernel/core \
	-I${DAIMOS_REPO}/system/kernel/drivers \
	-I${DAIMOS_REPO}/system/kernel/fs \
	-I${DAIMOS_REPO}/system/kernel/mm \
	-I${DAIMOS_REPO}/system/kernel/modules \
	-I${DAIMOS_REPO}/system/kernel/proc \
	-I${DAIMOS_REPO}/system/kernel/storage \
	-I${DAIMOS_REPO}/userland/libc \
	-I${PDP10_PREFIX}/include
NATIVE_COMMON_OBJS = \
	${NATIVE_BUILD_DIR}/crt0-v1.dobj \
	${NATIVE_BUILD_DIR}/syscall-v1.dobj \
	${NATIVE_BUILD_DIR}/syscall-helpers-v1.dobj

all: manual-check ${PROGRAMS}

das: das.c das_native_runtime.h
	${CC} ${CFLAGS} ${HOST_CPPFLAGS} -o $@ das.c

das2: das.c das_native_runtime.h
	${CC} ${CFLAGS} ${HOST_CPPFLAGS} -DDAS_PHASE2_PROGRAM -o $@ das.c

dxrcheck: dxrcheck.c
	${CC} ${CFLAGS} -o $@ dxrcheck.c

dxrconvert: dxrconvert.c
	${CC} ${CFLAGS} -o $@ dxrconvert.c

s6filter: s6filter.c
	${CC} ${CFLAGS} -o $@ s6filter.c

s6text: s6text.c
	${CC} ${CFLAGS} -o $@ s6text.c

${ALIAS}: das
	${LN} das ${ALIAS}

manual-check: ${MANUAL}
	@test -x "${SIXMD_CHECK}" || { echo "missing SIXMD validator: ${SIXMD_CHECK}" >&2; exit 1; }
	${SIXMD_CHECK} ${MANUAL} DAS

native: manual-check native-driver native-phases

native-driver: ${NATIVE_BUILD_DIR}/das.dxr

native-phases: ${NATIVE_BUILD_DIR}/das1.dxr ${NATIVE_BUILD_DIR}/das2.dxr

${NATIVE_BUILD_DIR}/das-driver-v1.s: das_native_driver.c ${PDP10_KCC}
	mkdir -p ${NATIVE_BUILD_DIR}
	${PDP10_KCC} ${NATIVE_KCCFLAGS} ${NATIVE_CPPFLAGS} -S $< -o $@

${NATIVE_BUILD_DIR}/das1-v1.s: das_native1.c das.c das_native_runtime.h ${PDP10_KCC}
	mkdir -p ${NATIVE_BUILD_DIR}
	${PDP10_KCC} ${NATIVE_KCCFLAGS} ${NATIVE_CPPFLAGS} -S $< -o $@

${NATIVE_BUILD_DIR}/das2-v1.s: das_native2.c das.c das_native_runtime.h ${PDP10_KCC}
	mkdir -p ${NATIVE_BUILD_DIR}
	${PDP10_KCC} ${NATIVE_KCCFLAGS} ${NATIVE_CPPFLAGS} -S $< -o $@

${NATIVE_BUILD_DIR}/das-driver-v1.dobj: ${NATIVE_BUILD_DIR}/das-driver-v1.s das
	${NATIVE_DAS} -F -C -O $@ $<

${NATIVE_BUILD_DIR}/das1-v1.dobj: ${NATIVE_BUILD_DIR}/das1-v1.s das
	${NATIVE_DAS} -F -C -O $@ $<

${NATIVE_BUILD_DIR}/das2-v1.dobj: ${NATIVE_BUILD_DIR}/das2-v1.s das
	${NATIVE_DAS} -F -C -O $@ $<

${NATIVE_BUILD_DIR}/crt0-v1.dobj: ${DAIMOS_REPO}/userland/libc/crt0.s das
	mkdir -p ${NATIVE_BUILD_DIR}
	${NATIVE_DAS} -F -C -O $@ $<

${NATIVE_BUILD_DIR}/syscall-v1.dobj: ${DAIMOS_REPO}/userland/libc/syscall.s das
	mkdir -p ${NATIVE_BUILD_DIR}
	${NATIVE_DAS} -F -C -O $@ $<

${NATIVE_BUILD_DIR}/syscall-helpers-v1.dobj: ${DAIMOS_REPO}/userland/libc/syscall_helpers.s das
	mkdir -p ${NATIVE_BUILD_DIR}
	${NATIVE_DAS} -F -C -O $@ $<

${NATIVE_BUILD_DIR}/das.dxr: ${NATIVE_BUILD_DIR}/das-driver-v1.dobj ${NATIVE_COMMON_OBJS}
	${PDP10_DLINK} --daimos-uuo-relax -b 020 -o $@ \
		-M ${NATIVE_BUILD_DIR}/das-v1.map ${NATIVE_COMMON_OBJS} \
		${NATIVE_BUILD_DIR}/das-driver-v1.dobj

${NATIVE_BUILD_DIR}/das1.dxr: ${NATIVE_BUILD_DIR}/das1-v1.dobj ${NATIVE_COMMON_OBJS}
	${PDP10_DLINK} --daimos-uuo-relax -b 020 -o $@ \
		-M ${NATIVE_BUILD_DIR}/das1-v1.map ${NATIVE_COMMON_OBJS} \
		${NATIVE_BUILD_DIR}/das1-v1.dobj

${NATIVE_BUILD_DIR}/das2.dxr: ${NATIVE_BUILD_DIR}/das2-v1.dobj ${NATIVE_COMMON_OBJS}
	${PDP10_DLINK} --daimos-uuo-relax -b 020 -o $@ \
		-M ${NATIVE_BUILD_DIR}/das2-v1.map ${NATIVE_COMMON_OBJS} \
		${NATIVE_BUILD_DIR}/das2-v1.dobj

install: all
	mkdir -p "${DESTDIR}${BINDIR}"
	for f in ${BINARIES}; do \
		cp "$$f" "${DESTDIR}${BINDIR}/$$f" || exit 1; \
		chmod 755 "${DESTDIR}${BINDIR}/$$f" || exit 1; \
	done
	cd "${DESTDIR}${BINDIR}" && ${LN} das ${ALIAS}
	mkdir -p "${DESTDIR}${MANUALDIR}"
	cp "${MANUAL}" "${DESTDIR}${MANUALDIR}/DAS.SIXMD"
	chmod 444 "${DESTDIR}${MANUALDIR}/DAS.SIXMD"

uninstall:
	for f in ${PROGRAMS}; do \
		${RM} "${DESTDIR}${BINDIR}/$$f"; \
	done

clean:
	${RM} ${PROGRAMS} *.o \
		das-native.s das-native.dxr.words \
		das1-native.s das1-native.dxr.words \
		das2-native.s das2-native.dxr.words
	${RMR} ${NATIVE_BUILD_DIR}

help:
	@echo "DAS"
	@echo ""
	@echo "  make            build host tools"
	@echo "  make install    install host tools"
	@echo "  make native     build native DAS, DAS1 and DAS2 DXR images"
	@echo "  make manual-check validate the authoritative SIXMD manual"
	@echo "  make native-driver build the public native DAS phase driver"
	@echo "  make native-phases build private native DAS1/DAS2 images"
	@echo "  make uninstall  remove installed host tools"
	@echo "  make clean      remove generated files"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX          default /usr/local"
	@echo "  PDP10_PREFIX    default PREFIX"
	@echo "  BINDIR          default PDP10_PREFIX/bin"
	@echo "  DESTDIR         optional staged-install root"
	@echo "  CC              C99 compiler command"
	@echo "  CFLAGS          compiler flags"
	@echo "  DAIMOS_REPO     current DAIMOS source tree, default ../DAIMOS"
	@echo "  NATIVE_BUILD_DIR versioned native output directory"
	@echo "  PDP10_KCC       current DAIMOS KCC used for all resident DAS images"
	@echo "  PDP10_DLINK     DOBJ linker"
	@echo "  NATIVE_KCCFLAGS KCC flags for all resident DAS images"

FORCE:
