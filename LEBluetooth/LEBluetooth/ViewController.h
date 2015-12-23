//
//  ViewController.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textLog;
-(IBAction)onClickSearchWristBand:(id)sender;
@end

