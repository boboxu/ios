//
//  Line.m
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "Line.h"


@interface Line()
@property NSMutableArray* points;
@property NSMutableDictionary* pointsWaitingForUpdatesByEstimationIndex;
@property NSMutableArray* committedPoints;
@end

@implementation Line

-(id)init
{
    self = [super init];
    if (self) {
        self.points = [NSMutableArray array];
    }
    return self;
}

-(BOOL) isComplete
{
    return self.pointsWaitingForUpdatesByEstimationIndex.count == 0;
}

-(CGRect)updateWithTouch:(UITouch*)touch
{
    if (touch.estimationUpdateIndex) {
        NSNumber* estimationUpdateIndex = touch.estimationUpdateIndex;
        LinePoint* point = self.pointsWaitingForUpdatesByEstimationIndex[estimationUpdateIndex];
        if (point) {
            CGRect rect = [self updateRectForExistingPoint:point];
            BOOL didUpdate = [point updateWithTouch:touch];
            if (didUpdate) {
                rect = CGRectUnion(rect, [self updateRectForExistingPoint:point]);
            }
            if ([point estimatedPropertiesExpectingUpdates] == 0 ) {
                [self.pointsWaitingForUpdatesByEstimationIndex removeObjectForKey:estimationUpdateIndex];
            }
            return rect;
        }
    }
    return CGRectNull;
}

#pragma mark Interface
-(CGRect)addPointOfType:(PointType)pointType forTouch:(UITouch*)touch
{
    LinePoint* previousPoint = self.points.lastObject;
    NSInteger previousSequenceNumber = previousPoint.sequenceNumber ? previousPoint.sequenceNumber:-1;
    LinePoint* point = [[LinePoint alloc] init:touch sequenceNumber:previousSequenceNumber+1 pointType:pointType];
    
    if(point.estimationUpdateIndex)
    {
        NSNumber* estimationIndex = point.estimationUpdateIndex;
        if (point.estimatedPropertiesExpectingUpdates != 0) {
            self.pointsWaitingForUpdatesByEstimationIndex[estimationIndex] = point;
        }
    }
    
    [self.points addObject:point];
    
    CGRect updateRect = [self updateRectForLinePoint:point previousPoint:previousPoint];
    return updateRect;
}

-(CGRect)removePointsWithType:(PointType)pointType
{
    CGRect updateRect = CGRectNull;
    LinePoint* priorPoint;
    
    //refresh points array
    NSMutableArray* tmppoints = [NSMutableArray array];
    for(LinePoint* point in self.points)
    {
        BOOL keepPoint = !(point.pointType & pointType);
        if (!keepPoint) {
            CGRect rect = [self updateRectForLinePoint:point];
            
            if (priorPoint) {
                rect = CGRectUnion(rect, [self updateRectForLinePoint:priorPoint]);
            }
            
            updateRect = CGRectUnion(updateRect, rect);
        }
        else
        {
            [tmppoints addObject:point];
        }
        priorPoint = point;
    }
    
    [self.points removeAllObjects];
    [self.points addObjectsFromArray:tmppoints];
    
    
    return updateRect;
}

-(CGRect)cancel
{
    CGRect ret = CGRectNull;
    for (LinePoint* point in self.points) {
        point.pointType |= Cancelled;
        ret = CGRectUnion(ret, [self updateRectForLinePoint:point]);
    }
    return ret;
    
}

#pragma mark Drawing
-(void) drawInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled usePreciseLocation:(BOOL)usePreciseLocation
{
    LinePoint* maybePriorPoint;
    NSInteger i = self.points.count;
    if(i == 3)
    {
        
    }
    for(LinePoint* point in self.points)
    {
        LinePoint* priorPoint;
        if (maybePriorPoint) {
            priorPoint = maybePriorPoint;
        }
        else
        {
            maybePriorPoint = point;
            continue;
        }
        
        // This color will used by default for `.Standard` touches.
        UIColor* color = [UIColor blackColor];
        
        PointType pointType = point.pointType;
        if (isDebuggingEnabled) {
            if (pointType & Cancelled) {
                color = [UIColor redColor];
            }
            else if (pointType & NeedsUpdate) {
                color = [UIColor orangeColor];
            }
            else if (pointType & Finger) {
                color = [UIColor purpleColor];
            }
            else if (pointType & Coalesced) {
                color = [UIColor greenColor];
            }
            else if (pointType& Predicted) {
                color = [UIColor blueColor];
            }
        } else {
            if (pointType& Cancelled) {
                color = [UIColor clearColor];
            }
            else if (pointType& Finger) {
                color = [UIColor purpleColor];
            }
            if ((pointType& Predicted) && !(pointType & Cancelled)) {
                color = [color colorWithAlphaComponent:0.5];
            }
        }
        
        CGPoint location = usePreciseLocation ? point.preciseLocation : point.location;
        CGPoint priorLocation = usePreciseLocation ? priorPoint.preciseLocation : priorPoint.location;
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, priorLocation.x, priorLocation.y);
        CGContextAddLineToPoint(context, location.x, location.y);
        
        CGContextSetLineWidth(context, point.magnitude);
        CGContextStrokePath(context);
        
//        NSLog(@"%f %f %f %f",priorLocation.x,priorLocation.y,location.x,location.y);
        // Draw azimuith and elevation on all non-coalesced points when debugging.
        if (isDebuggingEnabled && !(pointType & Coalesced) && !(pointType & Predicted) && !(pointType & Finger))
        {
            CGContextBeginPath(context);
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            CGContextSetLineWidth(context, 0.5);
            CGContextMoveToPoint(context, location.x, location.y);
            CGPoint targetPoint = CGPointMake(0.5 + 10.0 * cos(point.altitudeAngle), 0.0);
            targetPoint = CGPointApplyAffineTransform(targetPoint, CGAffineTransformMakeRotation(point.azimuthAngle));
            targetPoint.x += location.x;
            targetPoint.y += location.y;
            CGContextAddLineToPoint(context, targetPoint.x, targetPoint.y);
            CGContextStrokePath(context);
        }
        
        maybePriorPoint = point;
    }
}

