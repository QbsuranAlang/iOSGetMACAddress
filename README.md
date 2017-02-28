# iOSGetMACAddress
iOS simple way to get mac address after iOS 7.

## Step
1. Connection to any Wi-Fi.
2. Get current IP address of Wi-Fi.
3. Send ICMP echo request(ping) to the IP address(Not the IP address, 127.0.0.1).
4. Walk ARP Table to search the IP address of Wi-Fi.
5. Get your MAC address.

## Result
<img src="example.PNG">
