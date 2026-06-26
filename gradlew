#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a symlink
app_path=$0

# Need this for daisy-chained symlinks.
while
    APP_HOME=${app_path%"${app_path##*/}"}
    [ -h "$app_path" ]
do
    app_path=$(expr "$app_path" : '.*'\(/\).*' \| "$app_path" : '.*\(\)')
done
APP_HOME=$(cd "${APP_HOME:-.}" && pwd -P) || exit

# Add default JVM options here.
DEFAULT_JVM_OPTS='" -Xmx64m" "-Xms64m"'

# Use the maximum available, or set MAX_FD != unlimited.
MAX_FD=maximum

warn () {
    echo "$*" >&2
}

die () {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
darwin=false
msys=false
cygwin=false

case "$(uname)" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MSYS* | MINGW* )
    msys=true
    ;;
esac

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD=$JAVA_HOME/jre/sh/java
    else
        JAVACMD=$JAVA_HOME/bin/java
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD=java
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

# Increase the maximum file descriptors if we can.
if ! "$cygwin" && ! "$darwin" && ! "$msys" ; then
    case $( ulimit -S -n ) in #(
      'unlimited'|2[0-9][0-9][0-9][0-9][0-9][0-9]|1[0-9][0-9][0-9][0-9][0-9][0-9][0-9]|[6-9][0-9][0-9][0-9][0-9][0-9][0-9]|[1-5][0-9][0-9][0-9][0-9][0-9][0-9][0-9]) ;;
      *)
        if [ "$(( ulimit -n ))" -lt 4096 ] ; then
            warn "Could not set maximum file descriptors to 4096 (current limit: $( ulimit -n ))."
        fi
        ;;
    esac
fi

# Collect all arguments for the java command, stacking in reverse order:
#   * args from the command line
#   * the main class name
#   * -classpath
#   * -D options
#   * -- to indicate an end of options

appArgs=""

case $1 in
  -classpath | -cp  ) classpath_setting( "$2"
       shift shift
       ;;
  -- ) shift
       break
       ;;
  -*) false
       ;;
  *) break
     ;;
esac

# expand arguments
for arg in "$@" ; do
    if [ "$previous_was_classpath" = true ] ; then
        classpath_setting+=("$arg")
        previous_was_classpath=false
    elif [ "$arg" = '-classpath' ] || [ "$arg" = '-cp' ] ; then
        previous_was_classpath=true
    else
        appArgs+=("$arg")
    fi
done


# Escape application args
save () {
    for i do printf %s\\n "$i" | sed "s/'/'\"'\"'/g;1s/^/'/;\$s/\$/'/" ; done
    echo " "
}
appArgs=$( save "$@" )

# Collect all arguments for the java command:
#   * DEFAULT_JVM_OPTS - the user-defined defaults for the JVM
#   * JAVA_OPTS - parameters passed by the user, if any
#   * GRADLE_OPTS - anything passed with --gradle-options
#   * PROJECT_GRADLE_PROPERTIES - project-specific properties
#   * GRADLE_INIT_DAM - Gradle initialization DAM
#   * APP_HOME - computed as above
#   * CLASSPATH - populated need to pass it to StartGradle.main()

set -- \
        "-Dorg.gradle.appname=$APP_BASE_NAME" \
        -classpath "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" \
        org.gradle.wrapper.GradleWrapperMain \
        "$appArgs"

exec "$JAVACMD" "$@"
