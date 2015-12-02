//
//  LinePoint.h
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, PointType) {
    Standard    = 0,
    Coalesced   = 1 << 0,
    Predicted   = 1 << 1,
    NeedsUpdate = 1 << 2,
    Updated     = 1 << 3,
    Cancelled   = 1 << 4,
    Finger      = 1 << 5,
};

@interface LinePoint : NSObject
@property (nonatomic,assign) CGFloat magnitude;
@property (nonatomic,assign) CGPoint location;
@property (nonatomic,assign) NSInteger sequenceNumber;
@property (nonatomic,assign) PointType pointType;
@property (nonatomic,assign) CGPoint preciseLocation;
@property (nonatomic,assign) CGFloat altitudeAngle;
@property (nonatomic,assign) CGFloat azimuthAngle;
@property (nonatomic,retain) NSNumber* estimationUpdateIndex;
@property (nonatomic,assign) UITouchProperties estimatedPropertiesExpectingUpdates;

-(id)init:(UITouch*)touch sequenceNumber:(NSInteger)sequenceNumber pointType:(PointType)pointType;
-(BOOL)updateWithTouch:(UITouch*)touch;
@end
