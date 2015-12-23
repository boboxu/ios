//
//  LogicService.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGICSERVICE_INSTANCE [LogicService sharedInstance]

@interface LogicService : NSObject

+(instancetype)sharedInstance;
@end


#import "LogicService+DeviceWristBand.h"

