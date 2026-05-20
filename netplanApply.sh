#!/bin/bash

# Checking if it is accessed using root directory or not 
if [[ $EUID -ne 0 ]]; then
	whiptail --msgbox "Permission denied" 10 40
	whiptail --msgbox "Script must be run as root. Re-run the script using sudo command" 10 40
	exit 1
fi

# Interface
ALL_INTERFACES=$(ip -o link show)
INTERFACE_NAMES=$(echo "$ALL_INTERFACES" | awk -F': ' '{print $2}')
INTERFACES=$(echo "$INTERFACE_NAMES" | grep -v "lo")
MENU=()
for interface in $INTERFACES
do
	MENU+=("$interface" "Available Network Interface")
done
INTERFACE=$(whiptail \
--title "Network Interface" \
--menu "Choose Network Interface" \
15 60 5 \
"${MENU[@]}" \
3>&1 1>&2 2>&3)

# IP
IP=$(whiptail --inputbox "Please enter your static IP address" 10 40 3>&1 1>&2 2>&3)
if [[ $? -ne 0 ]]; then
    whiptail --msgbox "Configuration Cancelled" 10 40
    exit 1
fi

# CIDR
CIDR=$(whiptail --inputbox "Please enter CIDR" 10 40 3>&1 1>&2 2>&3)
if [[ $? -ne 0 ]]; then
    whiptail --msgbox "Configuration Cancelled" 10 40
    exit 1
fi

# gateway
GATEWAY=$(whiptail --inputbox "Please enter your gateway IP" 10 40 3>&1 1>&2 2>&3)
if [[ $? -ne 0 ]]; then
    whiptail --msgbox "Configuration Cancelled" 10 40
    exit 1
fi

# DNS Server
DNS=$(whiptail --inputbox "Please enter your DNS Server" 10 40 3>&1 1>&2 2>&3) 
if [[ $? -ne 0 ]]; then
    whiptail --msgbox "Configuration Cancelled" 10 40
    exit 1
fi

# validating ips using a fucntion
validateIP(){
	local ip=$1
	if [[ -z "$ip" ]];then
		return 1
	fi

	if [[ !$ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]];then
		return 1
	fi

	#spilt ip and then check 
	IFS='.' read -r o1 o2 o3 o4 <<< "$ip"

	for octet in $o1 $o2 $o3 $o4 
	do
		if (( octet <0 || octet > 255 )); then
			return 1
		fi
	done
	return 0
}

# validate inteface
validateInterface(){
	local interface=$1
	if [[ -z "$interface" ]]; then
		return 1
	fi

	if ! ip link show "$INTERFACE"; then
		whiptail --msgbox "Invalid Interface chose" 10 40
		return 1
	fi

}

#validate CIDR
validateCIDR(){
	if [[ $1 =~ ^[0-9]+$ ]] && (( $1 >=0 && $1 <= 32 )); then
	       return 0
       else
	       return 1
	fi
}

# validate interface
if ! validateInterface "$INTERFACE"; then
       whiptail --msgbox "Invalid Interface name" 10 40
       exit 1
fi

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

# validate CIDR
if ! validateCIDR "$CIDR"; then
       whiptail --msgbox "Invalid CIDR value" 10 40
       exit 1
fi

# creating netplan configuration file
cat <<EOF > /etc/netplan/01-static.yaml
network:
  version: 2
  renderer: networkd

  ethernets:
    $INTERFACE:
      dhcp4: no
    
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
netplan try

if [[ $? -ne 0 ]]; then
	whiptail --msgbox "Netplan configuration failed" 10 40
	exit 1
fi

# success message
whiptail --msgbox "SUccessfully configured" 10 40





