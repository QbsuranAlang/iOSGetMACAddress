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
    NSString *ip = [Address currentIPAddressOf:@"en0"];
    NSLog(@"%@", ip);
    [ICMP sendICMPEchoRequestTo:ip];
    NSString *mac = [ARP macAddressOf:ip];
    NSLog(@"%@", mac);
    _macAddressLabel.text = [NSString stringWithFormat:@"MAC Address: %@",
                             mac ? mac : @"Not Found"];
}
@end
