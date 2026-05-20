#!/bin/bash

# Checking if it is accessed using root directory or not 
if [[ $EUID -ne 0 ]]; then
	whiptail --msgbox "Permission denied" 10 40
	whiptail --msgbox "Script must be run as root. Re-run the script using sudo command"
	exit 1
fi

# Interface
INTERFACE=$(whiptail --inputbox "Please enter the name of your interface" 10 40 3>$1 1>$2 2>$3)

# IP
IP=$(whiptail --inputbox "Please enter your static IP address" 10 40 3>$1 1>$2 2>$3)

# CIDR
CDIR=$(whiptail --inputbox "Please enter CIDRk" 10 40 3>$1 1>$2 2>$3)

# gateway
GATEWAY=$(whiptail --inputbox "Please enter your gateway IP" 10 40 3>$1 1>$2 2>$3)

# DNS Server
DNS=$(whiptail --inputbox "Please enter your DNS Server" 10 40 3>$1 1>$2 2>$3) 

# validating ip using a fucntion
validateIP(){
	if [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]];then
		return 0
	else
		return 1
	fi
}


