//
//  ViewController.m
//  iosanimation
//
//  Created by rolandxu on 15/9/15.
//  Copyright (c) 2015年 rolandxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _buildData];
    [self _buildSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private
-(void)_buildData
{
    _dataArray = [NSArray arrayWithObjects:@"imageanimation",nil];
}

-(void)_buildSubViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

#pragma mark DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* string = [_dataArray objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = string;
    return cell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* string = [_dataArray objectAtIndex:indexPath.row];
    string = [NSString stringWithFormat:@"%@Controller",string];
    Class cls = NSClassFromString(string);
    if ([cls isSubclassOfClass:[UIViewController class]]) {
        UIViewController* ctl = (UIViewController*)[[cls alloc] init];
        UINavigationController* navi = self.navigationController;
        [navi pushViewController:ctl animated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] init];
        alert.message = @"controller name is error";
        [alert show];
    }
}
@end


