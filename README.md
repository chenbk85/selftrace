# Print backtrace on segfault or uncaught exception in C++

Here is the output of make check which employs a simple addr2line filter on the
output of C++ program:

	# simulating segfault
	0x00000000004014b2: printBacktraceAndFail(int) at selftrace.cpp:22
	0x00000000004013b6: dosegfault() at selftrace.cpp:9
	0x0000000000401475: bar(void (*)()) at selftrace.cpp:14
	0x000000000040148f: foo(void (*)()) at selftrace.cpp:15
	0x000000000040165f: main at selftrace.cpp:37
	0x00000000004012b9: _start at ??:?

	# simulating throw
	0x00000000004014b2: printBacktraceAndFail(int) at selftrace.cpp:22
	0x0000000000401430: dothrow() at selftrace.cpp:10 (discriminator 4)
	0x0000000000401475: bar(void (*)()) at selftrace.cpp:14
	0x000000000040148f: foo(void (*)()) at selftrace.cpp:15
	0x000000000040165f: main at selftrace.cpp:37
	0x00000000004012b9: _start at ??:?

Faulty program outputs only addresses:

	$ ./selftrace.comp segfault
	/tmp/I[0x4014b2]
	/lib/x86_64-linux-gnu/libc.so.6(+0x35180)[0x7f17a7326180]
	/tmp/I[0x4013b6]
	/tmp/I[0x401475]
	/tmp/I[0x40148f]
	/tmp/I[0x40165f]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f17a7312b45]
	/tmp/I[0x4012b9]

	$ ./selftrace.comp throw
	terminate called after throwing an instance of 'std::runtime_error'
	  what():  my exception
	/tmp/I[0x4014b2]
	/lib/x86_64-linux-gnu/libc.so.6(+0x35180)[0x7f56dee98180]
	/lib/x86_64-linux-gnu/libc.so.6(gsignal+0x37)[0x7f56dee98107]
	/lib/x86_64-linux-gnu/libc.so.6(abort+0x148)[0x7f56dee994e8]
	/usr/lib/x86_64-linux-gnu/libstdc++.so.6(_ZN9__gnu_cxx27__verbose_terminate_handlerEv+0x15d)[0x7f56df783b3d]
	/usr/lib/x86_64-linux-gnu/libstdc++.so.6(+0x5ebb6)[0x7f56df781bb6]
	/usr/lib/x86_64-linux-gnu/libstdc++.so.6(+0x5ec01)[0x7f56df781c01]
	/usr/lib/x86_64-linux-gnu/libstdc++.so.6(+0x5ee19)[0x7f56df781e19]
	/tmp/I[0x401430]
	/tmp/I[0x401475]
	/tmp/I[0x40148f]
	/tmp/I[0x40165f]
	/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f56dee84b45]
	/tmp/I[0x4012b9]
