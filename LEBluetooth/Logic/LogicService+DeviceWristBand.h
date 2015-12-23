//
//  LogicService+DeviceWristBand.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "LogicService.h"
#import "LSDeviceManagerInterface.h"

@interface LogicService (DeviceWristBand)

-(id<LSDeviceManagerInterface>)getWristBandManager;
@end
