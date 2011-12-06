#!/bin/sh

# run-fop: Attempt to run fop (or fop.sh), fail articulately otherwise.
#
# Usage:    run-fop.sh [FOP_ARGS...]
#
# This script is meant to be invoked by book translation Makefiles.
# Arguments are passed along to `fop'.

# If the user has a .foprc, source it.
if [ -f ${HOME}/.foprc ]; then
  . ${HOME}/.foprc
fi

# Unfortunately, 'which' seems to behave slightly differently on every
# platform, making it unreliable for shell scripts.  Just do it inline
# instead.  Also, note that we search for `fop' or `fop.sh', since
# different systems seem to package it different ways.
SAVED_IFS=${IFS}
IFS=:
PATH=/opt/docbook/tools/fop:`dirname \"$0\"`/../fop:${PATH}:${FOP_HOME}
for dir in ${PATH}; do
   if [ -x ${dir}/fop -a "${FOP_CMD}X" = X ]; then
     FOP_CMD=${dir}/fop
   elif [ -x ${dir}/fop.sh -a "${FOP_CMD}X" = X ]; then
     FOP_CMD=${dir}/fop.sh
   fi
done
IFS=${SAVED_IFS}

if [ "${FOP_CMD}X" = X ]; then
  echo "Error: fop not installed!"
  exit 1
fi

echo "(Using '${FOP_CMD}' for FOP)"

# FOP is noisy on stdout, and -q doesn't seem to help, so stuff that
# garbage into /dev/null.
${FOP_CMD} $@ | grep -v "\[ERROR\]"

