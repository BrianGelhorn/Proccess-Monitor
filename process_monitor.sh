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
HEADER="PID NAME"
FIELDS="2 3"
if [[ "$STATUS" -ne 0 ]]; then
	echo No process was found
	exit 1
fi 
echo List of processes labeled "$PROC"\:

if [[ "$METRICS" == true ]]; then
	HEADER+=" CPU RAM"	
	FIELDS+=" 4 5"
fi	

if [[ "$OWNER" == true ]]; then
	HEADER+=" OWNER"
	FIELDS+=" 1" 
fi

if [[ "$PROCESSTATUS" == true ]]; then
	HEADER+=" STATUS"
	FIELDS+=" 6"
fi
echo $HEADER
echo "$PROCESSLIST" | 
	awk '{
	n = split("$FIELDS", field, " ")
	for(i=1; i<=n; i++)
	{
		printf "%s ", $field[i] 
	} 
	printf "\n"}'
