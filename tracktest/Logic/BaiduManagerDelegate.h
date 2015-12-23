//
//  BaiduManagerDelegate.h
//  tracktest
//
//  Created by rolandxu on 12/23/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@protocol BaiduManagerDelegate <NSObject>
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;
@end
