OS?=Linux
PREFIX?=.
CXX?=g++
CFLAGS= -std=c++14
SRC=${wildcard *.cpp}
COMP=UNDEFINED

.PHONY: all install

.SUFFIXES: .so .dylib .cpp
 
ifeq ($(OS),OSX)
COMP=OSX
LIBS=$(SRC:%.cpp=%.dylib)
NMLIBS=$(LIBS:%.dylib=l%)
else
COMP=Linux
LIBS=$(SRC:%.cpp=lib%.so)
NMLIBS=$(LIBS:lib%.so=-l%)
endif

all: $(LIBS)

#OSX dynamic library compilation
%.dylib : %.cpp
	$(CXX) -dynamiclib $(CFLAGS) $< -o $@

#Linus shared library comilation
lib%.so : %.o
	$(CXX) -shared $< -o $@
%.o : %.cpp
	$(CXX) -fPIC -c $(CFLAGS) $< -o $@	

install: all
	@echo Creating file structure in $(PREFIX)/nmlibs
	@test -d $(PREFIX)/nmlib || mkdir $(PREFIX)/nmlib/
	@test -d $(PREFIX)/nmlib/lib || mkdir $(PREFIX)/nmlib/lib
	@test -d $(PREFIX)/nmlib/include || mkdir $(PREFIX)/nmlib/include
	@test -d $(PREFIX)/nmlib/bin || mkdir $(PREFIX)/nmlib/bin
	@test -d $(PREFIX)/nmlib/source || mkdir $(PREFIX)/nmlib/source
	@test -d $(PREFIX)/nmlib/etc || mkdir $(PREFIX)/nmlib/etc
ifeq ($(OS),OSX)
	@mv -vf *.dylib $(PREFIX)/nmlib/lib/
else
	@mv -vf *.so $(PREFIX)/nmlib/lib/
endif
	@cp -vf *.cpp $(PREFIX)/nmlib/source
	@cp -vf *.h $(PREFIX)/nmlib/include
	@cp -vf nmlib-config this-nmlib.sh $(PREFIX)/nmlib/bin
	@chmod a+x -v $(PREFIX)/nmlib/bin/*
	@echo $(NMLIBS)>libflags.etc
	@chmod a+r -v libflags.etc
	@cp -v libflags.etc ${PREFIX}/nmlib/etc
	
clean:
	rm -fv *.dylib *.o *.so *.etc
	rm -rfv nmlib
