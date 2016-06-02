//
//  AccountViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AccountViewController.h"
#import "Httptool.h"
#import "LoginViewController.h"

@interface AccountViewController ()
{
    NSInteger _flag;
}
@property (nonatomic,strong)UIView* bgRightView;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号管理";
    self.view.backgroundColor = TabBarColor;
    _flag = 0;
    [self creatUI];
    
}

- (void)creatUI
{
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, mScreenWidth, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, bgView.height)];
    label.text = @"联系客服";
    [bgView addSubview:label];
    UILabel* telLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgView.right - 150, 0, 150, bgView.height)];
    telLabel.text = @"4001548754";
    [bgView addSubview:telLabel];
    
    UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(5, bgView.bottom+20, mScreenWidth - 10, 44);
    exitBtn.layer.masksToBounds = YES;
    exitBtn.layer.cornerRadius = 5;
    exitBtn.backgroundColor = NavBarColor;
    [exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:exitBtn];
    [exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)exitBtnClick:(UIButton*)sender
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:IsLogin] isEqualToString:@"1"]) {
        //登录
        [self exitDataRequest];
        
    }else{
        [Httptool showCustInfo:@"提示" MessageString:@"已经退出账号"];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)exitDataRequest
{
    NSString* url = @"index.php?act=logout";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserName] forKey:@"username"];
    [params setObject:@"ios" forKey:@"client"];
    [Httptool getWithURL:url Params:nil Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*)json;
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK){
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kLoginUserName];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kLoginUserKey];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:IsLogin];
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            loginVC.typeLoginSource = typeTabBarMineToLogin;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    } Failure:^(NSError *error) {
        
    }];
}





@end
