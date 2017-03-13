//
//  Address.h
//  iOS MAC addr
//
//  Created by TUTU on 2017/2/28.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <net/if_dl.h>

#define DUMMY_MAC_ADDR @"02:00:00:00:00:00"
@interface Address : NSObject

+ (nonnull NSString *)currentIPAddressOf: (nonnull NSString *)device;
+ (nullable NSString *)IPv4Ntop: (in_addr_t)addr;
+ (in_addr_t)IPv4Pton: (nonnull NSString *)IPAddr;
+ (nullable NSString *)linkLayerNtop: (nonnull struct sockaddr_dl *)sdl;
+ (BOOL)macAddress: (nonnull NSString *)addr1 isEqualTo:(nonnull NSString *)addr2;

@end
