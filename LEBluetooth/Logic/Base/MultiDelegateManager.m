//
//  MultiDelegateManager.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "MultiDelegateManager.h"

@interface MultiDelegateManager()
{
    NSMutableArray* _delegateArray;
}
@end

@implementation MultiDelegateManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        _delegateArray = [NSMutableArray array];
    }
    return self;
}

-(void)addDelegate:(id)delegate
{
    [_delegateArray addObject:delegate];
}

-(void)removeDelegate:(id)delegate
{
    [_delegateArray removeObject:delegate];
}

-(NSArray*)getAllDelegates
{
    return _delegateArray;
}
@end
