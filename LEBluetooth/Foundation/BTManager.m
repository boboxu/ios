//
//  BTManager.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "BTManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BTManager()
<CBCentralManagerDelegate>
{
    CBCentralManager* _centralManager;
    NSMutableArray* _delegateArray;
    
}

@end

@implementation BTManager

static BTManager* gInstance;
+(BTManager*)shareInstance
{
    if (gInstance == nil) {
        gInstance = [BTManager new];
    }
    return gInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
        _delegateArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%ld",central.state);
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            
            break;
        case CBCentralManagerStateResetting:
            
            break;
        case CBCentralManagerStateUnsupported:
            
            break;
        case CBCentralManagerStateUnauthorized:
            
            break;
        case CBCentralManagerStatePoweredOff:
        {
            gInstance = nil;
        }
            break;
        case CBCentralManagerStatePoweredOn:
            
            break;
        default:
            
            break;
    }
    
//    //状态变化，通知全世界 比如蓝牙开关之类的
//    for (id<BTManagerDelegate> delegate in _delegateArray) {
//        if ([delegate respondsToSelector:@selector(onCenterManagerStateChanged:)]) {
//            [delegate onCenterManagerStateChanged:central.state];
//        }
//    }

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //找到了外设，通知对应的逻辑
    for (id<BTManagerDelegate> delegate in _delegateArray) {
        if ([self _isDelegateFit:delegate peripheral:peripheral] && [delegate respondsToSelector:@selector(onDiscoverPeripheral:RSSI:)]) {
            [_centralManager stopScan];
            [delegate onDiscoverPeripheral:peripheral RSSI:RSSI];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    for (id<BTManagerDelegate> delegate in _delegateArray) {
        if ([self _isDelegateFit:delegate peripheral:peripheral] && [delegate respondsToSelector:@selector(onPeripheralConnected:)]) {
            [delegate onPeripheralConnected:peripheral];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    for (id<BTManagerDelegate> delegate in _delegateArray) {
        if ([self _isDelegateFit:delegate peripheral:peripheral] && [delegate respondsToSelector:@selector(onPeripheralFailedToConnect:)]) {
            [delegate onPeripheralFailedToConnect:peripheral];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    for (id<BTManagerDelegate> delegate in _delegateArray) {
        if ([self _isDelegateFit:delegate peripheral:peripheral] && [delegate respondsToSelector:@selector(onPeripheralDisConnected:)]) {
            [delegate onPeripheralDisConnected:peripheral];
        }
    }
}
#pragma mark BTManagerInterface

-(void)connectPeripheral:(CBPeripheral *)device
{
    [_centralManager connectPeripheral:device options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                                        CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                                        CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES
                                                        }];
}

-(void)scanForPeripherals:(NSArray*)serviceUUIDs
{
    if (!_centralManager.isScanning) {
        [_centralManager scanForPeripheralsWithServices:serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
    }
}

-(void)scanForServices
{
    [peripheral discoverServices:@[[CBUUID UUIDWithString:self.infoModel.serviceUUID]]];
}

-(NSArray*)getConnectedPeripherals:(NSArray*)serviceUUIDs
{
    return [_centralManager retrieveConnectedPeripheralsWithServices:serviceUUIDs];
}

-(BOOL)isBtPoweredOn
{
    return _centralManager.state == CBCentralManagerStatePoweredOn;
}

-(void)addDelegate:(id<BTManagerDelegate>)delegate
{
    [_delegateArray addObject:delegate];
}

-(void)removeDelegate:(id<BTManagerDelegate>)delegate
{
    [_delegateArray removeObject:delegate];
}

#pragma mark private 
-(BOOL)_isDelegateFit:(id<BTManagerDelegate>)delegate peripheral:(CBPeripheral*)peripheral
{
    BOOL ret = [delegate respondsToSelector:@selector(btModel)];
    if (ret) {
        ret &= [delegate.btModel.serviceName isEqualToString:peripheral.name];
    }
    return ret;
}
@end
