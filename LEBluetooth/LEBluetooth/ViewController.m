//
//  ViewController.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "ViewController.h"
#import "LogicService.h"

@interface ViewController ()
<LSDeviceManagerDelegate>

@end

@implementation ViewController

-(void)dealloc
{
    [[LOGICSERVICE_INSTANCE getWristBandManager] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[LOGICSERVICE_INSTANCE getWristBandManager] addDelegate:self];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([[LOGICSERVICE_INSTANCE getWristBandManager] isBtPoweredOn]) {
        [[LOGICSERVICE_INSTANCE getWristBandManager] scanForDevice];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClickSearchWristBand:(id)sender
{
    if ([[LOGICSERVICE_INSTANCE getWristBandManager] isBtPoweredOn]) {
        [[LOGICSERVICE_INSTANCE getWristBandManager] scanForDevice];
    }
    else
    {
        NSLog(@"蓝牙未打开");
    }
}

#pragma mark LSDeviceManagerDelegate
-(void)onDescoverDevice:(CBPeripheral *)device
{
    self.textLog.text = [NSString stringWithFormat:@"%@\n%@ discovered",self.textLog.text,device.name];
}

-(void)onConnectDeviceFinished:(CBPeripheral *)device
{
    self.textLog.text = [NSString stringWithFormat:@"%@\n%@ connected",self.textLog.text,device.name];
}

-(void)onFailedToConnectDevice:(CBPeripheral *)device
{
    self.textLog.text = [NSString stringWithFormat:@"%@\nfailed to connect %@",self.textLog.text,device.name];
}
//断开连接设备回掉
-(void)onDisConnectDeviceFinished:(CBPeripheral*)device
{
    self.textLog.text = [NSString stringWithFormat:@"%@\n%@ disconnected",self.textLog.text,device.name];
}

-(void)onRecieveData:(NSData *)data
{
    
}
@end
