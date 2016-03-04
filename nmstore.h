#ifndef __nmstore_h__
#define __nmstore_h__

#include <mutex>
#include <vector>
#include <string>

namespace nm
{
	template <class T>
	class FIFO
	{
	protected:
		std::mutex _mu;
		std::vector<T> _FIFO_v;
		size_t _index;
	public:
		//constructors
		FIFO():_index(0){}
		FIFO(std::vector<T> v):_index(0),_FIFO_v(v){}
		FIFO(T* v):FIFO(std::vector<T>(v, v + sizeof(v) / sizeof(T))){}

		/* ---- thread safe methods ---- */
		
		T 		pop();
		void 	store(T item);

		/* ---- none thread safe methods ---- */

		//for use with none thread safe functions
		void	lock();
		void	unlock();

		//functions that may be used in combination 
		bool 	is_empty();
		T 		peek();
		void	set_index(size_t i);
		void 	reset();
		void	flush();
		void	next();	
	};
}

// FIFO definitions
	template<class T>
	T nm::FIFO<T>::pop(){
		std::lock_guard<std::mutex> lock(_mu);
		if (is_empty()) throw std::string("FIFO empty");
		return _FIFO_v[_index++];
	}

	template<class T>
	void nm::FIFO<T>::store(T item){
		std::lock_guard<std::mutex> lock(_mu);
		_FIFO_v.push_back(item);
	}

	template<class T>
	inline bool nm::FIFO<T>::is_empty(){
		return _index >= _FIFO_v.size();
	}

	template<class T>
	inline T nm::FIFO<T>::peek(){
		return _FIFO_v[_index];
	}

	template<class T>
	inline void nm::FIFO<T>::lock(){
		_mu.lock();
	}

	template<class T>
	inline void nm::FIFO<T>::unlock(){
		_mu.unlock();
	}

	template<class T>
	inline void	nm::FIFO<T>::set_index(size_t i){
		_index = i;
	}

	template<class T>
	inline void	nm::FIFO<T>::reset(){
		_index = 1;
	}

	template<class T>
	inline void	nm::FIFO<T>::flush(){
		_FIFO_v.erase(_FIFO_v.begin(),_FIFO_v.begin()+_index);
	}

	template<class T>
	inline void	nm::FIFO<T>::next(){
		_index++;
	}
	

#endif