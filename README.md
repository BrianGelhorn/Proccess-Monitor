# Process-Monitor

A simple tool written in bash made to monitor processes and display information about them


# FEATURES

* List all running processes in the system
* Get the PID of the processes
* Know what user launched any process
* Check the consumption of CPU and RAM by any process
* Get the current state of any specified process

# Usage

`./process_monitor.sh [OPTIONS] <process_name>`

## List all processes

`./process_monitor.sh --list`

(--list doesn't accept a process name)

# Options

    --list          List all running processes
    --metrics       Show CPU and MEMORY usage
    --owner         Show the user who launched the process
    --status        Show the state of the process
    -h, --help      Show this help message

# Examples

`./process_monitor.sh bash --metrics --owner`

Output:

    List of processes labeled bash:
    PID    NAME  CPU  RAM  OWNER
    11964  bash  0.0  0.0  broogel
    34722  bash  0.0  0.0  broogel

`./process_monitor.sh bash --status`

Output:

    List of processes labeled bash:
    PID    NAME  STATUS
    11964  bash  Sleeping
    34722  bash  Sleeping

# Requirements

* Linux
* Bash
* Standard Unix Tools:
    * ps
    * column
    * awk

