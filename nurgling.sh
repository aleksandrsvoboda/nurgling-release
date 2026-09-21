#!/bin/sh
# Starts Nurgling on Linux and macOS: applies staged self-updates, then runs the
# updater with Nurgling's own Java (runtime/). Everything is one { } block, so the
# shell has read the whole script before the updater (which may replace it) starts.
{
  DIR=$(cd "$(dirname "$0")" && pwd) || exit 1
  cd "$DIR" || exit 1
  [ -f nurgling-updater.jar.next ] && mv -f nurgling-updater.jar.next nurgling-updater.jar
  if [ -x runtime.next/bin/java ]; then
    rm -rf runtime.old
    [ -d runtime ] && mv runtime runtime.old
    mv runtime.next runtime && rm -rf runtime.old
  fi
  if [ -x runtime/bin/java ]; then
    J="$DIR/runtime/bin/java"
  elif [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
    J="$JAVA_HOME/bin/java"
  elif command -v java >/dev/null 2>&1; then
    J=java
  else
    URL=https://github.com/aleksandrsvoboda/nurgling-release/releases/latest
    echo "Nurgling could not find Java. Download the Nurgling package for your system, which includes it:"
    echo "  $URL"
    (xdg-open "$URL" || open "$URL") >/dev/null 2>&1
    exit 1
  fi
  SCALE=
  if [ "$(uname)" = Linux ] && [ -n "$GDK_SCALE" ]; then
    SCALE="-Dsun.java2d.uiScale=$GDK_SCALE"
  fi
  if [ ! -f nurgling-updater.jar ]; then
    exec "$J" -jar hafen.jar
  fi
  "$J" $SCALE -jar nurgling-updater.jar "$@"
  exit $?
}
