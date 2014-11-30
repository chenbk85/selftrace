CPPFLAGS += -O0 -g
CPPFLAGS += -Wall -Wextra -pedantic
#CPPFLAGS += -rdynamic

.PHONY: all
all: selftrace

.PHONY: check
check: selftrace
	for i in segfault throw; do \
		echo "simulating $$i"; \
		./selftrace $$i 2>&1 | sed -nre 's@^./selftrace.*\[([0-9a-fx]*)\]$$@\1@;T;p' | addr2line -e ./selftrace; \
	done

.PHONY: clean
clean:
	rm selftrace
