#include "nmthread.h"

nm::thread_console::thread_console(int n):n_cores(n)
{
	nm::console_lock = true;
	for (int i(0); i < n_cores; i++)
		reports.push_back("");
}

void nm::thread_console::report(std::string rep, int ID)
{
	_mu.lock();

	if(ID >= n_cores) return;
	reports[ID] = rep;

	for (int i(0); i < n_cores; i++) thread_print("\e[A\r\e[K\e[A");

	for (int i(0); i < n_cores; i++) 
	{
		std::stringstream text;
		text << i << " : " << reports[i];
		thread_print(text.str());
	}

	_mu.unlock();
}

void nm::thread_file::lock()
{_mu.lock();}

void nm::thread_file::unlock()
{_mu.unlock();}

nm::thread_file::thread_file(const char* filename, std::ios_base::openmode mode):
	std::fstream(filename,mode),_mu(){}