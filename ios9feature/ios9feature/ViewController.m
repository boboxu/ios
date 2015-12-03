//
//  ViewController.m
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "ViewController.h"
#import "TouchView.h"

@interface ViewController ()
{
    TouchView* _canvasView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self _buildSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_buildSubViews
{
    _canvasView = [[TouchView alloc] initWithFrame:self.view.frame];
    [_canvasView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_canvasView];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 30)];
    [btn setTitle:@"Clear" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(onClickClear:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onClickClear:(id)sender
{
    [_canvasView clear];
}

@end
