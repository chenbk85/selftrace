CPPFLAGS += -O0 -g
CPPFLAGS += -Wall -Wextra -pedantic
#CPPFLAGS += -rdynamic

selftrace.stripped: selftrace
	objcopy --only-keep-debug $< $<.debug
	objcopy --strip-debug $< $@
	objcopy --add-gnu-debuglink=$<.debug $@

.PHONY: check
check: selftrace.stripped
	for i in segfault throw; do \
		echo "# simulating $$i"; \
		./selftrace.stripped $$i 2>&1 | sed -nre 's@^./selftrace.*\[([0-9a-fx]*)\]$$@\1@;T;p' \
			| addr2line --demangle --functions --inlines --pretty-print --exe=./selftrace; \
		echo; \
	done

.PHONY: clean
clean:
	rm -f selftrace *.debug *.stripped
