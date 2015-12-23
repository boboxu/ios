//
//  LogicManagerBase.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "LogicManagerBase.h"

@implementation LogicManagerBase
static LogicManagerBase* gInstance;

+(instancetype)shareInstance
{
    if (gInstance == nil) {
        Class cls = [self class];
        gInstance = [[cls alloc] init];
    }
    return gInstance;
}
@end
