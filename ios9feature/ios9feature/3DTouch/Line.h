//
//  Line.h
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinePoint.h"

@interface Line : NSObject
-(BOOL) isComplete;
-(CGRect)updateWithTouch:(UITouch*)touch;

-(void)drawFixedPointsInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled  usePreciseLocation:(BOOL)usePreciseLocation;
-(void)drawFixedPointsInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled  usePreciseLocation:(BOOL)usePreciseLocation  commitAll:(BOOL)commitAll;
-(void)drawCommitedPointsInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled  usePreciseLocation:(BOOL)usePreciseLocation;
-(void)drawInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled usePreciseLocation:(BOOL)usePreciseLocation;

-(CGRect)addPointOfType:(PointType)pointType forTouch:(UITouch*)touch;
-(CGRect)removePointsWithType:(PointType)pointType;
-(CGRect)cancel;
@end
