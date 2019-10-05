//
//  ZDWebViewController.m
//  答题demo
//
//  Created by Jude Leslie on 2019/10/4.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//

#import "ZDWebViewController.h"
#import <WebKit/WebKit.h>

#define KScrnH [[UIScreen mainScreen] bounds].size.height
#define KScrnW [[UIScreen mainScreen] bounds].size.width

@interface ZDWebViewController ()

@end

@implementation ZDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, KScrnW, KScrnH)];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [webView loadRequest:request];
    [webView goBack];
    [webView goForward];
    [webView reload];
    NSLog(@"===跳转成功");
    
    [self.view addSubview:webView];
    return;
    
    // Do any additional setup after loading the view.
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
