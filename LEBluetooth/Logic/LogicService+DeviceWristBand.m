//
//  LogicService+DeviceWristBand.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "LogicService+DeviceWristBand.h"
#import "WristbandManager.h"

@implementation LogicService (DeviceWristBand)

-(id<LSDeviceManagerInterface>)getWristBandManager
{
    return [WristbandManager shareInstance];
}

@end
