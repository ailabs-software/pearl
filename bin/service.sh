#!/bin/bash

# pearl service start/stop script

E_BADARGS=65
if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` [start | stop]"
  exit $E_BADARGS
fi

func=$1

# Start service
if [ $func = "start" ]; then

  if [ -f /tmp/pearl_service.pid ]
  then
  echo "Cannot start: Tandem is already running!"
  exit 1
  fi

  echo "Starting pearl service..."
  /opt/pearl/bin/runpearl.sh >> /var/pearl/log/.log 2>&1 & disown
  echo $! > /tmp/pearl_service.pid

fi

# Stop service
if [ $func = "stop" ]; then

if [ -f /tmp/pearl_service.pid ] # But only if it's running.
then
  # Make sure the process is *really* still running
  SERVICEPID=`cat /tmp/pearl_service.pid`
  if [ -a /proc/$SERVICEPID ]
  then
    echo "Stopping the pearl service..."
    kill -- -$(ps -o pgid= $SERVICEPID | grep -o [0-9]*)
  else echo "ERROR: The pearl service is no longer running, but we didn't shut it down!"
  fi
  rm /tmp/pearl_service.pid
else echo "The pearl service is not running!"
fi

fi

