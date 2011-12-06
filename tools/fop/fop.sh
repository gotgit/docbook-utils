#! /bin/sh
#
# Shell script to run FOP, adapted from the Jakarta-Ant project.

JVM_OPTS="-Xms100m -Xmx200m"
FOP_OPTS=""

if [ -f $HOME/.foprc ] ; then 
  . $HOME/.foprc
fi

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true ;;
esac

if [ -z "$FOP_HOME" ] ; then
  # try to find FOP
  if [ -d /opt/docbook/tools/fop ] ; then 
    FOP_HOME=/opt/docbook/tools/fop
  else
    ## resolve links - $0 may be a link to fop's home
    PRG=$0
    progname=`basename $0`
    
    while [ -h "$PRG" ] ; do
      ls=`ls -ld "$PRG"`
      link=`expr "$ls" : '.*-> \(.*\)$'`
      if expr "$link" : '.*/.*' > /dev/null; then
  	PRG="$link"
      else
  	PRG="`dirname $PRG`/$link"
      fi
    done
    
    FOP_HOME=`dirname "$PRG"`
  fi
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$FOP_HOME" ] &&
    FOP_HOME=`cygpath --unix "$FOP_HOME"`
  [ -n "$JAVA_HOME" ] &&
    JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] &&
    CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

if [ -z "$JAVACMD" ] ; then 
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then 
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD=$JAVA_HOME/jre/sh/java
    else
      JAVACMD=$JAVA_HOME/bin/java
    fi
  elif [ -x /usr/bin/java ]; then
    JAVACMD=/usr/bin/java
  else
    JAVACMD=java
  fi
fi
 
if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly."
  echo "  We cannot execute $JAVACMD"
  exit
fi

COREJARS_PATH=/usr/share/java
COREJARS=$COREJARS_PATH/fop.jar:$COREJARS_PATH/xalan2.jar:$COREJARS_PATH/xercesImpl.jar:$COREJARS_PATH/xmlParserAPIs.jar:$COREJARS_PATH/logkit.jar:$COREJARS_PATH/avalon-framework.jar:$COREJARS_PATH/batik.jar:$COREJARS_PATH/jimi-1.0.jar:$COREJARS_PATH/jai_core.jar:$COREJARS_PATH/jai_codec.jar:$COREJARS_PATH/mlibwrapper_jai.jar:${FOP_HOME}/build/fop.jar:$CLASSPATH

DIRLIBS=${FOP_HOME}/lib/*.jar
for i in ${DIRLIBS}
do
    # if the directory is empty, then it will return the input string
    # this is stupid, so case for it
    if [ "$i" != "${DIRLIBS}" ] ; then
      if [ -z "$COREJARS" ] ; then
        COREJARS=$i
      else
        COREJARS="$i":$COREJARS
      fi
    fi
done

OIFS=$IFS
IFS=':'
LOCALCLASSPATH=
for i in $COREJARS; do
  if [ -f $i ]; then
      if [ -z "$LOCALCLASSPATH" ] ; then
        LOCALCLASSPATH=$i
      else
        LOCALCLASSPATH="$i":$LOCALCLASSPATH
      fi
  fi
done
IFS=$OIFS

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  FOP_HOME=`cygpath --path --windows "$FOP_HOME"`
  JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  LOCALCLASSPATH=`cygpath --path --windows "$LOCALCLASSPATH"`
fi

if [ -s ${FOP_HOME}/conf/userconfig.xml ]; then
  CONFIG_FILE=${FOP_HOME}/conf/userconfig.xml
  if $cygwin; then
    CONFIG_FILE=`cygpath --windows "${FOP_HOME}/conf/userconfig.xml"`
  fi
  FOP_OPTS="-c ${CONFIG_FILE}"
fi

echo ========================================
echo $JAVACMD -classpath "$LOCALCLASSPATH" $JVM_OPTS org.apache.fop.apps.Fop $FOP_OPTS "$@"
echo ========================================

$JAVACMD -classpath "$LOCALCLASSPATH" $JVM_OPTS org.apache.fop.apps.Fop $FOP_OPTS "$@"
