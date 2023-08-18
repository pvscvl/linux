#!/bin/bash

# Function to validate IPv4 address using regex
validate_ip() {
	local ip=$1
	local stat=1

	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		OIFS=$IFS
		IFS='.'
		ip=($ip)
		IFS=$OIFS
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
		stat=$?
	fi
	return $stat
}

LOGFILE="/Downloads/public-ip.log"
LOGFILESORTED="/Downloads/public_ips_sorted.txt"
IPFILE="/root/current_ip.txt"
TIMESTAMPFILE="/root/iptimestamp.txt"

CURRENT_IP=$(dig @resolver4.opendns.com myip.opendns.com +short)

if [ $? -ne 0 ] || [ -z "$CURRENT_IP" ] || ! validate_ip "$CURRENT_IP" &>/dev/null; then
	exit 1
fi

if [ ! -f "$IPFILE" ] || [ "$CURRENT_IP" != "$(cat $IPFILE)" ]; then
	# Calculate the duration for which the previous IP was held
	DURATION_MSG=""
	if [ -f "$TIMESTAMPFILE" ]; then
		PREVIOUS_TIMESTAMP=$(cat "$TIMESTAMPFILE")
		NOW_TIMESTAMP=$(date +%s)
		DURATION=$(( NOW_TIMESTAMP - PREVIOUS_TIMESTAMP ))

		DAYS=$(( DURATION / 86400 ))
#       	HOURS=$(( (DURATION % 86400) / 3600 ))
#        	MINUTES=$(( (DURATION % 3600) / 60 ))
   		HOURS=$(printf "%02d" $(( (DURATION % 86400) / 3600 )))
        	MINUTES=$(printf "%02d" $(( (DURATION % 3600) / 60 )))

        	DURATION_MSG="had the previous IP for"
        	[ $DAYS -gt 0 ] && DURATION_MSG="$DURATION_MSG ${DAYS}d"
        	[ $HOURS -gt 0 ] && DURATION_MSG="$DURATION_MSG ${HOURS}h"
        	[ $MINUTES -gt 0 ] && DURATION_MSG="$DURATION_MSG ${MINUTES}min"
	fi
	# Update the IP and timestamp
	echo "$CURRENT_IP" > $IPFILE
	date +%s > $TIMESTAMPFILE
    	# Log the IP change
	echo "$CURRENT_IP" >> $LOGFILESORTED
	printf "$(date '+%Y-%m-%d %H:%M') - IP changed to: $CURRENT_IP \\t($DURATION_MSG)\\n" >> $LOGFILE
#	printf "$(date '+%Y-%m-%d %H:%M') Public-IP changed to: $CURRENT_IP\\t($DURATION_MSG)\\n" >> $LOGFILE
#	echo "$(date '+%Y-%m-%d %H:%M') - IP changed to: $CURRENT_IP$DURATION_MSG" >> $LOGFILE
	sort $LOGFILESORTED -o $LOGFILESORTED
fi
