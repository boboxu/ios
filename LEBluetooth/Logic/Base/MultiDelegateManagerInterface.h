//
//  MultiDelegateManagerInterface.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MultiDelegateManagerInterface <NSObject>

-(void)addDelegate:(id)delegate;
-(void)removeDelegate:(id)delegate;
-(NSArray*)getAllDelegates;
@end
