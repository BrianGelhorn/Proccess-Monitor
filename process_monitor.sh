#!/bin/bash

show_help(){
	cat <<EOF
Usage: $0 [OPTIONS] <process_name>
 
Options:
	--list		List all running processes
	--metrics	Show CPU and MEMORY usage
	--owner		Show the user who launched the process
	--status	Show the state of the process
	-h, --help	Show this help message
EOF
}

LIST=false
METRICS=false
OWNER=false
PROCESSTATUS=false
PROC=""
while [[ "$#" -gt 0 ]]; do
	case "$1" in 
	--help|-h)
		show_help
		exit 0
		;;
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
#				 1   2    3    4    5    6 
PROCESSLIST=$(ps --no-headers -o pid,comm,%cpu,%mem,user,stat -C "$PROC")
HEADER="PID\tNAME"
FIELDS="1 2"
if [[ -z "$PROCESSLIST" ]]; then
	echo No process was found
	exit 1
fi 
echo List of processes labeled "$PROC"\:
if [[ "$METRICS" == true ]]; then
	HEADER+="\tCPU\tRAM"	
	FIELDS+=" 3 4"
fi	

if [[ "$OWNER" == true ]]; then
	HEADER+="\tOWNER"
	FIELDS+=" 5" 
fi

if [[ "$PROCESSTATUS" == true ]]; then
	HEADER+="\tSTATUS"
	FIELDS+=" 6"
fi
(echo -e "$HEADER"
echo "$PROCESSLIST" | awk -v fields="$FIELDS" '{
	n = split(fields, field, " ")
	for(i=1; i<=n; i++)
	{
		curField = $field[i]
		if(field[i]==6){
			if(curField ~ /^R/){
				printf "Running"	
			}
			else if(curField ~ /^S/){
				printf "Sleeping"
			}	
			else if(curField ~ /^T/){	
				printf "Stopped"
			}
		}
		else{
			printf "%s\t", curField	
		}
	} 
	printf "\n"}') | column -t -s $'\t'
