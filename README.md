# iOSGetMACAddress
iOS simple way to get mac address after iOS 7.

## Steps
1. Connection to any Wi-Fi.
2. Get current IP address of Wi-Fi.
3. Send ICMP echo request(ping) to the IP address.(not the IP address, 127.0.0.1)
4. Walk ARP table to search the MAC address of current IP address of Wi-Fi.
5. Get your MAC address.

## Result
<img src="example.PNG">
