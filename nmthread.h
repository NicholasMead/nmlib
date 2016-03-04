#ifndef __nmthread_h__
#define __nmthread_h__

#include <thread>
#include <mutex>
#include <iostream>

namespace nm
{
	std::mutex nmthread_mu;

	template<class T>
	void thread_report(T message,int ID = 0);

}

template<class T>
void nm::thread_report(T message, int ID){
	std::lock_guard<std::mutex> lock(nmthread_mu);
	std::cout << ID << ": " << message << std::endl;
}

#endif