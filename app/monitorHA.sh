#!/bin/bash

################################################################################

# This script will check to see if a website is up/down by pinging the url
# If there is no response an email wil be send via an external smtp mail server (undo)
# If the site status is down an email will be send when the site is up again (undo)

log_file=status.log
# set your check interval here :-) #############################################
interval=5 #second

# your url #####################################################################
getURL(){
    # for Debian O.S.
    # ipaddr=$(hostname -I | cut -d' ' -f1)
    # for alpine
    ipaddr=$(ip r | grep default | cut -d' ' -f8 | head -n 1)
    url="http://"$ipaddr":3218"
    echo $url
}

# check url ####################################################################
temp_url="http://0.0.0.0"

while :
do

    new_url=$(getURL)
    # echo $ip_address
    status=$(curl -s --head --request GET $new_url | grep "200 OK" | wc -l)
    temp_status=$(curl -s --head --request GET $temp_url | grep "200 OK" | wc -l)

    if [ "$status" -eq 1 ]; then

        if [ "$new_url" != "$temp_url" ] && [ "$temp_status" -eq 0 ]; then
            temp_url=$new_url
            yq e '.panel_iframe.bt2mqtt_config.url = "'$new_url'"' -i configuration.yaml
            sleep 1
            docker restart homeassistant
        fi

        echo "STATUS="$status", $temp_url SERVER UP | `date`"
        echo "STATUS="$status", $temp_url SERVER UP | `date`" >> `echo $log_file`
    else
        echo "STATUS="$status", $temp_url SERVER DOWN | `date`"
        echo "STATUS="$status", $temp_url SERVER DOWN | `date`" >> `echo $log_file`
    fi

    # keep only the last 100 lines of a log file
    tail -n 100 $log_file | sponge $log_file
    
	sleep $interval

done

exit

# Akashic #########################################################################