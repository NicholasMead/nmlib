OS?=Linux
PREFIX?=.
CXX?=g++
CFLAGS= -std=c++11
SRC=${wildcard *.cpp}
COMP=UNDEFINED

.PHONY: all install

.SUFFIXES: .so .dylib .cpp
 
ifeq ($(OS),OSX)
COMP=OSX
LIBS=$(SRC:%.cpp=%.dylib)
MLIBS=$(LIBS:%.dylib=l%)
else
COMP=Linux
LIBS=$(SRC:%.cpp=lib%.so)
NMLIBS=$(LIBS:lib%.so=-l%)
endif

all: $(LIBS)

#OSX dynamic library compilation
%.dylib : %.cpp
	$(CXX) -dynamiclib $(CFLAGS) $< -o $@

%.o : %.cpp
	$(CXX) -fPIC -c $(CFLAGS) $< -o $@
	
lib%.so : %.o
	$(CXX) -shared $< -o $@

install:
	@echo Creating file structure in $(PREFIX)/nmlibs
	@test -d $(PREFIX)/nmlib || mkdir $(PREFIX)/nmlib/
	@test -d $(PREFIX)/nmlib/libs || mkdir $(PREFIX)/nmlib/libs
	@test -d $(PREFIX)/nmlib/include || mkdir $(PREFIX)/nmlib/include
	@test -d $(PREFIX)/nmlib/bin || mkdir $(PREFIX)/nmlib/bin
	@test -d $(PREFIX)/nmlib/source || mkdir $(PREFIX)/nmlib/source
ifeq ($(OS),OSX)
	@mv -v *.dylib $(PREFIX)/nmlib/libs/
else
	@mv -v *.so $(PREFIX)/nmlib/libs/
endif
	@cp -v *.cpp $(PREFIX)/nmlib/source
	@cp -v *.h $(PREFIX)/nmlib/include

	

clean:
	rm -fv *.dylib *.o *.so
	rm -rfv nmlib
