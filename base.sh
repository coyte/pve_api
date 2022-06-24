#!/bin/bash
##################################
### API AUTOMATION
# for the proxmox community
# By veeh, enjoy

url_base="https://$pve$port/api2/json"
# this is where you put what ever you want do
# https://pve.proxmox.com/pve-docs/api-viewer/
url_end="nodes/$node/qemu/$vmid/status/stop"
urlqr="$url_base/$url_end"
urltk="$url_base/access/ticket"

ticket=`curl --insecure --data "username=$apiu&password=$apip" $urltk`

# Grab cookie and token from the ticket data
cookieid=`echo $ticket | tr -t '"' '\n' | grep "PVE:api@pve"`
cookie="PVEAuthCookie=$cookieid"
ticketid=`echo $cookie | awk -F ':' '{ print $3 }'`
tokenid=`echo $ticket | tr -t '"' '\n' | grep $ticketid | grep -v PVE`
token="CSRFPreventionToken:$tokenid"

#proxmox api query
curl --insecure --cookie $cookie --header $token -X POST "$urlqr"