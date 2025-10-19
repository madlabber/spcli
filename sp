#!/bin/bash

# find the virsh domain of the storage controller
systemdisk="$(find /dev | grep _DataONTAPv.raw | grep -v mapper | grep -v by-id)"
diskfilename=$(basename "$systemdisk")
domain=${diskfilename::${#diskfilename}-15}
prompt="SP $domain"

priv_mode="admin"

set -o history  # Enable history
HISTFILE=~/.temp_history
HISTSIZE=1000  # Set the maximum number of commands to remember
HISTFILESIZE=2000  # Set the maximum size of the history file


function events_newest () {
    count=$(echo "$cmd" | cut -d' ' -f 3)

    case $count in
        "" | *[!0-9]*) echo "usage: events newest <number>" ;;
        *) journalctl | tail -n $count
    esac
}

function events_oldest () {
    count=$(echo "$cmd" | cut -d' ' -f 3)

    case $count in
        "" | *[!0-9]*) echo "usage: events oldest <number>" ;;
        *) journalctl | head -n $count
    esac
}

function events_search () {
    searchstr=$(echo "$cmd" | cut -d' ' -f 3-)

    case $searchstr in
        "" ) echo "usage: events search <string>" ;;
        *) journalctl | grep -F "$searchstr"
    esac
}

function sp_status () {
   echo "Firmware Version:     $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
   echo "IPv4 configuration:"
   echo "  IP Address:         $(ifconfig | grep "inet " | grep -v "127.0.0.1" | tr -s ' ' | cut -d' ' -f3)"
   echo "  Netmask:            $(ifconfig | grep "inet " | grep -v "127.0.0.1" | tr -s ' ' | cut -d' ' -f5)"
   echo "  Gateway:            $(ifconfig | grep "inet " | grep -v "127.0.0.1" | tr -s ' ' | cut -d' ' -f7)"

}

function system_power_cycle () {
  while true; do
    read -r -p "This will cause a dirty shutdown of your appliance. Continue? [y/n] " choice
    case "$choice" in
      y|Y ) echo; break;;
      n|N ) echo; break;;
        * ) echo "Invalid response: [ $choice ].";;
    esac
  done

  if [ "$choice" == "y" ] || [ "$choice" == "Y" ];then
    state=$(virsh domstate $domain)
    if [ "$state" == "running" ]; then
      virsh destroy "$domain" --graceful > /dev/null
      virsh start "$domain" > /dev/null
      echo
    fi
  fi
}

function system_power_halt () {
    virsh shutdown "$domain"
}

function system_power_off () {
  while true; do
    read -r -p "This will cause a dirty shutdown of your appliance. Continue? [y/n] " choice
    case "$choice" in
      y|Y ) echo; break;;
      n|N ) echo; break;;
        * ) echo "Invalid response: [ $choice ].";;
    esac
  done

  if [ "$choice" == "y" ] || [ "$choice" == "Y" ];then
    state=$(virsh domstate $domain)
    if [ "$state" == "running" ]; then
      virsh destroy "$domain" --graceful > /dev/null
      echo
    fi
  fi
}

function system_power_on () {
  state=$(virsh domstate $domain)
  if [ "$state" != "running" ]; then
    virsh start $domain > /dev/null
  fi
}

function system_power_status () {
  state=$(virsh domstate $domain)
  if [ "$state" == "running" ]; then
    echo "System Power is on"
  else
    echo "System Power is off"
  fi
}

function system_reset_current () {
  while true; do
    read -r -p "This will cause a dirty shutdown of your appliance. Continue? [y/n] " choice
    case "$choice" in
      y|Y ) echo; break;;
      n|N ) echo; break;;
        * ) echo "Invalid response: [ $choice ].";;
    esac
  done

  if [ "$choice" == "y" ] || [ "$choice" == "Y" ];then
      virsh destroy "$domain" --graceful > /dev/null
      virsh start "$domain" > /dev/null
      echo
  fi
}

# main loop

