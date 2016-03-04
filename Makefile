OS?=Linux
DIR?=.

all: nmthread nmstore

nmthread: nmthread.cpp nmthread.h
ifeq ($(OS),OSX)
	g++ -dynamiclib nmthread.cpp -o libnmthread.dylib
else
	g++ -fpic -o nmthread.o nmthread.cpp
	g++ -shared -o libnmthread.so nmthread.o
endif

nmstore: nmstore.cpp nmstore.h
ifeq ($(OS),OSX)
	g++ -dynamiclib nmstore.cpp -o libnmstore.dylib
else
	g++ -fpic -o nmstore.o nmstore.cpp
	g++ -shared -o libnmstore.so nmstore.o
endif

install:
	mkdir $(DIR)/nmlib
	mkdir $(DIR)/nmlib/libs
	mkdir $(DIR)/nmlib/include
	mkdir $(DIR)/nmlib/bin
ifeq ($(OS),OSX)
	mv *.dylib $(DIR)/nmlib/libs/
else
	mv *.so $(DIR)/nmlib/libs/
endif
	

clean:
	rm -f *.dylib *.o *.so
	rm -rf nmlib