-(void)drawFixedPointsInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled  usePreciseLocation:(BOOL)usePreciseLocation
{
    [self drawFixedPointsInContext:context isDebuggingEnabled:isDebuggingEnabled usePreciseLocation:usePreciseLocation commitAll:NO];
}

-(void)drawFixedPointsInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled  usePreciseLocation:(BOOL)usePreciseLocation  commitAll:(BOOL)commitAll
{
    NSMutableArray* allPoints = self.points;
    NSMutableArray* committing = [NSMutableArray array];
    
    if (commitAll)
    {
        committing = allPoints;
        [self.points removeAllObjects];
    }
    else
    {
        for (int index = 0; index < self.points.count; index++) {
            // Only points whose type does not include `.NeedsUpdate` or `.Predicted` and are not last or prior to last point can be committed.
            LinePoint* point = self.points[index];
            PointType includetype = (point.pointType & NeedsUpdate) | (point.pointType & Predicted);
            BOOL has = includetype == 0;
            if (has && (index < (int)(allPoints.count - 2))) {
                
            }
            else
            {
                [committing addObject:self.points.firstObject];
                break;
            }
            
            if (index > 0) {
                
            }
            else
            {
                continue;
            }
            
            // First time to this point should be index 1 if there is a line segment that can be committed.
            LinePoint* removed = self.points[0];
            [self.points removeObjectAtIndex:0];
            [committing addObject:removed];
        }
        
   
        
        
        // If only one point could be committed, no further action is required. Otherwise, draw the `committedLine`.
        if (committing.count > 1) {
            
        }
        else
        {
            return;
        }
        
        Line* committedLine = [Line new];
        committedLine.points = committing;
        [committedLine drawInContext:context isDebuggingEnabled:isDebuggingEnabled usePreciseLocation:usePreciseLocation];
        
        if (self.committedPoints.count > 0) {
            // Remove what was the last point committed point; it is also the first point being committed now.
            [self.committedPoints removeLastObject];
        }
        // Store the points being committed for redrawing later in a different style if needed.
        [self.committedPoints addObjectsFromArray:committing];
    }
}

-(void)drawCommitedPointsInContext:(CGContextRef)context isDebuggingEnabled:(BOOL)isDebuggingEnabled  usePreciseLocation:(BOOL)usePreciseLocation
{
    Line* committedLine = [Line new];
    committedLine.points = self.committedPoints;
    [committedLine drawInContext:context isDebuggingEnabled:isDebuggingEnabled usePreciseLocation:usePreciseLocation];
}

#pragma mark Convenience

-(CGRect)updateRectForLinePoint:(LinePoint*)point
{
    CGRect rect = CGRectMake(point.location.x, point.location.y, 0.0f, 0.0f);
    CGFloat magnitude = -3* point.magnitude - 2;
    rect = CGRectInset(rect, magnitude, magnitude);
    return rect;
}

-(CGRect)updateRectForLinePoint:(LinePoint*)point  previousPoint:(LinePoint*)optionalPreviousPoint
{
    CGRect rect = CGRectMake(point.location.x, point.location.y, 0.0f, 0.0f);
    CGFloat pointMagnitude = point.magnitude;
    
    if (optionalPreviousPoint) {
        pointMagnitude = MAX(pointMagnitude, optionalPreviousPoint.magnitude);
        rect = CGRectUnion(rect, CGRectMake(optionalPreviousPoint.location.x, optionalPreviousPoint.location.y, 0.0f, 0.0f));
    }
    
    CGFloat magnitude = - 3.0*pointMagnitude - 2.0;
    rect = CGRectInset(rect, magnitude, magnitude);
    return rect;
}

-(CGRect)updateRectForExistingPoint:(LinePoint*)point
{
    CGRect rect = [self updateRectForLinePoint:point];
    
    NSInteger arrayIndex = point.sequenceNumber - ((LinePoint*)self.points.firstObject).sequenceNumber;
    if (arrayIndex > 0) {
        rect = CGRectUnion(rect, [self updateRectForLinePoint:point previousPoint:self.points[arrayIndex - 1]]);
    }
    if (arrayIndex + 1 < self.points.count) {
        rect = CGRectUnion(rect, [self updateRectForLinePoint:point previousPoint:self.points[arrayIndex + 1]]);
    }
    return rect;
}

@end
