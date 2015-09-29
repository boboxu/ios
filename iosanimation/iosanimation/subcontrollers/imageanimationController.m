//
//  imageanimationController.m
//  iosanimation
//
//  Created by rolandxu on 15/9/15.
//  Copyright © 2015年 rolandxu. All rights reserved.
//

#import "imageanimationController.h"
#import "UIImage+Extensions.h"

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self _configTopBar];
    
    _imageview = [[UIImageView alloc] init];
    _imageview.contentMode = UIViewContentModeCenter;
    _imageview.animationImages = [self _generateImages];
    _imageview.animationDuration = 1;
    _imageview.animationRepeatCount = 0;
    _imageview.clipsToBounds = YES;
    
    CGRect rect;
    float w = 250,h=250;
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
    
    for(float i=0;i<=360;i++)
    {
        [images addObject:[img imageRotatedByDegrees:i]];
//        [images addObject:[ImageUtil  imageRotatedByRadians:i]];
    }
    return images;
}
@end
