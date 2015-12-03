//
//  touchview.m
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "TouchView.h"
#import "Line.h"
@interface TouchView()

@property (nonatomic,assign) BOOL isPredictionEnabled ;
@property (nonatomic,assign) BOOL isTouchUpdatingEnabled;
@property (nonatomic,assign) BOOL usePreciseLocations;
@property (nonatomic,assign) BOOL needsFullRedraw;
@property (nonatomic,assign) BOOL isDebuggingEnabled;
@property (nonatomic,retain) NSMutableDictionary* activeLines;
@property (nonatomic,retain) NSMutableDictionary* pendingLines;
@property (nonatomic,retain) NSMutableArray* lines;
@property (nonatomic,retain) NSMutableArray* finishedLines;
@property (nonatomic,assign) CGImageRef frozenImage;
@property (nonatomic,assign) CGContextRef frozenContext;
@end

@implementation TouchView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.activeLines = [NSMutableDictionary dictionary];
        self.pendingLines = [NSMutableDictionary dictionary];
        self.lines = [NSMutableArray array];
        self.finishedLines = [NSMutableArray array];
        self.isTouchUpdatingEnabled = YES;
        self.isPredictionEnabled = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
        self.needsFullRedraw = true;
        self.multipleTouchEnabled = YES;
    }
    return self;
}

-(void)setUsePreciseLocations:(BOOL)usePreciseLocations
{
    _usePreciseLocations = usePreciseLocations;
    self.needsFullRedraw = true;
    [self setNeedsDisplay];
}

-(void)setIsDebuggingEnabled:(BOOL)isDebuggingEnabled
{
    _isDebuggingEnabled = isDebuggingEnabled;
    self.needsFullRedraw = true;
    [self setNeedsDisplay];
}

-(CGContextRef) frozenContext
{
    if (_frozenContext == nil) {
        short scale = self.window.screen.scale;
        CGSize size = self.bounds.size;
        
        size.width *= scale;
        size.height *= scale;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        _frozenContext = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
        
        CGColorSpaceRelease(colorSpace);
        CGContextSetLineCap(_frozenContext, kCGLineCapRound);
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        CGContextConcatCTM(_frozenContext, transform);
    }
    return _frozenContext;
}

-(CGImageRef) frozenImage
{
    if (_frozenImage == nil) {
        
        _frozenImage = CGBitmapContextCreateImage([self frozenContext]);
    }
    return _frozenImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/





#pragma mark override
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self drawTouches:touches withEvent:event];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self drawTouches:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self drawTouches:touches withEvent:event];
    [self endTouches:touches cancel:NO];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!touches) {
        return;
    }
    [self endTouches:touches cancel:YES];
}

-(void)touchesEstimatedPropertiesUpdated:(NSSet *)touches
{
    [self updateEstimatedPropertiesForTouches:touches];
}

#pragma mark Drawing
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if (self.needsFullRedraw) {
        [self setFrozenImageNeedsUpdate];
        CGContextClearRect(self.frozenContext, self.bounds);
        
        for (Line* line in self.finishedLines) {
            [line drawCommitedPointsInContext:[self frozenContext] isDebuggingEnabled:self.isDebuggingEnabled usePreciseLocation:self.usePreciseLocations];
        }
        
        for (Line* line in self.lines) {
            [line drawCommitedPointsInContext:[self frozenContext] isDebuggingEnabled:self.isDebuggingEnabled usePreciseLocation:self.usePreciseLocations];
        }
        
        self.needsFullRedraw = NO;
    }
    
    
    CGContextDrawImage(context, self.bounds, self.frozenImage);
    
    for(Line* line in self.lines)
    {
        [line drawInContext:context isDebuggingEnabled:self.isDebuggingEnabled usePreciseLocation:self.usePreciseLocations];
    }
}

-(void) setFrozenImageNeedsUpdate
{
    CGImageRelease(_frozenImage);
    _frozenImage = nil;
}

#pragma mark Actions
-(void) clear {
    [self.activeLines removeAllObjects];
    [self.pendingLines removeAllObjects];
    [self.lines removeAllObjects];
    [self.finishedLines removeAllObjects];
    self.needsFullRedraw = true;
    [self setNeedsDisplay];
}

#pragma mark Convenience

-(void)drawTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent*)event
{
    CGRect updateRect = CGRectNull;
    for (UITouch* touch in touches)
    {
        // Retrieve a line from `activeLines`. If no line exists, create one.
        Line* line = [self.activeLines objectForKey:[NSValue valueWithNonretainedObject:touch]];
        if (line == nil) {
            line = [self addActiveLineForTouch:touch];
        }
        
        /*
         Remove prior predicted points and update the `updateRect` based on the removals. The touches
         used to create these points are predictions provided to offer additional data. They are stale
         by the time of the next event for this touch.
         */
        updateRect = CGRectUnion(updateRect, [line removePointsWithType:Predicted]);
        
        /*
         Incorporate coalesced touch data. The data in the last touch in the returned array will match
         the data of the touch supplied to `coalescedTouchesForTouch(_:)`
         */
        NSArray <UITouch *>* coalescedTouches = event?[event coalescedTouchesForTouch:touch]:@[];
        CGRect coalescedRect = [self addPointsOfType:Coalesced forTouches:coalescedTouches toLine:line currentUpdateRect:updateRect];
        updateRect = CGRectUnion(updateRect, coalescedRect);
        
        /*
         Incorporate predicted touch data. This sample draws predicted touches differently; however,
         you may want to use them as inputs to smoothing algorithms rather than directly drawing them.
         Points derived from predicted touches should be removed from the line at the next event for
         this touch.
         */
        if (self.isPredictionEnabled)
        {
            NSArray <UITouch *>* predictedTouches = event?[event predictedTouchesForTouch:touch]:@[];
            CGRect predictedRect = [self addPointsOfType:Predicted forTouches:predictedTouches toLine:line currentUpdateRect:updateRect];
            updateRect = CGRectUnion(updateRect, predictedRect);
        }
    }
    
    [self setNeedsDisplayInRect:updateRect];
}

