//
//  LinePoint.m
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "LinePoint.h"

@interface LinePoint()
@property (nonatomic,assign) NSTimeInterval timestamp;
@property (nonatomic,assign) CGFloat force;
@property (nonatomic,assign) UITouchProperties estimatedProperties;
@property (nonatomic,assign) UITouchType type;

@end

@implementation LinePoint

-(CGFloat)magnitude
{
    return MAX(self.force, 0.025);
}

-(id)init:(UITouch *)touch sequenceNumber:(NSInteger)sequenceNumber pointType:(PointType)pointType
{
    self = [super init];
    if (self) {
        self.sequenceNumber = sequenceNumber;
        self.type = touch.type;
        self.pointType = pointType;
        
        self.timestamp = touch.timestamp;
        UIView* view = touch.view;
        self.location = [touch locationInView:view];
        self.preciseLocation = [touch preciseLocationInView:view];
        self.azimuthAngle = [touch azimuthAngleInView:view];
        self.estimatedProperties = [touch estimatedProperties];
        self.estimatedPropertiesExpectingUpdates = touch.estimatedPropertiesExpectingUpdates;
        self.altitudeAngle = touch.altitudeAngle;
        
        
//        NSLog(@"%f %f %f %f",self.preciseLocation.x,self.preciseLocation.y,self.location.x,self.location.y);
        
        if(self.type == UITouchTypeStylus || touch.force > 0 )
        {
            self.force = touch.force;
        }
        else
        {
            self.force = 1.0;
        }
        
        if (self.estimatedPropertiesExpectingUpdates != 0) {
            self.pointType |= NeedsUpdate;
        }
        
        self.estimationUpdateIndex = touch.estimationUpdateIndex;
    }
    return self;
}

-(BOOL)updateWithTouch:(UITouch*)touch
{
    self.estimationUpdateIndex = touch.estimationUpdateIndex;
    NSArray* touchProperties = @[@(UITouchPropertyAltitude),
                                 @(UITouchPropertyAzimuth),
                                 @(UITouchPropertyForce),
                                 @(UITouchPropertyLocation)];
    
    for (NSNumber* expectedProperty in touchProperties)
    {
        if (self.estimatedPropertiesExpectingUpdates & [expectedProperty intValue])
        {
            switch([expectedProperty intValue])
            {
                case UITouchPropertyForce:
                    self.force = touch.force;
                    break;
                case UITouchPropertyAzimuth:
                    self.azimuthAngle = [touch azimuthAngleInView:touch.view];
                    break;
                case UITouchPropertyAltitude:
                    self.altitudeAngle = touch.altitudeAngle;
                    break;
                case UITouchPropertyLocation:
                    self.location = [touch locationInView:touch.view];
                    self.preciseLocation = [touch preciseLocationInView:touch.view];
                    break;
                default:
                    break;
            }
            
            if(!(touch.estimatedProperties & [expectedProperty intValue]))
            {
                self.estimatedProperties ^= [expectedProperty intValue];
            }

            if (!(touch.estimatedPropertiesExpectingUpdates & [expectedProperty intValue])) {
                // Flag that this point is no longer expecting updates for this property.
                self.estimatedPropertiesExpectingUpdates ^= [expectedProperty intValue];
                
                if(self.estimatedPropertiesExpectingUpdates == 0) {
                    // Flag that this point has been updated and no longer needs updates.
                    self.pointType ^= NeedsUpdate;
                    self.pointType |= Updated;
                }
            }
        }
        else
            continue;
    }
    return true;
}
@end
