#!/bin/bash
##################################
### API AUTOMATION
# for the proxmox community
# By veeh, enjoy
source ./niels_vars.sh

echo 'Node: '$node
url_base="https://$pve$port/api2/json"
# this is where you put what ever you want do
# https://pve.proxmox.com/pve-docs/api-viewer/
#url_end="nodes/$node/qemu/$vmid/status/stop"
url_end="nodes/$node/status"
urlqr="$url_base/$url_end"
urltk="$url_base/access/ticket"

ticket=`curl --insecure --data "username=$apiu&password=$apip" $urltk`
#curl --insecure --data "username=root@pam&password=TAspect01" https://pve.teekens.info:8006/api2/json/access/ticket | grep jq
echo 'ticket curled: '$ticket

# Grab cookie and token from the ticket data
cookieid=`echo $ticket | tr '"' '\n' | grep "PVE:"`
echo "set cookieid: "$cookieid

cookie="PVEAuthCookie=$cookieid"
echo "set cookie: "$cookie

ticketid=`echo $cookie | awk -F ':' '{ print $3 }'`
echo "ticketid: "$ticketid

tokenid=`echo $ticket | tr '"' '\n' | grep $ticketid | grep -v PVE`
echo "tokenid: "$tokenid

token="CSRFPreventionToken:$tokenid"
echo "token"$token



echo "variables needed for final command:"
echo "cookie: "$cookie
echo "token: "$tokenid
echo "urlqr: "$urlqr

#proxmox api query
curl --insecure --cookie $cookie --header $token -X POST "$urlqr"