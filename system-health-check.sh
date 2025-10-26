#!/bin/bash

LOGFILE="/var/log/system_health_$(date +%F).log"

echo "System Health Check - $(date)" >> $LOGFILE
echo "--------------------------------------------" >> $LOGFILE

# CPU usage
mpstat | awk '/all/ {print "CPU Used: " 100 - $12 "%"}' >> $LOGFILE

# Memory usage
free -h >> $LOGFILE

# Disk usage
df -h | grep -vE '^Filesystem|tmpfs|cdrom' >> $LOGFILE

# Service status
SERVICES=("nginx" "docker" "sshd")
for service in "${SERVICES[@]}"; do
    if systemctl is-active --quiet $service; then
        echo "$service is running ✅" >> $LOGFILE
    else
        echo "$service is NOT running ❌" >> $LOGFILE
    fi
done

echo "Health Check Completed ✅" >> $LOGFILE
