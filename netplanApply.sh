#!/bin/bash

# Checking if it is accessed using root directory or not 
if [[ $EUID -ne 0 ]]; then
	whiptail --msgbox "Permission denied" 10 40
	whiptail --msgbox "Script must be run as root. Re-run the script using sudo command" 10 40
	exit 1
fi

# Interface
INTERFACE=$(whiptail --inputbox "Please enter the name of your interface" 10 40 3>&1 1>&2 2>&3)

# IP
IP=$(whiptail --inputbox "Please enter your static IP address" 10 40 3>&1 1>&2 2>&3)

# CIDR
CIDR=$(whiptail --inputbox "Please enter CIDR" 10 40 3>&1 1>&2 2>&3)

# gateway
GATEWAY=$(whiptail --inputbox "Please enter your gateway IP" 10 40 3>&1 1>&2 2>&3)

# DNS Server
DNS=$(whiptail --inputbox "Please enter your DNS Server" 10 40 3>&1 1>&2 2>&3) 

# validating ips using a fucntion
validateIP(){
	if [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]];then
		return 0
	else
		return 1
	fi
}

# validate ip
if ! validateIP "$IP"; then
	whiptail --msgbox "Invalid IP address" 10 40
	exit 1
fi

# validate gateway
if ! validateIP "$GATEWAY"; then
	whiptail --msgbox "Invalid gateway address" 10 40
	exit 1
fi

# validate DNS
if ! validateIP "$DNS"; then
	whiptail --msgbox "Invalid DNS server"; 10 40
	exit 1
fi

# creating netplan configuration file
cat <<EOF > /etc/netplan/01-static.yaml
network:
 version: 2
 renderer: networkd

 ethernets:
  $INTERFACE:
   dhcp: no
   addresses: 
    - $IP/$CIDR

   routes:
    - to: default
    via: $GATEWAY

   nameservers:
   addresses:
    - $DNS
EOF

# Applying netplan configuration
netplan apply

#success message
whiptail --msgbox "Successfully configured" 10 52




