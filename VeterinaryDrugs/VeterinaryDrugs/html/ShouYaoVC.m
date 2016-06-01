//
//  ShouYaoVC.m
//  SanMiKeJi
//
//  Created by 邱 德政 on 16/4/18.
//  Copyright © 2016年 SanMi. All rights reserved.
//

#import "ShouYaoVC.h"
#import "MBProgressHUD.h"

@interface ShouYaoVC ()<UIWebViewDelegate>
{
     MBProgressHUD *_HUD;
}
@end

@implementation ShouYaoVC
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar .hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar .hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self createweb];
//         _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        NSLog(@"%@",self.weburl);
//       [_HUD show:YES];
//     _HUD.labelText = @"页面加载中";
}
-(void)createweb
{
  
    UIWebView * view = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    [view scalesPageToFit];
    view.delegate = self;
//    [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.weburl]]];
    [view loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle]URLForResource:@"index" withExtension:@"html"]]];
    [view goBack];
    [self.view addSubview:view];
    [view stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"script" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_HUD hide:YES];
    
     [webView stringByEvaluatingJavaScriptFromString:@"setImageClickFunction()"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSString *urlStr = @"http://www.soyaow.com/wap/index.html";
//    NSString * url = request.URL.absoluteString;
//        NSLog(@"--------url%@",url);
//    if ([url isEqualToString: urlStr]) {
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        return NO;
//    }else{
//        
//        return YES;
//    }
    NSString *path=[[request URL] absoluteString];
    
    NSLog(@"%@",path);
    return YES;
    
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"%@",self.weburl);
    [_HUD show:YES];
    _HUD.labelText = @"页面加载中";
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

@end
