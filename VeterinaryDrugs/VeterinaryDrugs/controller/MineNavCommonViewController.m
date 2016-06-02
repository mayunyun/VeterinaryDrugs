
//
//  MineNavCommonViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/6/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MineNavCommonViewController.h"

@interface MineNavCommonViewController ()
{
    NSInteger _flag;
}
@property (nonatomic,strong)UIView* bgRightView;
@end

@implementation MineNavCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatNav
{
    self.navigationItem.titleView = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    UIButton* leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(5, 0, 30, 30);
    [leftbtn setImage:[UIImage imageNamed:@"sdhsjhds"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    UIButton* rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(0, 0, 30, 30);
    [rightbtn setImage:[UIImage imageNamed:@"icon_dote"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
}

#pragma mark NavClick
- (void)leftBarClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick:(UIButton*)sender
{
    _flag = !_flag;
    if (_flag) {
        NSLog(@"出现");
        [UIView animateWithDuration:.5 animations:^{
            [self creatRightView];
        } completion:^(BOOL finished) {
            
            
        }];
        
        
    }else{
        NSLog(@"隐藏");
        
        [UIView animateWithDuration:.5 animations:^{
            [_bgRightView removeFromSuperview];
            //            [UIView setAnimationDuration:.5]; //动画时长
            //            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_bgRightView cache:YES];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
}
- (void)creatRightView
{
    _bgRightView = [[UIView alloc]initWithFrame:CGRectMake(mScreenWidth - 130, 0, 120, 150)];
    _bgRightView.backgroundColor = NavBarColor;
    [self.view addSubview:_bgRightView];
    NSArray* titleArr = @[@"首页",@"购物车",@"我"];
    for (int i = 0; i < 3 ; i ++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, i*49, _bgRightView.width, 49);
        btn.tag = 100+i;
        [_bgRightView addSubview:btn];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (i+1)*49, _bgRightView.width, 1)];
        lineLabel.backgroundColor = LineColor;
        [_bgRightView addSubview:lineLabel];
    }
    
}
- (void)rightViewBtnClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 100:
        {
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 101:
        {
            [self.tabBarController setSelectedIndex:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            [self.tabBarController setSelectedIndex:2];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
