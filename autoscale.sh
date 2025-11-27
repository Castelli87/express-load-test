#!/bin/bash

export PATH=/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin


SERVICE="loadtest_api"
MIN=1
MAX=5   # you can change this later

# get current replicas
CURRENT=$(docker service ls --format '{{.Replicas}}' | grep -o '^[0-9]*')

# get current CPU usage based on docker instances
CPU=$(docker stats --no-stream --format "{{.CPUPerc}}" | head -n1 | sed 's/%//')

echo "CPU usage: $CPU"
echo "Current replicas: $CURRENT"

# scale UP
if (( $(echo "$CPU > 35" | bc -l) )); then
    if [ "$CURRENT" -lt "$MAX" ]; then
        NEXT=$((CURRENT + 1))
        echo "High load detected. Scaling to $NEXT replicas..."
        docker service scale $SERVICE=$NEXT
        exit 0
    fi
fi

# scale DOWN
if (( $(echo "$CPU < 20" | bc -l) )); then
    if [ "$CURRENT" -gt "$MIN" ]; then
        NEXT=$((CURRENT - 1))
        echo "Low load detected. Scaling to $NEXT replicas..."

# below work as a restarted if there is not service running ( so at max the service could be down one min )
        docker service scale $SERVICE=$NEXT
        exit 0
    fi
fi

echo "No scaling action needed."