-(Line*) addActiveLineForTouch:(UITouch*)touch
{
    Line* newLine = [Line new];
    
    [self.activeLines setObject:newLine forKey:[NSValue valueWithNonretainedObject:touch]];
    
    [self.lines addObject:newLine];
    
    return newLine;
}

-(CGRect)addPointsOfType:(PointType)type forTouches:(NSArray*)touches toLine:(Line*)line currentUpdateRect:(CGRect)updateRect
{
    CGRect accumulatedRect = CGRectNull;
    
    for (int idx = 0; idx < touches.count; idx++) {
        UITouch* touch = touches[idx];
        UITouchType isStylus;
        if (touch.type == UITouchTypeStylus) {
            isStylus = UITouchTypeStylus;
        }
        
        if (isStylus != UITouchTypeStylus) {
            type |= Finger;
        }
        
        if (self.isTouchUpdatingEnabled && touch.estimatedProperties != 0) {
            type |= NeedsUpdate;
        }
        
        if ((type & Coalesced) && (idx == touches.count - 1))
        {
            type ^= Coalesced;
            type |= Standard;
        }
        
        CGRect touchRect = [line addPointOfType:type forTouch:touch];
        accumulatedRect = CGRectUnion(accumulatedRect, touchRect);
        
        [self commitLine:line];
    }
    return  CGRectUnion(updateRect, accumulatedRect);
}

-(void)endTouches:(NSSet<UITouch *> *)touches cancel:(BOOL)cancel
{
    CGRect updateRect = CGRectNull;
    
    for (UITouch* touch in touches) {
        Line* line = [self.activeLines objectForKey:[NSValue valueWithNonretainedObject:touch]];
        if (!line) {
            continue;
        }
        if (cancel) {
            updateRect = CGRectUnion(updateRect, [line cancel]);
        }
            
        if ([line isComplete] || !self.isTouchUpdatingEnabled) {
            [self finishLine:line];
        }
        else
        {
            [self.pendingLines setObject:line forKey:[NSValue valueWithNonretainedObject:touch]];
        }
        
        [self.activeLines removeObjectForKey:[NSValue valueWithNonretainedObject:touch]];
    }
}

-(void)updateEstimatedPropertiesForTouches:(NSSet<NSObject*>*)touches
{
    if (self.isTouchUpdatingEnabled || touches == nil) {
        return;
    }
    
    for(UITouch* touch in touches)
    {
        BOOL isPending = NO;
        
        // Look to retrieve a line from `activeLines`. If no line exists, look it up in `pendingLines`.
        
        Line* possibleLine = [self.activeLines objectForKey:[NSValue valueWithNonretainedObject:touch]];
        if (!possibleLine) {
            possibleLine = [self.pendingLines objectForKey:[NSValue valueWithNonretainedObject:touch]];
        }
        
        // If no line is related to the touch, return as there is no additional work to do.
        if (possibleLine) {
            Line* line = possibleLine;
            CGRect updateRect = [line updateWithTouch:touch];
            if(!CGRectEqualToRect(CGRectNull, updateRect))
            {
                [self setNeedsDisplayInRect:updateRect];
            }
            
            // If this update updated the last point requiring an update, move the line to the `frozenImage`.
            if( isPending && [line isComplete])
            {
                [self finishLine:line];
                [self.pendingLines removeObjectForKey:[NSValue valueWithNonretainedObject:touch]];
            }
            // Otherwise, have the line add any points no longer requiring updates to the `frozenImage`.
            else {
                [self commitLine:line];
            }

        }
        else
        {
            return;
        }
        
        
    }
}

-(void)commitLine:(Line*)line
{
    // Have the line draw any segments between points no longer being updated into the `frozenContext` and remove them from the line.
    [line drawFixedPointsInContext:[self frozenContext] isDebuggingEnabled:self.isDebuggingEnabled usePreciseLocation:self.usePreciseLocations];
    [self setFrozenImageNeedsUpdate];
}

-(void)finishLine:(Line*)line
{
    // Have the line draw any remaining segments into the `frozenContext`. All should be fixed now.
    [line drawFixedPointsInContext:[self frozenContext] isDebuggingEnabled:self.isDebuggingEnabled usePreciseLocation:self.usePreciseLocations commitAll:true];
    [self setFrozenImageNeedsUpdate];
    // Cease tracking this line now that it is finished.
    NSUInteger index = [self.lines indexOfObject:line];
    if (index != NSNotFound) {
        [self.lines removeObjectAtIndex:index];
    }
    // Store into finished lines to allow for a full redraw on option changes.
    
    [self.finishedLines addObject:line];
}
@end
