#!/bin/bash
set -e
if [[ -e /scripts/firstrun ]]; then
        echo "Initializing cache..."
        /usr/sbin/squid  -z
        rm /scripts/firstrun
fi
