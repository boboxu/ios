//
//  CanvasController.m
//  ios9feature
//
//  Created by rolandxu on 12/3/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "CanvasController.h"
#import "TouchView.h"

@interface CanvasController ()
{
    TouchView* _canvasView;
}
@end

@implementation CanvasController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _buildSubViews];
    // Do any additional setup after loading the view.
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

-(void)_buildSubViews
{
    _canvasView = [[TouchView alloc] initWithFrame:CGRectMake(0, 64+30, self.view.frame.size.width,self.view.frame.size.height - 64+30)];
    [_canvasView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_canvasView];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 30)];
    [btn setTitle:@"Clear" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(onClickClear:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onClickClear:(id)sender
{
    [_canvasView clear];
}

@end
