//
//  ViewController.h
//  iOS MAC addr
//
//  Created by TUTU on 2017/2/28.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *iosVersionLabel;
- (IBAction)getMacAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getAddressButton;

@property (weak, nonatomic) IBOutlet UILabel *macAddress1Label;
@property (weak, nonatomic) IBOutlet UILabel *macAddress2Label;
@property (weak, nonatomic) IBOutlet UILabel *macAddress3Label;




@end

