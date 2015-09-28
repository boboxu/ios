//
//  viewanimationController.m
//  iosanimation
//
//  Created by rolandxu on 9/28/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "viewanimationController.h"

@interface viewanimationController ()

@end

@implementation viewanimationController

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
}

-(void)_configTopBar
{
    self.navigationController.title = NSStringFromClass(self.class);
}
@end
