#!/bin/bash

# TurnVPNOn.sh
# Sidestep
#
# Created by Chetan Surpur on 10/26/10.
# Copyright 2010 Chetan Surpur. All rights reserved.

if [ ! -n "$1" ]; then
	echo "Usage: TurnVPNOn.sh serviceName"
    exit 0
fi

SERVICENAME=$1
export SERVICENAME

# redirect stdin
exec <"$0" || exit

# find the start of the AppleScript
found=0
while read v; do
        case "$v" in --*)
                # file offset at start of AppleScript
                found=1; break
                ;;
        esac
done

case "$found" in
    0)  
        echo 'AppleScript not found' >&2
        exit 128
        ;;
esac

# run the AppleScript
bash -c "/usr/bin/osascript"; exit

-- AppleScript starts here

-- Retrieve environment variables
set service_name to system attribute "SERVICENAME"

-- Return values:
--	1 - Success
--	2 - No such service
--	3 - Service found was not of type VPN

-- Start turning it on
tell application "System Events"
	try
		service service_name of network preferences
	on error
		return 2
	end try
	
	set s to service service_name of network preferences
	
	-- if kind of service = 14 then vpn
	if kind of s is not 14 then
		return 3
	end if

	if not connected of configuration of s as boolean then
		tell s to connect
	else
		tell s to disconnect
	end if
	
	return 1
end tell