//
//  MyTabBarController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MyTabBarController.h"
#import "MyNavViewController.h"
#import "HomeViewController.h"
#import "TypeViewController.h"
#import "ShopViewController.h"
#import "MineViewController.h"
#import "Httptool.h"
#import "Reachability.h"

@interface MyTabBarController ()

@property (nonatomic , strong) UILabel *hintContrl;

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVC];
    [self netConnect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initVC
{
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    HomeViewController *homVC = [[HomeViewController alloc]init];
    MyNavViewController*naVC  = [[MyNavViewController alloc]initWithRootViewController:homVC];
    naVC.tabBarItem.enabled          = YES;
//    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    bgView.backgroundColor = TabBarColor;
//    [self.tabBar insertSubview:bgView atIndex:0];
    homVC.title = @"首页";
    
    TypeViewController *listVC = [[TypeViewController alloc]init];
    MyNavViewController *listNav = [[MyNavViewController alloc]initWithRootViewController:listVC];
    listNav.tabBarItem.enabled = YES;
    listVC.title = @"分类";

    
    ShopViewController *assetVC = [[ShopViewController alloc]init];
    MyNavViewController *assetNav = [[MyNavViewController alloc]initWithRootViewController:assetVC];
    assetNav.tabBarItem.enabled = YES;
    assetVC.title = @"购物车";
    
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    MyNavViewController *mineNav = [[MyNavViewController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem.enabled = YES;
    mineVC.title = @"我";
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:naVC,listNav,assetNav,mineNav,nil];
    self.viewControllers = list;
    
    //标题默认颜色
    UIColor *normalColor = TabLableTextColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    //标题选择时的高亮颜色
    UIColor *titleHighlightedColor = TabLableLightTextColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    
    NSArray *imgArray = @[@"iconn11",
                          @"iconn22",
                          @"iconn33",
                          @"iconn44"];
    NSArray *selectImgArray =   @[@"iconn1",
                                  @"iconn2",
                                  @"iconn3",
                                  @"iconn4"];
    for (int i = 0; i < 4; i++) {
        UIViewController *vc = list[i];
        vc.tabBarItem.tag = i;
        
        NSString *imageStr = imgArray[i];
        NSString *selectImageStr = selectImgArray[i];
        if (IOS7) {
            //渲染模式
            vc.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            //            [vc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectImageStr] withFinishedUnselectedImage:[UIImage imageNamed:imageStr]];
            vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:selectImageStr] selectedImage:[UIImage imageNamed:imageStr]];
            
        }
        
    }
    
    
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

- (void)netConnect
{
    
    //初始化提示界面
    self.hintContrl = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 160)/2, (mScreenHeight - 90) / 2, 160, 30)];
    self.hintContrl.backgroundColor = RGBCOLOR(0, 0, 0, .9);
    self.hintContrl.font = [UIFont systemFontOfSize:14];
    self.hintContrl.textColor = [UIColor whiteColor];
    self.hintContrl.textAlignment = NSTextAlignmentCenter;
    
    
    //添加网络切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChangeAction:) name:kReachabilityChangedNotification object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Reachable");
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Unreachable");
        });
    };
    
    [reach startNotifier];
}
#pragma mark 通知事件
- (void)netWorkChangeAction:(NSNotification *)notification
{
    Reachability * reach = [notification object];
    if([reach currentReachabilityStatus] == NotReachable)
    {
        //当前无网络连接
        [self showHint:@"当前无网络连接!"];
        
    }else if ([reach currentReachabilityStatus] == ReachableViaWWAN)
    {
        //当前处于2G/3G/4G网络环境!"];
        [self showHint:@"当前处于2G/3G/4G网络环境!"];
        
    }else if ([reach currentReachabilityStatus] == ReachableViaWiFi)
    {
        //当前处于WiFi网络环境!"];
        [self showHint:@"当前处于WiFi网络环境!"];
        
    }

}

- (void)showHint:(NSString *)text
{
    self.hintContrl.text = text;
    self.hintContrl.alpha = 1;
    [APPDelegate.window addSubview:self.hintContrl];
    
    [self performBlock:^{
        [self hideHint];
    } afterDelay:4];
}

- (void)hideHint
{
    [UIView animateWithDuration:.5 animations:^{
        self.hintContrl.alpha = 0;
    } completion:^(BOOL finished) {
        [self.hintContrl removeFromSuperview];
    }];
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
