#include <iostream>
#include <map>
#include <stdexcept>
#include <cstdlib>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h> // STDERR_FILENO

void
dosegfault()
{
	int *p = 0;
	*p = 0;
}

void
dothrow()
{
	throw std::runtime_error("my exception");
}

typedef void (*Action)();

void
bar(Action action)
{
	action();
}

void
foo(Action action)
{
	bar(action);
}

void
printBacktraceAndFail(int)
{
	const int count = 64;
	static void *buffer[count];
	backtrace_symbols_fd(buffer, backtrace(buffer, count), STDERR_FILENO);
	exit(1);
}

int
main(int, char* argv[])
{
	signal(SIGSEGV, printBacktraceAndFail);
	signal(SIGABRT, printBacktraceAndFail);
	typedef std::map<std::string, Action> Actions;
	Actions actions;
	actions["segfault"] = dosegfault;
	actions["throw"] = dothrow;
	if (const char* actionName = argv[1]) {
		if (const Action action = actions[actionName]) {
			foo(action);
		} else {
			std::cerr << "no such action \"" << actionName << "\"" << std::endl;
		}
	} else {
		std::cerr << "Usage: selftrace <action>" << std::endl;
		std::cerr << "Available actions:" << std::endl;
		for (Actions::const_iterator i = actions.begin(); i != actions.end(); ++i) {
			std::cerr << "\t" << i->first << std::endl;
		}
	}
	return EXIT_FAILURE;
}
