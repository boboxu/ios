//
//  viewanimationController.m
//  iosanimation
//
//  Created by rolandxu on 9/29/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "viewanimationController.h"

#define BTN_HEIGHT 25
#define BTN_RECT_OFFSET 10  //按钮区域居中，有一个偏移量
@interface viewanimationController ()
{
    NSArray* _propertyArray;
    CGFloat _bottonPostionMaxY;
    UIView* _bottomView;//动画操作的View
    NSValue* _oldValue;
    NSString* _propertyname;
    
}
@end

@implementation viewanimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    
    [self _buildButtons];
    
    [self _buildBottomView];
    
//    NSString *imageName = @"grid.png"; // the image is here: http://f.cl.ly/items/050w3k342y032F0E3n29/grid.png
//    
//    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//    
//    CGSize imageSize;
//    imageSize.width = imageView1.frame.size.width;
//    imageSize.height = imageView1.frame.size.height;
//    
//    CGSize stretchSize;
//    stretchSize.width = 50.0;
//    stretchSize.height = 100.0;
//    
////    CGRect rect = CGRectMake(0.0, 0.0, stretchSize.width/imageSize.width, stretchSize.height/imageSize.height);
//    CGRect rect = CGRectMake(0.0, 0.0, 0.0, 0.5);
//    imageView1.contentStretch = rect;
//    imageView2.contentStretch = imageView1.contentStretch;
//    imageView3.contentStretch = CGRectMake(100.0/imageSize.width, 100.0/imageSize.height, stretchSize.width/imageSize.width, stretchSize.height/imageSize.height);
//    
//    // horizonzal stretch
//    imageView1.frame = CGRectMake(10.0, 10.0, imageSize.width, imageSize.height*2);
//    
//    // vertical stretch
//    imageView2.frame = CGRectMake(10.0, imageView1.frame.origin.y + imageView1.frame.size.height + 10.0, imageSize.width, imageSize.height*1.2);
//    
//    // middle stretch
//    imageView3.frame = CGRectMake(imageView1.frame.origin.x + imageView1.frame.size.width + 10.0, 10.0, 450.0, 450.0);
//    
//    [self.view addSubview:imageView1];
//    [self.view addSubview:imageView2];
//    [self.view addSubview:imageView3];
    
}

