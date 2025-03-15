#!/bin/bash

PID_FILE="/var/run/get_cpu_load.pid"

restart_if_killed() {
    while true; do
        bash "$0" &
        wait $!
    done
}

trap restart_if_killed SIGTERM SIGKILL SIGINT

echo $$ > "$PID_FILE"


while true; do
    grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}' > /tmp/cpu_load
    sleep 1
done