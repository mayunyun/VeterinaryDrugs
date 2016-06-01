//
//  WebViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "WebViewController.h"
#import "ShouYaoVC.h"
#import "Reachability.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *_HUD;
    
}
@property (nonatomic,assign)BOOL isNetConnect;
@property (nonatomic,strong)UIWebView * webview;
@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = NavBarColor;
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"%@",self.weburl);
    [_HUD show:YES];
    _HUD.labelText = @"页面加载中";
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar .hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    if (self.isNetConnect) {
        [self createweb];
//    }else{
//        [self.tabBarController setSelectedIndex:0];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }

    
}
-(void)createweb
{
//    //清除cookies
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        [storage deleteCookie:cookie];
//    }
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    NSURLCache * cache = [NSURLCache sharedURLCache];
//    [cache removeAllCachedResponses];
//    [cache setDiskCapacity:0];
//    [cache setMemoryCapacity:0];
    //
    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, mScreenHeight - 20)];
    _webview.delegate = self;
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.weburl]]];
    [_webview goBack];
    [self.view addSubview:_webview];
    _webview.backgroundColor = [UIColor clearColor];
    _webview.opaque = NO;
    _webview.scrollView.bounces = NO ;
    [_webview scalesPageToFit];
    UIScrollView *scrollView = _webview.scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
//    for (int i = 0; i < scrollView.subviews.count ; i++) {
//        UIView *view = [scrollView.subviews objectAtIndex:i];
//        if ([view isKindOfClass:[UIImageView class]]) {
//            view.hidden = YES ;
//        }
//    }
    
}

/*
 UIWebViewNavigationTypeLinkClicked，用户触击了一个链接。
 UIWebViewNavigationTypeFormSubmitted，用户提交了一个表单。
 UIWebViewNavigationTypeBackForward，用户触击前进或返回按钮。
 UIWebViewNavigationTypeReload，用户触击重新加载的按钮。
 UIWebViewNavigationTypeFormResubmitted，用户重复提交表单
 UIWebViewNavigationTypeOther，发生其它行为。
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
        NSString *urlStr = [NSString stringWithFormat:@"%@/index.html",ShouYaoWapServer];
        NSString * url = request.URL.absoluteString;
            NSLog(@"--------url%@",url);
        if ([url isEqualToString: urlStr]) {
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return NO;
        }
    
    static BOOL isRequestWeb = YES;
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSLog(@"response.statusCode%ld",(long)response.statusCode);
        if (response.statusCode == 404) {
            // code for 404
            NSString *HTMLData = @"<img src=\"test.png\" />ddd";
            [webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
            [webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle]URLForResource:@"index" withExtension:@"html"]]];
            return NO;
        } else if (response.statusCode == 403) {
            // code for 403
            NSString *HTMLData = @"<img src=\"test.png\" />ddd";
            [webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
            [webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle]URLForResource:@"index" withExtension:@"html"]]];
            return NO;
        }else if (response.statusCode == 0){
            
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return NO;
        }
        
        [webView loadData:data MIMEType:@"text/html" textEncodingName:nil baseURL:[request URL]];
        
        isRequestWeb = NO;
        return NO;
    }
    
    return YES;

    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"读取页面失败");
    //在这里提示，并返回上一级
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTapHighlightColor='rgba(0,0,0,0)';"];
    [_HUD hide:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 通知事件
- (void)netWorkChangeAction:(NSNotification *)notification
{
    Reachability * reach = [notification object];
    if([reach currentReachabilityStatus] == NotReachable)
    {
        //当前无网络连接
        self.isNetConnect = NO;
        //        [alert show];
        [_HUD hide:YES];
    }
    else if ([reach currentReachabilityStatus] == ReachableViaWWAN)
    {
        //当前处于2G/3G/4G网络环境!"];
        self.isNetConnect = YES;
        

    }else if ([reach currentReachabilityStatus] == ReachableViaWiFi)
    {
        //当前处于WiFi网络环境!"];
        self.isNetConnect = YES;
        
        
    }
    
}





@end
