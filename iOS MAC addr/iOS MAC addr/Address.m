//
//  Address.m
//  iOS MAC addr
//
//  Created by TUTU on 2017/2/28.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import "Address.h"
#import <ifaddrs.h>
#import <netinet/ip.h>
#import <arpa/inet.h>
#import <net/ethernet.h>

@implementation Address

+ (nonnull NSString *)currentIPAddressOf: (nonnull NSString *)device {
    struct ifaddrs *addrs;
    NSString *ipAddress = nil;
    
    if(getifaddrs(&addrs) != 0) {
        return nil;
    }//end if
    
    //get ipv4 address
    for(struct ifaddrs *addr = addrs ; addr ; addr = addr->ifa_next) {
        if(!strcmp(addr->ifa_name, [device UTF8String])) {
            if(addr->ifa_addr) {
                struct sockaddr_in *in_addr = (struct sockaddr_in *)addr->ifa_addr;
                if(in_addr->sin_family == AF_INET) {
                    ipAddress = [Address IPv4Ntop:in_addr->sin_addr.s_addr];
                    break;
                }//end if
            }//end if
        }//end if
    }//end for
    
    freeifaddrs(addrs);
    return ipAddress;
}//end currentIPAddressOf:

+ (nullable NSString *)IPv4Ntop: (in_addr_t)addr {
    char buffer[INET_ADDRSTRLEN] = {0};
    return inet_ntop(AF_INET, &addr, buffer, sizeof(buffer)) ?
    [NSString stringWithUTF8String:buffer] : nil;
}//end IPv4Ntop:

+ (in_addr_t)IPv4Pton: (nonnull NSString *)IPAddr {
    in_addr_t network = INADDR_NONE;
    return inet_pton(AF_INET, [IPAddr UTF8String], &network) == 1 ?
    network : INADDR_NONE;
}//end IPv4Pton:

+ (nullable NSString *)linkLayerNtop: (nonnull struct sockaddr_dl *)sdl {
    if(sdl->sdl_alen == 0) {
        return nil;
    }//end if
    
    NSMutableString *buf = [[NSMutableString alloc] initWithString:@""];
    char *cp = (char *)LLADDR(sdl);
    int n;
    
    if ((n = sdl->sdl_alen) > 0) {
        while (--n >= 0) {
            [buf appendFormat:@"%02x%s", *cp++ & 0xff, n > 0 ? ":" : ""];
        }//end if
    }//end if
    
    return [NSString stringWithString:buf];
}//end linkLayerNtop:

+ (BOOL)macAddress: (nonnull NSString *)addr1 isEqualTo:(nonnull NSString *)addr2 {
    struct ether_addr ether_addr1, ether_addr2;
    
    struct ether_addr *tmp;
    
    tmp = ether_aton(([addr1 UTF8String]));
    if(!tmp)
        return NO;
    memcpy(&ether_addr1, tmp, sizeof(ether_addr1));
    
    tmp = ether_aton([addr2 UTF8String]);
    if(!tmp)
        return NO;
    memcpy(&ether_addr2, tmp, sizeof(ether_addr2));
    
    return memcmp(&ether_addr1, &ether_addr2, sizeof(struct ether_addr)) == 0 ? YES : NO;
}//end macAddress: isEqualTo:

@end
