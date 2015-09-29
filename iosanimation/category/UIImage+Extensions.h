//
//  UIImage+UIImage_Extensions.h
//  iosanimation
//
//  Created by rolandxu on 9/29/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Extensions)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
