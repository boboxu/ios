//
//  LSDeviceManager.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "LSDeviceManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface LSDeviceManager()
{
    CBPeripheral* _device;
    BTManager* _btManager;
}

@end

@implementation LSDeviceManager
@synthesize btModel;

-(id)init
{
    self = [super init];
    if (self) {
        [self initBlueToothModel];
        _btManager = [BTManager shareInstance];
        [_btManager addDelegate:self];
    }
    return self;
}

-(void)dealloc
{
    [_btManager removeDelegate:self];
}

#pragma mark Interface
-(void)initBlueToothModel
{
    //子类实现
}

-(void)scanForDevice
{
    NSArray* uuids = @[[CBUUID UUIDWithString:self.btModel.serviceUUID]];
    NSArray* devices = [_btManager getConnectedPeripherals:uuids];
    if (devices !=nil && devices.count != 0) {
        _device = devices[0];
        [self _connect];
    }
    else
    {
        [_btManager scanForPeripherals:uuids];
    }
}

-(NSArray*)getConnectedPeripherals;
{
    return [_btManager getConnectedPeripherals:@[[CBUUID UUIDWithString:self.btModel.serviceUUID]]];
}

-(BOOL)isBtPoweredOn
{
    return [_btManager isBtPoweredOn];
}

#pragma mark BTManagerDelegate
-(void)onCenterManagerStateChanged:(CBCentralManagerState)state
{
    switch (state) {
        case CBCentralManagerStateUnknown:
        {
            //未知
        }

            break;
        case CBCentralManagerStateResetting:
            
            break;
        case CBCentralManagerStateUnsupported:
            
            break;
        case CBCentralManagerStateUnauthorized:
            
            break;
        case CBCentralManagerStatePoweredOff:
            
            break;
        case CBCentralManagerStatePoweredOn:
        {
            [self scanForDevice];
        }
            break;
        default:
            
            break;
    }

}

-(void)onDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI
{
    _device = peripheral;
    [self _connect];
    
    for (id<LSDeviceManagerDelegate> delegate in [self getAllDelegates]) {
        if ([delegate respondsToSelector:@selector(onDescoverDevice:)]) {
            [delegate onDescoverDevice:peripheral];
        }
    }
}

-(void)onPeripheralConnected:(CBPeripheral *)peripheral
{
    for (id<LSDeviceManagerDelegate> delegate in [self getAllDelegates]) {
        if ([delegate respondsToSelector:@selector(onConnectDeviceFinished:)]) {
            [delegate onConnectDeviceFinished:peripheral];
        }
    }
}

-(void)onPeripheralDisConnected:(CBPeripheral *)peripheral
{
    for (id<LSDeviceManagerDelegate> delegate in [self getAllDelegates]) {
        if ([delegate respondsToSelector:@selector(onDisConnectDeviceFinished:)]) {
            [delegate onDisConnectDeviceFinished:peripheral];
        }
    }
}

-(void)onPeripheralFailedToConnect:(CBPeripheral *)peripheral
{
    for (id<LSDeviceManagerDelegate> delegate in [self getAllDelegates]) {
        if ([delegate respondsToSelector:@selector(onFailedToConnectDevice:)]) {
            [delegate onFailedToConnectDevice:peripheral];
        }
    }
}
#pragma mark private
-(void)_connect
{
    [_btManager connectPeripheral:_device];
}

@end
