//
//  touchview.h
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchView : UIView

-(void)drawTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent*)event;
-(void)endTouches:(NSSet<UITouch *> *)touches cancel:(BOOL)cancel;
@end
