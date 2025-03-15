#!/bin/bash

LOG_FILE="/var/log/nginx/access.log"
LOG_FILE_1="/var/log/nginx/log_1.log"
LOG_FILE_2="/var/log/nginx/log_2.log"
LOG_FILE_3="/var/log/nginx/log4xx.log"
LOG_FILE_4="/var/log/nginx/log5xx.log"

MAX_SIZE=307200  # 300 KB
PID_FILE="/var/run/log_daemon.pid"

restart_if_killed() {
    while true; do
        bash "$0" &
        wait $!
    done
}

cleanup_log_1() {
    local entries_removed=$(wc -l < "$LOG_FILE_1")
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Очищен log_1.log, удалено строк: $entries_removed" >> "$LOG_FILE_2"
    mv "$LOG_FILE_1" "$LOG_FILE_1.old"
    touch "$LOG_FILE_1"
}

trap restart_if_killed SIGTERM SIGKILL SIGINT

echo $$ > "$PID_FILE"

while true; do
    if [[ -f "$LOG_FILE" ]]; then
        tail -n 1000 "$LOG_FILE" >> "$LOG_FILE_1"
        # Filter 5xx status codes (9th column in this log format)
        awk '$9 ~ /^4[0-9][0-9]$/' "$LOG_FILE" >> "$LOG_FILE_3"
        # Filter 4xx status codes (9th column in this log format)
        awk '$9 ~ /^5[0-9][0-9]$/' "$LOG_FILE" >> "$LOG_FILE_4"
    fi

    if [[ -f "$LOG_FILE_1" ]] && [[ $(stat -c%s "$LOG_FILE_1") -gt $MAX_SIZE ]]; then
        cleanup_log_1
    fi

    sleep 5
done
