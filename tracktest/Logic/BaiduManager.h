//
//  BaiduManager.h
//  tracktest
//
//  Created by rolandxu on 12/23/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduManagerDelegate.h"

@interface BaiduManager : NSObject

+(BaiduManager*)shareInstance;
-(void)startLocation;
-(void)stopLocation;
-(void)initManager;
@property (nonatomic,assign) id<BaiduManagerDelegate> delegate;
@end
