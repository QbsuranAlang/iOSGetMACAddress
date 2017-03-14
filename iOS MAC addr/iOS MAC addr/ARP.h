//
//  ARP.h
//  iOS MAC addr
//
//  Created by TUTU on 2017/2/28.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARP : NSObject

/**
 * @return nil on error, otherwise return mac address
 */
+ (nullable NSString *)walkMACAddressOf: (nonnull NSString *)ipAddress;

/**
 * @return nil on error, otherwise return mac address
 */
+ (nullable NSString *)MACAddressOf: (nonnull NSString *)ipAddress;

@end
