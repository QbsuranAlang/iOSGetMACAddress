//
//  ICMP.m
//  iOS MAC addr
//
//  Created by TUTU on 2017/2/28.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import "ICMP.h"
#import <sys/socket.h>
#import <netinet/ip.h>
#import <netinet/ip_icmp.h>
#import "Address.h"
#import <errno.h>

@implementation ICMP

static u_int16_t checksum(u_int16_t *data, int len);

+ (void)sendICMPEchoRequestTo: (nonnull NSString *)ipAddress {
    int s = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
    
    if(s < 0) {
        perror("socket()");
        return;
    }//end if
    
    char buffer[256];
    struct icmp *icmp = (struct icmp *)buffer;
    
    //fill icmp header
    memset(buffer, 0, sizeof(buffer));
    icmp->icmp_type = ICMP_ECHO;
    icmp->icmp_code = 0;
    icmp->icmp_seq = arc4random();
    icmp->icmp_id = arc4random();
    icmp->icmp_cksum = 0;
    icmp->icmp_cksum = checksum((u_int16_t *)buffer, sizeof(buffer));
    
    //fill destination address
    struct sockaddr_in dest;
    memset(&dest, 0, sizeof(dest));
    dest.sin_family = AF_INET;
    dest.sin_addr.s_addr = [Address IPv4Pton:ipAddress];
    dest.sin_len = sizeof(dest);
    
    if(sendto(s, buffer, sizeof(buffer), 0, (struct sockaddr *)&dest, sizeof(dest)) < 0) {
        perror("sendto()");
    }//end if
    
    close(s);
}//end sendICMPEchoRequestTo:

static u_int16_t checksum(u_int16_t *data, int len) {
    u_int32_t sum = 0;
    
    for (; len > 1; len -= 2) {
        sum += *data++;
        if (sum & 0x80000000)
            sum = (sum & 0xffff) + (sum >> 16);
    }
    
    if (len == 1) {
        u_int16_t i = 0;
        *(u_char*) (&i) = *(u_char *) data;
        sum += i;
    }
    
    while (sum >> 16)
        sum = (sum & 0xffff) + (sum >> 16);
    
    return ~sum;
}

@end
