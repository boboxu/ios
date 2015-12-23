//
//  BTManagerInterface.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTManagerDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BTManagerInterface <NSObject>
-(void)addDelegate:(id<BTManagerDelegate>)delegate;
-(void)removeDelegate:(id<BTManagerDelegate>)delegate;

-(void)scanForPeripherals:(NSArray*)serviceUUIDs;
-(void)scanForServices:()
-(NSArray*)getConnectedPeripherals:(NSArray*)serviceUUIDs;
-(void)connectPeripheral:(CBPeripheral*)device;
-(BOOL)isBtPoweredOn;
@end
