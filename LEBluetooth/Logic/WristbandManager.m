//
//  WristbandManager.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "WristbandManager.h"
#import "BlueToothDefine.h"

@implementation WristbandManager

-(void)initBlueToothModel
{
    self.btModel = [BluetoothModel new];
    self.btModel.serviceName = WRISTBAND_SERVICE_NAME;
    self.btModel.serviceUUID = WRISTBAND_SERVICE_UUID;
    self.btModel.readCharatUUID = WRISTBAND_RECEIVE_UUID;
    self.btModel.writeCharatUUID = WRISTBAND_SEND_UUID;
}
@end
