//
//  LSDeviceManagerDelegate.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol LSDeviceManagerDelegate <NSObject>
//扫描设备回掉
-(void)onDescoverDevice:(CBPeripheral*)device;
//连接设备回掉
-(void)onConnectDeviceFinished:(CBPeripheral*)device;
//断开连接设备回掉
-(void)onDisConnectDeviceFinished:(CBPeripheral*)device;
//连接设备失败回掉
-(void)onFailedToConnectDevice:(CBPeripheral*)device;

//有数据返回，这里是原始数据
-(void)onRecieveData:(NSData*)data;

@optional
//写数据回掉
-(void)onWriteDataFinished:(BOOL)success;

//todo ，还需要按照业务来分
-(void)onRecieveSteps:(NSInteger)steps;
@end
