//
//  ImageUtil.h
//  iosanimation
//
//  Created by rolandxu on 15/9/28.
//  Copyright © 2015年 rolandxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject
+(UIImage*)rotationUIImage:(UIImage*)sourceImage degrees:(double)degrees;
@end
