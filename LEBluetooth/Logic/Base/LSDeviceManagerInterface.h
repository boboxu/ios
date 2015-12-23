//
//  LSDeviceManagerInterface.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BluetoothModel.h"
#import "LSDeviceManagerDelegate.h"
#import "MultiDelegateManagerInterface.h"

@protocol LSDeviceManagerInterface <MultiDelegateManagerInterface>
-(void)scanForDevice;
-(void)initBlueToothModel; //abstract function
-(BOOL)isBtPoweredOn;
-(NSArray*)getConnectedPeripherals;
@end
