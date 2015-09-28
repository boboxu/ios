//
//  ImageUtil.m
//  iosanimation
//
//  Created by rolandxu on 15/9/28.
//  Copyright © 2015年 rolandxu. All rights reserved.
//

#include <math.h>
#import <UIKit/UIKit.h>
#import "ImageUtil.h"

static inline double radians(double degrees)
{
    return degrees*M_PI/180;
}

@implementation ImageUtil

+(UIImage*)rotationUIImage:(UIImage*)sourceImage degrees:(double)degrees{
    UIImage * destImage = nil;
    if( sourceImage )
    {
        CGSize sourceResolution = sourceImage.size;
        
        CGSize destResolution = sourceResolution ;
        
        int bytesPerRow = 4.0f * destResolution.width;
        void* destBitmapData = malloc( bytesPerRow * destResolution.height );
        if( destBitmapData == NULL ) NSLog(@"failed to allocate space for the output image!");
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef  destContext = CGBitmapContextCreate( destBitmapData, destResolution.width, destResolution.height, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast );
        CGColorSpaceRelease( colorSpace );
        if( destContext == NULL )
        {
            NSLog(@"failed to create the output bitmap context!");
        }
        else
        {
//            switch (type)
//            {
//                case 0://默认方向
////                    destImageDesp.text = @"默认方向";
//                    break;
//                case 1://旋转180度
//                    CGContextRotateCTM(destContext, radians(180));
//                    CGContextTranslateCTM( destContext, -destResolution.width,-destResolution.height);
////                    destImageDesp.text = @"旋转180度";
//                    break;
//                case 2://逆时90度
//                    CGContextRotateCTM(destContext, radians(90));
//                    CGContextTranslateCTM( destContext, 0, -destResolution.width);
////                    destImageDesp.text = @"逆时90度";
//                    break;
//                case 3://顺时90度
//                    CGContextRotateCTM(destContext, radians(-90));
//                    CGContextTranslateCTM( destContext, -destResolution.height, 0);
////                    destImageDesp.text = @"顺时90度";
//                    break;
//                    
//                case 4://水平轴旋转180度
//                    CGContextTranslateCTM( destContext, 0, destResolution.height );
//                    CGContextScaleCTM( destContext, 1.0f, -1.0f );
////                    destImageDesp.text = @"水平轴旋转180度";
//                    break;
//                case 5://垂直轴旋转180度
//                    CGContextTranslateCTM( destContext, destResolution.width, 0);
//                    CGContextScaleCTM( destContext, -1.0f, 1.0f );
////                    destImageDesp.text = @"垂直轴旋转180度";
//                    break;
//                case 6://中心旋转180度
//                    CGContextTranslateCTM( destContext, destResolution.width, destResolution.height );
//                    CGContextScaleCTM( destContext, -1.0f, -1.0f );
////                    destImageDesp.text = @"中心旋转180度";
//                    break;
//                default:
////                    destImageDesp.text = @"未作处理";
//                    break;
//            }
//            
            CGContextRotateCTM(destContext, radians(degrees));
            CGContextTranslateCTM( destContext, -destResolution.width,-destResolution.height);
            CGContextDrawImage( destContext, CGRectMake(0, 0, sourceResolution.width, sourceResolution.height), sourceImage.CGImage );
            
            CGImageRef destImageRef = CGBitmapContextCreateImage( destContext );
            if( destImageRef == NULL ) NSLog(@"destImageRef is null.");
            destImage = [UIImage imageWithCGImage:destImageRef scale:1.0f orientation:UIImageOrientationUp];
            //设置orientation 只是UIimage显示效果，如果将这个UIimage保存为文件还是没有旋转的
            CGImageRelease( destImageRef );
            
        }
        CGContextRelease( destContext );
        free( destBitmapData );
    }
    else
    {
        NSLog(@"input image not found!");
    }
    return destImage;
}

@end
