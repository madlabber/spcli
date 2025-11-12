# spcli
A Service-Processor-like CLI for ONTAP Select on KVM

### About
SPCLI implements much of the Service Processor Command Line Interface for an ONTAP Select kvm host.  SPCLI can be run as a command or as an interactive shell.  SPCLI can also be used to prepare a linux host for an ONTAP Select deployment.  

### Background
On a hardware storage appliance the service processor provides out-of-band management of the storage controller.  This script maps established service processor commands to their linux / virsh equivilents to provide a similar out of band management experience for ONTAP Select running on a linux host.

### Installation

    sudo git clone https://github.com/madlabber/spcli.git /opt/spcli
    sudo /opt/spcli/install.sh 

### Basic usage
for an interactive shell:

    sudo spcli

to run a command noninteractively:

    sudo spcli <command>

Note:
To allow a non-root user to use spcli, add them to the libvirt group first:

    sudo usermod -aG libvirt $USER
    newgrp libvirt

Some functions still require sudo or root group membership.

### Preparing a host with SPCLI
An unconfigured linux host can be prepared for ONTAP Select Deploy by performing host setup. 

#### Invoke the host setup process:

    sudo spcli host setup

Then follow the prompts to install and configure host software packages, storage pool creation, and configure host networking.

### Using interactive help
Begin by invoking the spcli shell

    sudo spcli
    SP >

At the SP prompt, type ?:
    
    SP > ?
    date - print date and time
    events - print system events and event information
    exit - exit from the SP command line interface
    help - print command help
    priv - show and set user mode
    sp - commands to control the SP
    system - commands to control the system
    version - print Service Processor version
    
    SP >

To view help on a specific command or view any available sub-commands, enter ? \<commnd\> 

    SP > ? system
    system acp - acp related commands
    system battery - battery related commands
    system console - connect to the system console
    system core - dump the system core and reset
    system cpld - cpld commands
    system fru - fru related commands
    system log - print system console logs
    system power - commands controlling system power
    system sensors - print system sensors
    system reset - reset the system using the selected firmware
    system forensics - configure watchdog forensics collection settings
    system watchdog - system watchdog commands
    
    SP > 

### Using the system console
The ONTAP node has a serial port console that can be accessed interactively from the spcli command:
    
    SP > system console

To exit the system console, press ctrl-D.

Using native virsh console commands can interfere with the system console logging process, so use the spcli to access the node serial console whenever possible.  If the virsh console must be used, invoke spcli afterward to ensure the background console logging is operational.

    sudo spcli exit

### About system console logging
SPCLI implements background logging of the ONTAP Select node's serial console.  The log is split into two stages called log 1 and log 2.  Log 1 contains pre-boot log entries, such as bios, loader, and pre-boot kernel module log entries.  Log 2 contains all post-boot events.

The logs can be viewed using spcli commands:

    SP > system log [-a] [-l 1 | -l 2]
            -a: all (logs 1 and log 2)
            -l 1 : view only log 1
            -l 2 : view only log 2

Raw log files are stored in /opt/spcli/log

The logging process is triggered by a qemu hook script (/etc/libvirt/hooks/qemu).  The hook script is installed during host setup if no pre-existing hook script is installed.  If a custom hook script is already installed, manually merge the contents of the qemu file into the custom hook script to enable system console logging when the node VM starts.  

### events commands
While the system log captures and prnits the output of the node's the serial console, the events commands print and search the linux host's event logs.

    SP > ? events
    events all - print all system events
    events info - print system event log information
    events newest - print newest system events
    events oldest - print oldest system events
    events search - search for and print system events
    
    SP > 

### Non-Functional commands

Some SP commands control hardware not found on a linux host or qemu virtual machine, but are preserved for completeness.  Non-functional commands include:

    system acp 
    system cpld
    system forensics
    system watchdog

### system fru commands

There are two logical FRU IDs that can be displayed.

    SP > system fru list

      FRU ID      Name
    ==============================================
        0         Controller
        1         Chassis
    
FRU 0 is mapped to the storage controller VM.  It prints information about the VM resources, serial numbers, and associated disks.

    SP > system fru show 0

FRU 1 is mapped to the linux server hardware.  It prints information related to the server hardware.

    SP > system fru show 1



