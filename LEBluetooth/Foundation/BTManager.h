//
//  BTManager.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTManagerInterface.h"
#import "BTManagerDelegate.h"

@interface BTManager : NSObject
<BTManagerInterface>

//蓝牙管理用单例，这个回头我看看连接多个设备的时候支持不，还有待商榷
+(BTManager*)shareInstance;
@end