-(void)_buildButtons
{
    _propertyArray = @[@"frame",@"bounds",@"center",@"transform",@"alpha",@"backgroundColor",@"contentStretch"];
    //计算 按钮的frame
    NSInteger column = 2;
    NSInteger rownum = _propertyArray.count / column + ((_propertyArray.count%column == 0)?0:1);
    CGFloat column_space = 10;
    CGFloat row_space = 10;
    CGFloat btn_width = (SCREEN_WIDTH - 2*BTN_RECT_OFFSET - (column - 1)*column_space) / column ;
    for (NSInteger i = 0; i < _propertyArray.count; i++) {
        NSInteger row_index = i / column;
        NSInteger column_index = i % column;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[_propertyArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]];
        [button setFrame:CGRectMake(BTN_RECT_OFFSET + column_space*column_index+btn_width*(column_index), BTN_RECT_OFFSET + row_space*row_index+BTN_HEIGHT*(row_index), btn_width, BTN_HEIGHT)];
        button.tag = i;
        button.backgroundColor = [UIColor blueColor];
        [button addTarget:self action:@selector(onClickProperty:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
    _bottonPostionMaxY = BTN_RECT_OFFSET+(row_space+BTN_HEIGHT)*rownum;
}

-(void)_buildBottomView
{
    CGFloat viewHeight = self.view.frame.size.height;
//    CGFloat screenHeight = SCREEN_HEIGHT;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, _bottonPostionMaxY, SCREEN_WIDTH - 20, viewHeight - 10 - _bottonPostionMaxY - self.navigationController.navigationBar.frame.size.height - 20)];
    
    [_bottomView setBackgroundColor:RGBA(0.0f,0.0f,0.0f,0.6f)];
//    [_bottomView setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:_bottomView];
}

-(void)_configTopBar
{
    self.navigationItem.title = NSStringFromClass(self.class);
}

#pragma mark event handler
-(void)onClickProperty:(id)sender
{
    _propertyname = [_propertyArray objectAtIndex:((UIButton*)sender).tag];
    NSLog(@"%@",_propertyname);
    _oldValue = [_bottomView valueForKey:_propertyname]; //先保存老的数据，完事之后还原
    NSLog(@"%@",_oldValue);
    
    CGRect oldFrame = _bottomView.frame;
    CGRect newFrame = oldFrame;
    id newValue;
    if ([_propertyname isEqualToString:@"frame"]) {
        CGRect oldFrame = [_oldValue CGRectValue];
        CGFloat newWidth = CGRectGetWidth(oldFrame) / 2;
        CGFloat newHeight = CGRectGetHeight(oldFrame) / 2;
        CGFloat newPosX = (SCREEN_WIDTH - newWidth)/2;
        CGFloat newPosY = CGRectGetMinY(oldFrame);
        CGRect newFrame = CGRectMake(newPosX, newPosY, newWidth, newHeight);
        newValue = [NSValue valueWithCGRect:newFrame];
    }
    else if([_propertyname isEqualToString:@"bounds"])
    {
        CGRect oldBounds = [_oldValue CGRectValue];
        CGFloat newWidth = CGRectGetWidth(oldBounds) / 2;
        CGFloat newHeight = CGRectGetHeight(oldBounds) / 2;
        CGRect newFrame = CGRectMake(0, 0, newWidth, newHeight);
        newValue = [NSValue valueWithCGRect:newFrame];
    }
    else if([_propertyname isEqualToString:@"center"])
    {
        CGPoint oldCenter = [_oldValue CGPointValue];
        CGFloat newPosX = oldCenter.x + 10;
        CGFloat newPosY = oldCenter.y + 0;
        CGPoint newCenter = CGPointMake(newPosX, newPosY);
        newValue = [NSValue valueWithCGPoint:newCenter];
    }
    else if([_propertyname isEqualToString:@"transform"])
    {
        CGAffineTransform oldtrans = [_oldValue CGAffineTransformValue];
        CGAffineTransform newtrans = CGAffineTransformScale(oldtrans, 0.5, 0.5);
        newValue = [NSValue valueWithCGAffineTransform:newtrans];
    }
    else if([_propertyname isEqualToString:@"alpha"])
    {
        CGFloat oldAlpha = [(NSNumber*)_oldValue floatValue];
        CGFloat newAplpha = oldAlpha/2.0;
        newValue = [NSNumber numberWithFloat:newAplpha];
    }
    else if([_propertyname isEqualToString:@"backgroundColor"])
    {
//        UIColor* color = (UIColor*)_oldValue;
//        const CGFloat* colorsarray = CGColorGetComponents( color.CGColor );
//        newValue = RGBA(colorsarray[0]/2, colorsarray[1]/2, colorsarray[2]/2, colorsarray[3]/2);
        newValue = RGBA(255.0f, 255.0f, 0.0f, 1.0f);
    }
    else if([_propertyname isEqualToString:@"contentStretch"])
    {
        //这个设置固定，以及可以拉伸的区域，需要设置frame才能有可视效果的
        CGRect cgrect = [_oldValue CGRectValue];
        newValue = [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(cgrect)/2, CGRectGetMinX(cgrect)/2, CGRectGetWidth(cgrect) / 2, CGRectGetHeight(cgrect) / 2)];
////        CGRect oldBounds = [oldvalue CGRectValue];
//        CGFloat newWidth = CGRectGetWidth(oldFrame) / 2;
//        CGFloat newHeight = CGRectGetHeight(oldFrame) / 2;
//        newFrame = CGRectMake(0, 0, newWidth, newHeight);
        
    }
    
    //UIViewAnimationWithBlocks
    [UIView animateWithDuration:2 animations:^{
        [_bottomView setValue:newValue forKey:_propertyname];
    } completion:^(BOOL finished) {
        [_bottomView setValue:_oldValue forKey:_propertyname];
    }];
    
//    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat animations:^{
//        [_bottomView setValue:newValue forKey:_propertyname];
//    } completion:^(BOOL finished) {
//        [_bottomView setValue:_oldValue forKey:_propertyname];
//    }];
//    CGPoint center = _bottomView.center;
//    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:20 options:UIViewAnimationOptionLayoutSubviews animations:^{
////        [_bottomView setValue:newValue forKey:_propertyname];
//        CGPoint newCenter = CGPointMake(center.x + 10, center.y);
//        _bottomView.center = newCenter;
//    } completion:^(BOOL finished) {
//
//    }];
    
    
    //UIViewAnimation
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:2];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(_resetOldValue:)];
//    //动画曲线
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    //动画，从右往左反转
//    UIViewAnimationTransition transition;
//    transition = UIViewAnimationTransitionFlipFromRight;
//    [UIView setAnimationTransition: transition forView:_bottomView cache:YES];
//    //反向重复10次
////    [UIView setAnimationRepeatAutoreverses:YES];
//    [UIView setAnimationRepeatCount:2];
//    [_bottomView setValue:newValue forKey:_propertyname];
//    [UIView commitAnimations];
    
    
//    [self performSelector:@selector(_stopAnimation:) withObject:nil afterDelay:2.0];
}

-(void)_resetOldValue:(id)sender
{
    [_bottomView setValue:_oldValue forKey:_propertyname];
}

-(void)_stopAnimation:(id)sender
{
    [_bottomView.layer removeAllAnimations];
}
@end
