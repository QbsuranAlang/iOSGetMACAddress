//
//  ViewController.m
//  iOS MAC addr
//
//  Created by TUTU on 2017/2/28.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "Address.h"
#import "ICMP.h"
#import "ARP.h"
#import "MDNS.h"

@interface ViewController ()

@property (nonatomic, strong) Reachability *wifiReachability;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _iosVersionLabel.text = [NSString stringWithFormat:@"iOS: %@", [[UIDevice currentDevice] systemVersion]];
    
    //wifi notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _wifiReachability = [Reachability reachabilityForLocalWiFi];
    [_wifiReachability startNotifier];
    [self reachabilityChanged:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_wifiReachability stopNotifier];
}

- (void) reachabilityChanged:(NSNotification *)note {
    if(self.wifiReachability.currentReachabilityStatus == NotReachable) {
        [_getAddressButton setTitle:@"No Wi-Fi Connection" forState:UIControlStateNormal];
        [_getAddressButton setEnabled:NO];
    }//end if
    else {
        [_getAddressButton setTitle:@"Get MAC Address" forState:UIControlStateNormal];
        [_getAddressButton setEnabled:YES];
    }//end else
}

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

- (IBAction)getMacAddress:(id)sender {
    NSString *mac = nil;
    NSString *ip = [Address currentIPAddressOf:@"en0"];
    [ICMP sendICMPEchoRequestTo:ip];
    mac = [ARP walkMACAddressOf:ip];
    
    if(!mac || [Address macAddress:mac isEqualTo:DUMMY_MAC_ADDR]) {
        NSLog(@"Walk ARP table fail.\n");
        mac = [ARP MACAddressOf:ip];
    }//end if
    
    if(!mac || [Address macAddress:mac isEqualTo:DUMMY_MAC_ADDR]) {
        NSLog(@"Get ARP entry fail.\n");
        mac = [MDNS getMacAddressFromMDNS];
    }//end if
    
    _macAddressLabel.text = [NSString stringWithFormat:@"MAC Address: %@",
                             mac ? mac : @"Not Found"];
}
@end
