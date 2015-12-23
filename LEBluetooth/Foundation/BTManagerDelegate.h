//
//  BTManagerDelegate.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DataModel/BluetoothModel.h"

@protocol BTManagerDelegate <NSObject>

@optional
@property (nonatomic,retain) BluetoothModel* btModel;
-(void)onCenterManagerStateChanged:(CBCentralManagerState)state;
-(void)onDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI;
-(void)onPeripheralConnected:(CBPeripheral *)peripheral;
-(void)onPeripheralFailedToConnect:(CBPeripheral *)peripheral;
-(void)onPeripheralDisConnected:(CBPeripheral *)peripheral;
@end
