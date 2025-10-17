#!/bin/bash

# fixme: detect this automatically or take as an arg
domain="ots70-01"

systemdisk="/dev/select_pool/$domain/$domain_DataONTAPv.raw"

prompt="SP $domain"

function help () {
    echo "date - print date and time"
    echo "exit - exit from the SP command line interface"
    echo "help - print command help"
    echo "system - commands to control the system"
    echo "version - print Service Processor version"
    echo
}

function help_date () {
    echo "date - print date and time"
    echo
}

function help_exit () {
    echo "exit - exit from the SP command line interface"
    echo
}

function help_system () {
    echo "system console - connect to the system console"
    echo "system core - dump the system core and reset"
    echo "system power - commands controlling system power"
    echo "system reset - reset the system using the selected firmware"
    echo
}

function help_system_power () {
    echo "system power cycle - power the system off, then on"
    echo "system power halt - halt the system"
    echo "system power off - power the system off"
    echo "system power on - power the system on"
    echo "system power status - print system power status"
    echo
}

function help_system_reset () {
    echo "system reset current - reset the system using the current firmware"
    echo
}

function system_console () {
    virsh -e ^D console "$domain" --force
}

function system_core () {
    virsh inject-nmi "$domain"
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

function version () {
    echo "SP CLI for ONTAP Select version 0.01"
}
# main loop

while true; do
  read -ep "$prompt> " cmd

  # exit
  if [ "$cmd" == "date" ]; then date;fi
  if [ "$cmd" == "exit" ]; then exit;fi
  if [ "$cmd" == "help" ]; then help;fi
  if [ "$cmd" == "help date" ]; then help_date;fi
  if [ "$cmd" == "help exit" ]; then help_exit;fi
  if [ "$cmd" == "help system" ]; then help_system;fi
  if [ "$cmd" == "help system power" ]; then help_system_power;fi
  if [ "$cmd" == "help system reset" ]; then help_system_reset;fi
  if [ "$cmd" == "system" ]; then help_system;fi
  if [ "$cmd" == "system console" ]; then system_console;fi
  if [ "$cmd" == "system core" ]; then system_core;fi
  if [ "$cmd" == "system power" ]; then help_system_power;fi
  if [ "$cmd" == "system power cycle" ]; then system_power_cycle;fi
  if [ "$cmd" == "system power halt" ]; then system_power_halt;fi
  if [ "$cmd" == "system power off" ]; then system_power_off;fi
  if [ "$cmd" == "system power on" ]; then system_power_on;fi
  if [ "$cmd" == "system power status" ]; then system_power_status;fi
  if [ "$cmd" == "system reset" ]; then system_reset_current;fi
  if [ "$cmd" == "system reset current" ]; then system_reset_current;fi
  if [ "$cmd" == "version" ]; then version;fi
  if [ "$cmd" == "?" ]; then help;fi

done
