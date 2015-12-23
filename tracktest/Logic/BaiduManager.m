//
//  BaiduManager.m
//  tracktest
//
//  Created by rolandxu on 12/23/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "BaiduManager.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface BaiduManager()
<BMKGeneralDelegate,BMKLocationServiceDelegate>
@property BMKMapManager* mapManager;
@property BMKLocationService* locService;
@end

@implementation BaiduManager

static BaiduManager* gInstance;
+(BaiduManager*)shareInstance
{
    if (gInstance == nil) {
        gInstance = [BaiduManager new];
    }
    return gInstance;
}

-(void)initManager
{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"LMGDSLwKfLGR4KhgYktsg5ux" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
}

-(void)startLocation
{
    [_locService startUserLocationService];
}

-(void)stopLocation
{
    [_locService stopUserLocationService];
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"%f %f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateBMKUserLocation:)]) {
        [self.delegate didUpdateBMKUserLocation:userLocation];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
@end
