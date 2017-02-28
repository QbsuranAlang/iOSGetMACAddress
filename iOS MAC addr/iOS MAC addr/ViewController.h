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
@property (weak, nonatomic) IBOutlet UILabel *macAddressLabel;
- (IBAction)getMacAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getAddressButton;


@end

