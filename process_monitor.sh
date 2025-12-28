#!/bin/bash

LIST=false
PROC=""
while [[ "$#" -gt 0 ]]; do
	case "$1" in 
	--list)
		LIST=true
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
	if [[ ! -z "$PROC" ]]; then
		echo "--list doesn't accept a process name" >&2
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

PROCESSLIST=$(pgrep -xl "$PROC")
STATUS=$?
if [[ "$STATUS" -ne 0 ]]; then
	echo No process was found
	exit 1
fi
echo List of processes labeled "$PROC"\: 
echo "$PROCESSLIST"
