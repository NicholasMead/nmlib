#ifndef __nmthread_h__
#define __nmthread_h__

#include <thread>
#include <mutex>
#include <iostream>
#include <sstream>
#include <vector>
#include <fstream>

namespace nm
{
	std::mutex nmthread_mu;

	bool console_lock(false);

	template<class T>
	void thread_print(T message,int ID = 0);

	class thread_console
	{
	private:
		int n_cores;
		std::vector<std::string> reports;
		std::mutex _mu;

	public:
		thread_console(int n);
		void report(std::string rep, int ID);
	};

	class thread_file : public std::fstream
	{
	private:
		std::mutex _mu;
	public:
		thread_file(const char* filename, std::ios_base::openmode mode = std::ios_base::out);
		void lock();
		void unlock();
	};

}

template<class T>
void nm::thread_print(T message, int ID){
	std::lock_guard<std::mutex> lock(nmthread_mu);
	std::cout << ID << ": " << message << std::endl;
}

#endif