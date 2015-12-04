//
//  PreviewController.m
//  ios9feature
//
//  Created by rolandxu on 12/3/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "PreviewController.h"

@interface PreviewController ()
<UIWebViewDelegate>

@end

@implementation PreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Preview"];
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

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_buildSubViews
{
    UIWebView* webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    
    NSURL* url = [NSURL URLWithString:@"http://www.qq.com"];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [webview loadRequest:req];
    webview.delegate = self;
}

#pragma mark WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"didFailLoadWithError");
}
@end
