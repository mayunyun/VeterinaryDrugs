//
//  MyNavViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MyNavViewController.h"

@interface MyNavViewController ()

@end

@implementation MyNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationBar.barTintColor = [UIColor colorWithHexString:@"0074FF"];
        self.navigationBar.translucent = NO;
    }
    else
    {
        self.navigationBar.tintColor = [UIColor colorWithHexString:@"0074FF"];
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
    [super pushViewController:viewController animated:animated];
}

//当第一次使用这个类的时候调用一次
+ (void)initialize
{
    [self setupNavigationBarTheme];
    [self setupUIBarButtonItemTheme];
}

//设置UINavigationBar的主题
+ (void)setupNavigationBarTheme
{
    //通过appearance对象能修改整个项目中所有UINavigationBar的样式
    UINavigationBar * appearance = [UINavigationBar appearance];
    //设置导航栏背景
    [appearance setBackgroundColor:[UIColor colorWithHexString:@"0074FF"]];
    //设置文字属性
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    //ios<7.0
//    textAttrs[UITextAttributeFont] = [UIFont fontWithName:@"STHeitiSC-Light" size:18.0];
//    textAttrs[UITextAttributeTextColor] = [UIColor colorWithHexString:@"ffffff"];
//    //UIOffsetZero是结构体，只能包装成对象才能放在字典中
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    
    //ios>7.0
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"STHeitiSC-Light" size:18.0];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"ffffff"];
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

//设置UIBarButtonItem的主题
+ (void)setupUIBarButtonItemTheme
{
    UIBarButtonItem * appearance = [UIBarButtonItem appearance];
    //设置普通状态的文字属性
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    //ios<7.0
//        textAttrs[UITextAttributeFont] = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0];
//        textAttrs[UITextAttributeTextColor] = [UIColor colorWithHexString:@"3a3a3a"];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    //ios>7.0
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"3a3a3a"];
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];

    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置高亮状态的文字属性
    NSMutableDictionary * highextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    [appearance setTitleTextAttributes:highextAttrs forState:UIControlStateHighlighted];
    
    //设置不可用状态的文字属性
    NSMutableDictionary * disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
//    disableTextAttrs[UITextAttributeTextColor] = [UIColor lightGrayColor];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    //背景
    //技巧：(做一张完全透明或与导航栏颜色一样的图片，为让某个按钮的背景图片消失)
    //    [appearance setBackgroundImage:[UIImage imageNamed:@"imagename"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
}

+ (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"sdhsjhds"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 30, 21);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSInteger countOfViewControllers = self.viewControllers.count;
    while (countOfViewControllers > 0) {
        
        [self popViewControllerAnimated:NO];
        countOfViewControllers--;
    }
    return nil;
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

@end
