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

- (IBAction)getMacAddress:(id)sender {
    NSString *mac = nil;
    NSString *ip = [Address currentIPAddressOf:@"en0"];
    
    //way 1
    [ICMP sendICMPEchoRequestTo:ip];
    mac = [ARP walkMACAddressOf:ip];
    _macAddress1Label.text = [NSString stringWithFormat:@"(Way1)MAC Address: %@",
                             mac ? mac : @"Not Found"];
    
    //way 2
    [ICMP sendICMPEchoRequestTo:ip]; //just for way2 regular steps
    mac = [ARP MACAddressOf:ip];
    _macAddress2Label.text = [NSString stringWithFormat:@"(Way2)MAC Address: %@",
                              mac ? mac : @"Not Found"];
    
    //way 3
    mac = [MDNS getMacAddressFromMDNS];
    _macAddress3Label.text = [NSString stringWithFormat:@"(Way3)MAC Address: %@",
                              mac ? mac : @"Not Found"];
}
@end
