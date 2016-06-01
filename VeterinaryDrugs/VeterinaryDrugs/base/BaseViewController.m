//
//  BaseViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//
#define kApp ((AppDelegate*)([UIApplication sharedApplication].delegate))
#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [((AppDelegate*)([UIApplication sharedApplication].delegate)) preferredStatusBarStyle];
    
   
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
//横竖屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationPortrait)
    {
        return YES;
    }
    return NO;
}
- (BOOL)shouldAutorotate
{
    if ([[UIApplication sharedApplication]statusBarOrientation] == 3)
    {
        return NO;
    }
    return NO;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isLoginSeccessWap:(NSString*)client username:(NSString*)user password:(NSString*)pwd
{
    __block typeof (NSString*) flag;
    NSString* url = @"index.html?act=login";
    NSString* urlStr = [NSString stringWithFormat:@"%@/%@",ShouYaoWapServer,url];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:user forKey:@"username"];
    [params setObject:pwd forKey:@"password"];
    [params setObject:client forKey:@"client"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSInteger code = [operation response].statusCode;
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            flag = @"0";
        }
        else
        {
            flag =@"1";
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        flag =@"1";
    }];
    if ([flag isEqualToString:@"0"]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
