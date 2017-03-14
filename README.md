# iOSGetMACAddress
iOS another way to get mac address after iOS 7.

## Why
Since iOS 7.0, you cannot easily using ```sysctl()``` or ```ioctl()``` to get MAC address(normal way).
<br />
<br />
[Link (the most bottom)](https://developer.apple.com/library/content/releasenotes/General/WhatsNewIniOS/Articles/iOS7.html)

```
In iOS 7 and later, if you ask for the MAC address of an iOS device, the system returns the value 02:00:00:00:00:00.
If you need to identify the device, use the identifierForVendor property of UIDevice instead.
(Apps that need an identifier for their own advertising purposes should consider using the advertisingIdentifier property of ASIdentifierManager instead.)
```

## Way1: iOS version is less than or equal to 10.1
1. Connect to any Wi-Fi.
2. Get current IP address of Wi-Fi.
1. Send ICMP echo request(ping) to the IP address.(not the IP address, 127.0.0.1)
2. Walk whole ARP table to search the MAC address of current IP address of Wi-Fi.
3. Get your MAC address.

## Way2: iOS version is less than or equal to 10.2.1
1. Connect to any Wi-Fi.
2. Get current IP address of Wi-Fi.
1. Send ICMP echo request(ping) to the IP address.(not the IP address, 127.0.0.1)
2. Get an ARP entry by current IP address of Wi-Fi.
3. Get your MAC address.

## Way3: iOS version is greater than 10.1(or lesser version)
1. Connect to any Wi-Fi.
2. Get current IP address of Wi-Fi.
1. Send MDNS query that question "\_apple-mobdev2.\_tcp.local" with PTR record.
2. Response data will content MAC address.
3. Get your MAC address.

## Result
Include 2 different iOS version.<br />
<img src="example2.png">
<br />
<img src="example1.png">
