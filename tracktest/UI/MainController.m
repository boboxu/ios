//
//  MainController.m
//  tracktest
//
//  Created by rolandxu on 12/23/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "MainController.h"
#import "BaiduViewController.h"
#import "GaodeViewController.h"
#import "OSViewController.h"
#import "QQViewController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self _initSubControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_initSubControllers
{
    BaiduViewController* c1 = [[BaiduViewController alloc] initWithNibName:@"BaiduViewController" bundle:nil];
    c1.tabBarItem.title = @"Baidu";
    GaodeViewController* c2 = [[GaodeViewController alloc] initWithNibName:@"GaodeViewController" bundle:nil];
    c2.tabBarItem.title = @"Gaode";
    OSViewController* c3 = [[OSViewController alloc] initWithNibName:@"OSViewController" bundle:nil];
    c3.tabBarItem.title = @"OS";
    QQViewController* c4 = [[QQViewController alloc] initWithNibName:@"QQViewController" bundle:nil];
    c4.tabBarItem.title = @"QQ";
    self.viewControllers=@[c1,c2,c3,c4];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
