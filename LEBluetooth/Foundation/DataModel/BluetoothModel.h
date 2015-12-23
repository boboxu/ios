//
//  BlutoothModel.h
//  LEBluetooth
//
//  Created by rolandxu on 12/15/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetoothModel : NSObject

@property (nonatomic, copy) NSString *serviceUUID;
@property (nonatomic, copy) NSString *writeCharatUUID;
@property (nonatomic, copy) NSString *readCharatUUID;
@property (nonatomic, copy) NSString *serviceName;

@end
