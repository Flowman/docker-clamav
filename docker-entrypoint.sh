#!/bin/sh

set -e

# if command starts with an option, prepend clamd
if [ "${1:0:1}" = '-' ]; then
    set -- clamd "$@"
fi

if [ "$1" = 'clamd' ]; then
    #Init
    if [ ! -e /var/lib/clamav/main.cvd ] || [ ! -e /var/lib/clamav/daily.cvd ] || [ ! -e /var/lib/clamav/bytecode.cvd ]; then
      echo 'Downloading latest definitions...'
      rm -f /var/lib/clamav/*.cvd
      wget -q -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd
      wget -q -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd
      wget -q -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd
    fi

    #Updater daemon
    freshclam -d &
fi

exec "$@"