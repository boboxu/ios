//
//  AppDelegate.m
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "AppDelegate.h"
#import "BTManager.h"
#import "UIAlertController+Blocks.h"

@interface AppDelegate ()
<BTManagerDelegate>
{
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[BTManager shareInstance] addDelegate:self];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark BTManagerDelegate
-(void)onCenterManagerStateChanged:(CBCentralManagerState)state
{
    switch (state) {
        case CBCentralManagerStateUnknown:
        {
            //未知
        }
            
            break;
        case CBCentralManagerStateResetting:
            //正在重置
            break;
        case CBCentralManagerStateUnsupported:
            //不支持
            break;
        case CBCentralManagerStateUnauthorized:
            //需要授权
            break;
        case CBCentralManagerStatePoweredOff:
            //关闭了
        {
            [self _showAlertBtSettings];
        }
            break;
        case CBCentralManagerStatePoweredOn:

            break;
        default:
            
            break;
    }

}

-(void)_showAlertBtSettings
{
    [UIAlertController showInViewController:self.window.rootViewController withTitle:@"" message:@"蓝牙关闭了" preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"好" destructiveButtonTitle:nil otherButtonTitles:@[@"设置"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    }
                                   tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                       if (buttonIndex == controller.firstOtherButtonIndex) {
                                           [self _openBtSettings];
                                       } else if (buttonIndex == controller.cancelButtonIndex) {
                                           
                                       }
                                   }];
}

-(void)_openBtSettings
{
    NSURL*url=[NSURL URLWithString:@"prefs:root=General&path=Bluetooth"];
    [[UIApplication sharedApplication] openURL:url];
    
}
@end
