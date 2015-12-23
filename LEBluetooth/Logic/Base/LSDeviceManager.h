//
//  LSDeviceManager.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDeviceManagerDelegate.h"
#import "LSDeviceManagerInterface.h"
#import "MultiDelegateManager.h"
#import "BTManager.h"

@interface LSDeviceManager : MultiDelegateManager
<LSDeviceManagerInterface,BTManagerDelegate>

@end
