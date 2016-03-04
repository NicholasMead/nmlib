


if [ "x${BASH_ARGV[0]}" = "x" ]; then
    if [ -f bin/this-nmlib.sh ]; then
        NMLIBSYS="$PWD"; export NMLIBSYS
    elif [ -f ./this-nmlib.sh ]; then
        NMLIBSYS=$(cd ..; pwd); export NMLIBSYS
    else
        echo ERROR: must "cd where/nmlib/ is" before calling ". bin/this-nmlib.sh" for this version of bash!
        NMLIBSYS=; export $NMLIBSYS
        return 1
    fi
else
    # get param to "."
    thisnmlib=$(dirname ${BASH_ARGV[0]})
    NMLIBSYS=$(cd ${thisnmlib}/..;pwd); export NMLIBSYS
fi

if [ -z "${PATH}" ]; then
   PATH=$NMLIBSYS/bin; export PATH
else
   PATH=$NMLIBSYS/bin:$PATH; export PATH
fi

if [ -z "${LD_LIBRARY_PATH}" ]; then
   LD_LIBRARY_PATH=$NMLIBSYS/lib; export LD_LIBRARY_PATH       # Linux
else
   LD_LIBRARY_PATH=$NMLIBSYS/lib:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH
fi

if [ -z "${DYLD_LIBRARY_PATH}" ]; then
   DYLD_LIBRARY_PATH=$NMLIBSYS/lib; export DYLD_LIBRARY_PATH   # Mac OS X
else
   DYLD_LIBRARY_PATH=$NMLIBSYS/lib:$DYLD_LIBRARY_PATH; export DYLD_LIBRARY_PATH
fi
