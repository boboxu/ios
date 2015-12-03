//
//  ViewController.m
//  ios9feature
//
//  Created by rolandxu on 11/18/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "ViewController.h"
#import "PreviewController.h"

@interface ViewController ()
<UITableViewDataSource,UITableViewDelegate,UIViewControllerPreviewingDelegate>
{
    NSArray* _dataSource;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _buildDataSource];
    [self _buildSubViews];
    
    self.title = @"ios9features";
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.tableView];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_buildDataSource
{
    _dataSource = @[@"CanvasController",@"PreviewController"];
}

-(void)_buildSubViews
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    [cell.textLabel setText:_dataSource[indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cls = NSClassFromString(_dataSource[indexPath.row]);
    if([cls isSubclassOfClass:[UIViewController class]])
    {
        UIViewController* controller = [cls new];
        [self showViewController:controller sender:self];
    }
}

#pragma mark UIViewControllerPreviewingDelegate

// If you return nil, a preview presentation will not be performed
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:location];
    Class cls = NSClassFromString(_dataSource[indexPath.row]);
    if([cls isSubclassOfClass:[UIViewController class]])
    {
        UIViewController* controller = [cls new];
        return controller;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

@end
