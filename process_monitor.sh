#!/bin/bash

LIST=false
METRICS=false
PROC=""
while [[ "$#" -gt 0 ]]; do
	case "$1" in 
	--list)
		LIST=true
		shift
		;;
	--usage)
		METRICS=true
		shift
		;;
	--*)
		echo "Uknown Option: $1" >&2
		exit 1
		;;
	*)
		PROC="$1"
		shift
		;;
	esac
done

if [[ "$LIST" == true ]]; then
	if [[ ! -z "$PROC" || ! -z "$USAGE" ]]; then
		echo "--list doesn't accept a process name or other arguments" >&2
		exit 1
	fi
	echo "The list of process running is:"
	ps aux
	exit 0
fi

if [[ -z "$PROC" ]]; then
	echo "No process was specified"
	exit 1
fi

STATUS=$?
if [[ "$STATUS" -ne 0 ]]; then
	echo No process was found
	exit 1
fi 
echo List of processes labeled "$PROC"\:
if [[ "$METRICS" == true ]]; then
	echo "CPU RAM NAME"
	PROCESSLIST=$(top -b -n 1 | grep "$PROC" | cut -d ' ' -f24,27,31)
	
else
	echo "PID   NAME"
	PROCESSLIST=$(pgrep -xl "$PROC")
fi
echo "$PROCESSLIST"	

