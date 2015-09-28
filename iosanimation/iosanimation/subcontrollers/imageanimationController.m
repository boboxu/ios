//
//  imageanimationController.m
//  iosanimation
//
//  Created by rolandxu on 15/9/15.
//  Copyright © 2015年 rolandxu. All rights reserved.
//

#import "imageanimationController.h"
#import "ImageUtil.h"

@interface imageanimationController()
{
    UIImageView* _imageview;
}
@end

@implementation imageanimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _buildSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark private
-(void)_buildSubViews
{
    [self _configTopBar];
    
    _imageview = [[UIImageView alloc] init];
    
    _imageview.animationImages = [self _generateImages];
    _imageview.animationDuration = 5;
    _imageview.animationRepeatCount = 1;
    
    CGRect rect;
    float w = 100,h=100;
    rect.size = CGSizeMake(w, h);
    rect.origin = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds)-w/2, CGRectGetMidY([UIScreen mainScreen].bounds)-h/2);
    _imageview.frame = rect;
    
    [self.view addSubview:_imageview];
    [_imageview startAnimating];
}

-(void)_configTopBar
{
    self.navigationController.title = NSStringFromClass(self.class);
}

-(NSArray*)_generateImages
{
    UIImage *img = [UIImage imageNamed:@"logo"];
    NSMutableArray *images = [[NSMutableArray alloc]init];
    
    for(float i=0;i<=2*M_PI;i+=2*M_PI/12)
    {
        [images addObject:[ImageUtil rotationUIImage:img degrees:i]];
//        [images addObject:[ImageUtil  imageRotatedByRadians:i]];
    }
    return images;
}
@end