while true; do
  history -c
  history -r ~/.spcli_history
  read -ep "$prompt> " cmd

  if [ "#cmd" != "" ];then echo "$cmd" >> ~/.spcli_history;fi

  case $cmd in
    ""     ) ;;
    "date" ) date ;;
    "events all" ) journalctl ;;
    "events newest"* ) events_newest ;;
    "events oldest"* ) events_oldest ;;
    "events search"* ) events_search ;;
    "exit" ) exit ;;
    "help" | "?"  )
        echo "date - print date and time"
        echo "exit - exit from the SP command line interface"
        echo "events - print system events and event information"
        echo "help - print command help"
        echo "priv - show and set user mode"
        echo "sp - commands to control the SP"
        echo "system - commands to control the system"
        echo "version - print Service Processor version"
        echo ;;
    "help help"   )
        echo "help - print command help" ;;
    "help date"   )
        echo "date - print date and time" ;;
    "help events" | "events" )
        echo "events all - print all system events"
        echo "events info - print system event log information"
        echo "events newest - print newest system events"
        echo "events oldest - print oldest system events"
        echo "events search - search for and print system events"
        echo ;;
    "help events newest" )
        echo "events newest - print newest system events" ;;
    "help events oldest" )
        echo "events oldest - print oldest system events" ;;
    "help events search" )
        echo "events search - search for and print system events" ;;
    "help exit" )
        echo "exit - exit from the SP command line interface" ;;
    "help priv" )
        echo "priv set - set user mode"
        echo "priv show - show current user mode"
        echo ;;
    "help priv set" )
        echo "priv set admin - enter into admin user mode"
        echo "priv set -q admin - enter into admin user mode"
        echo "priv set advanced - enter into advanced user mode"
        echo "priv set -q advanced - enter into advanced user mode(quiet flag)"
        echo "priv set diag - enter into diag user mode"
        echo "priv set -q diag - enter into diag user mode(quiet flag)"
        echo ;;
    "help priv show" )
        echo "priv show - show current user mode" ;;
    "help sp" | "sp" )
        echo "sp status - print SP status information"
        echo "sp uptime - display service processor uptime"
        echo ;;
    "help sp status" )
        echo "sp status - print SP status information" ;;
    "help system console" )
        echo "system console - connect to the system console" ;;
    "help system core" )
        echo "system core - dump the system core and reset" ;;
    "help system power" | "system power" )
        echo "system power cycle - power the system off, then on"
        echo "system power halt - halt the system"
        echo "system power off - power the system off"
        echo "system power on - power the system on"
        echo "system power status - print system power status"
        echo ;;
    "help system reset" )
        echo "system reset current - reset the system using the current firmware"
        echo ;;
    "help version" )
        echo "version - print Service Processor version" ;;
    "priv set" | "priv set admin" )
        priv_mode="admin"
        echo "Administrative commands"
        echo ;;
    "priv set -q admin" )
        priv_mode="admin"
        ;;
    "priv set advanced" )
        priv_mode="advanced"
        echo "Warning: These advanced commands are potentially dangerous; use them only when directed to do so by support personnel."
        echo ;;
    "priv set -q advanced" )
        priv_mode="advanced"
        ;;
    "priv set diag" )
        priv_mode="diag"
        echo "Warning: These diagnostic commands are for use by support personnel only."
        echo ;;
    "priv set -q diag" )
        priv_mode="diag"
        ;;
    "priv show" | "priv" )
        echo "$priv_mode"
        echo ;;
    "priv set"* )
        echo "priv set admin - enter into admin user mode"
        echo "priv set -q admin - enter into admin user mode"
        echo "priv set advanced - enter into advanced user mode"
        echo "priv set -q advanced - enter into advanced user mode(quiet flag)"
        echo "priv set diag - enter into diag user mode"
        echo "priv set -q diag - enter into diag user mode(quiet flag)"
        echo ;;
    "sp status" ) sp_status ;;
    "sp uptime" ) uptime ;;
    "system console" )
        virsh -e ^D console "$domain" --force
        ;;
    "system core" )
        virsh inject-nmi "$domain"
        ;;
    "system power cycle" ) system_power_cycle ;;
    "system power halt" )
        virsh shutdown "$domain"
        ;;
    "system power off" ) system_power_off ;;
    "system power on" ) system_power_on ;;
    "system power status" ) system_power_status ;;
    "system reset" ) system_reset_current ;;
    "system reset current" ) system_reset_current ;;
    "system sensors" )
        sensors
        ;;
    "system"* | "help system" )
        echo "system console - connect to the system console"
        echo "system core - dump the system core and reset"
        echo "system power - commands controlling system power"
        echo "system reset - reset the system using the selected firmware"
        echo "system sensors - print system sensors"
        echo ;;
    "version" )
        echo "SP CLI for ONTAP Select version 0.01" ;;
    * )
        echo "command not found. Type '?' for a list of available commands."
  esac

done
