#!/usr/bin/env bash
# Run an eRPC app on this machine
source $(dirname $0)/utils.sh
check_env "autorun_app"

drop_shm

# Install modded driver - this is not a requirement
(cd ~/libmlx4-1.2.1mlnx1/ && ./update_driver.sh)

# Check arguments
if [ "$#" -gt 2 ]; then
  blue "Illegal number of arguments. Usage: do.sh <machine_id>, or do.sh gdb <machine_id>"
	exit
fi

if [ "$#" -eq 0 ]; then
  blue "Illegal number of arguments. Usage: do.sh <machine_id>, or do.sh gdb <machine_id>"
	exit
fi

# Check for non-gdb mode
if [ "$#" -eq 1 ]; then
  blue "do.sh: machine ID = $1"
  sudo taskset -c 0 ./build/$autorun_app $(cat apps/$autorun_app/config) --machine_id $1
fi

# Check for gdb mode
if [ "$#" -eq 2 ]; then
  if [ "$1" == "gdb" ]; then
    blue "do.sh: machine ID = $1. Launching gdb."
    sudo gdb -ex run --args ./build/$autorun_app $(cat apps/$autorun_app/config) --machine_id $2
  else
    blue "do.sh: Invalid parameter 1. Expected = gdb."
  fi
fi