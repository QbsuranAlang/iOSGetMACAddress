//
//  MDNS.m
//  iOS MAC addr
//
//  Created by TUTU on 2017/3/13.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import "MDNS.h"
#import "Address.h"
#import <resolv.h>
#import <netdb.h>

#define MDNS_PORT 5353
#define QUERY_NAME "_apple-mobdev2._tcp.local"
@implementation MDNS

+ (nullable NSString *)getMacAddressFromMDNS {
    res_init();
    
    //get currnet ip address
    NSString *ip = [Address currentIPAddressOf:@"en0"];
    if(ip == nil) {
        fprintf(stderr, "could not get current IP address of en0\n");
        return nil;
    }//end if
    
    //set port and destination
    _res.nsaddr_list[0].sin_family = AF_INET;
    _res.nsaddr_list[0].sin_port = htons(MDNS_PORT);
    _res.nsaddr_list[0].sin_addr.s_addr = [Address IPv4Pton:ip];
    _res.nscount = 1;
    
    unsigned char response[NS_PACKETSZ];
    int len;
    //send mdns query
    if((len = res_query(QUERY_NAME, ns_c_in, ns_t_ptr, response, sizeof(response))) < 0) {
        fprintf(stderr, "res_search(): %s\n", hstrerror(h_errno));
        return nil;
    }//end if
    
    //parse mdns message
    ns_msg handle;
    if(ns_initparse(response, len, &handle) < 0) {
        fprintf(stderr, "ns_initparse(): %s\n", hstrerror(h_errno));
        return nil;
    }//end if
    
    //get answer length
    len = ns_msg_count(handle, ns_s_an);
    if(len < 0) {
        fprintf(stderr, "ns_msg_count return zero\n");
        return nil;
    }//end if
    
    //try to get mac address from data
    NSString *macAddress = nil;
    for(int i = 0 ; i < len ; i++) {
        ns_rr rr;
        ns_parserr(&handle, ns_s_an, 0, &rr);
        
        if(ns_rr_class(rr) == ns_c_in &&
           ns_rr_type(rr) == ns_t_ptr &&
           !strcmp(ns_rr_name(rr), QUERY_NAME)) {
            char *ptr = (char *)(ns_rr_rdata(rr) + 1);
            int l = (int)strcspn(ptr, "@");
            
            char *tmp = calloc(l + 1, sizeof(char));
            if(!tmp) {
                perror("calloc()");
                continue;
            }//end if
            memcpy(tmp, ptr, l);
            macAddress = [NSString stringWithUTF8String:tmp];
            free(tmp);
        }//end if
    }//end for each
    
    return macAddress;
}//end getMacAddressFromMDNS

@end
