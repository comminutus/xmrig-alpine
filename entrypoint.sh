#!/bin/ash

set -e

args="$@"

if [ -n "$XMRIG_ADDITIONAL_ARGS" ]; then
    args="$args $XMRIG_ADDITIONAL_ARGS"
fi

if [ -n "$XMRIG_CONFIG" ]; then
    args="$args --config=$XMRIG_CONFIG"
fi

if [ -n "$XMRIG_CPU_AFFINITY" ]; then
    args="$args --cpu-affinity=$XMRIG_CPU_AFFINITY"
fi

if [ -n "$XMRIG_CPU_PRIORITY" ]; then
    args="$args --cpu-priority=$XMRIG_CPU_PRIORITY"
fi

if [ -n "$XMRIG_URL" ]; then
    args="$args --url=$URL"
fi

if [ -n "$XMRIG_THREADS" ]; then
    args="$args --threads=$XMRIG_THREADS"
fi


old_ifs=$IFS
set -- $args
IFS=$old_ifs

echo "xmrig" "$@"
exec "xmrig" "$@"
