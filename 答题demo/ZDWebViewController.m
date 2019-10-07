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

@interface ZDWebViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scroView;;
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation ZDWebViewController
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, KScrnW, KScrnH)];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        [_webView loadRequest:request];
        [_webView goBack];
        [_webView goForward];
        [_webView reload];
        [self.view addSubview:_webView];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView];
    self.scroView.delegate = self;
    if ([self.scroView.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scroView.delegate scrollViewDidScroll:self.scroView];
    }
    NSLog(@"===跳转成功");
    return;
    
    // Do any additional setup after loading the view.
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"滑动了");
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (request) {
        return YES;
    }else{
        return NO;        
    }
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
