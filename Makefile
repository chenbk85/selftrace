CPPFLAGS += -Os -g
CPPFLAGS += -Wall -Wextra -pedantic
CPPFLAGS += -fdata-sections -ffunction-sections
CPPFLAGS += -fno-align-functions
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,--relax
LDFLAGS += -Wl,-hash-style=sysv -Wl,-hash-size=1
LDFLAGS += -Wl,--build-id=none

STRIP_SECTIONS := \
	.note* \
	.comment*

selftrace.comp: selftrace.stripped xz-stub.sh
	xz -9 --keep --force --x86 --lzma2 $<
	cat xz-stub.sh $<.xz > $@
	chmod +x $@
	ls -la $@

selftrace.stripped: selftrace
	objcopy --only-keep-debug $< $<.debug
	objcopy $(addprefix -R ,$(STRIP_SECTIONS)) --strip-all $< $@
	! type sstrip >/dev/null 2>&1 || sstrip -z $@
	ls -la $@

.PHONY: check
check: selftrace.comp
	for i in segfault throw; do \
		echo "# simulating $$i"; \
		./$< $$i 2>&1 | ./addr2line.sh selftrace; \
		echo; \
	done

.PHONY: clean
clean:
	rm -f selftrace *.debug *.stripped *.comp *.xz
