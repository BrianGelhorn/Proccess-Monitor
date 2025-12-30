\
#!/bin/bash

LIST=false
METRICS=false
OWNER=false
PROCESSTATUS=false
PROC=""
while [[ "$#" -gt 0 ]]; do
	case "$1" in 
	--list)
		LIST=true
		shift
		;;
	--metrics)
		METRICS=true
		shift
		;;
	--owner)
		OWNER=true
		shift
		;;
	--status)
		PROCESSTATUS=true
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
PROCESSLIST=$(ps --no-headers -o user,pid,comm,%cpu,%mem,stat -C "$PROC")
STATUS=$?
if [[ "$STATUS" -ne 0 ]]; then
	echo No process was found
	exit 1
fi 
echo List of processes labeled "$PROC"\:

if [[ "$METRICS" == true ]]; then
	echo "CPU RAM NAME"
	echo "$PROCESSLIST" | awk '{print $4, $5, $3}'	
else
	echo "PID  NAME"
	echo "$PROCESSLIST" | awk '{print $2, $3}'
fi	

if [[ "$OWNER" == true ]]; then
	echo "$PROCESSLIST" | awk '{print "Process launched by: " $1}'
fi

if [[ "$PROCESSTATUS" == true ]]; then
	echo -n "The state of the process is: "
 	case $(echo "$PROCESSLIST" | awk '{print $6}') in
	*R*)
		echo "Running"
		;;
	*S*)
		echo "Sleeping"
		;;	
	*T*)
		echo "Stopped"
		;;
	esac
fi


