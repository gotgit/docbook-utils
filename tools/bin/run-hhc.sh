#!/bin/sh

# run-fop: Attempt to run fop (or fop.sh), fail articulately otherwise.
#
# Usage:    run-fop.sh [FOP_ARGS...]
#
# This script is meant to be invoked by book translation Makefiles.
# Arguments are passed along to `fop'.

MK_VERSION=`make --version|head -1|awk '{print $3;}'`

if [ $# -eq 1 ] && [ "$1" = "--check" ]; then
  if [ "$MK_VERSION" = "3.81" ]; then
    echo "Error: Bugs in make v3.81: can not run wine from Makefile!"
    exit 1
  elif ! which wineconsole >/dev/null; then
    echo "Error: wineconsole not found!"
    exit 1
  else
    exit 0
  fi
fi

cygwin=false;
case "`uname`" in
  CYGWIN*) 
    cygwin=true ;;
  *)
    cygwin=false ;;
esac

if $cygwin ; then
  "/cygdirve/c/Program\ Files/HTML\ Help\ Workshop/hhc.exe" $@
else
  if [ "$MK_VERSION" = "3.81" ]; then
    echo "Error: Bugs in make v3.81: can not run wine from Makefile!"
    exit 1
  else
    wineconsole "C:/Program Files/HTML Help Workshop/hhc.exe" $@
  fi
fi

