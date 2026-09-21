#!/bin/sh
# Double-click in Finder the first time; afterwards use Nurgling.app, which the updater creates.
cd "$(dirname "$0")" && exec /bin/sh ./nurgling.sh "$@"
