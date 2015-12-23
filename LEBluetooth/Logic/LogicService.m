//
//  LogicService.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "LogicService.h"

@implementation LogicService
static LogicService* gInstance;

+(instancetype)sharedInstance
{
    if (gInstance ==nil) {
        gInstance = [LogicService new];
    }
    return gInstance;
}

@end
