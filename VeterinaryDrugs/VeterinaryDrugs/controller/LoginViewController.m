//
//  LoginViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/30.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "MyNavViewController.h"
#import "RegistViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField* nameTextField;
@property (nonatomic, strong)UITextField* pwdTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self initNav];
    [self creatUI];

    
    
    
}

- (void)initNav
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [MyNavViewController backBarButtonItemTarget:self action:@selector(backClick:)];
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(mScreenHeight - 40, 12, 40, 25);
    [setButton setTitle:@"注册" forState:UIControlStateNormal];
    setButton.backgroundColor = [UIColor clearColor];
    setButton.showsTouchWhenHighlighted = YES;
    [setButton addTarget:self action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIView* nameView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, mScreenWidth - 20, 44)];
    nameView.backgroundColor = [UIColor whiteColor];
    nameView.layer.masksToBounds = YES;
    nameView.layer.cornerRadius = 5;
    [self.view addSubview:nameView];
    UIImageView* nameImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    nameImgView.image = [UIImage imageNamed:@"login_01"];
    [nameView addSubview:nameImgView];
    _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(nameImgView.right+10, 0, nameView.width - nameImgView.width - 10, nameView.height)];
    _nameTextField.placeholder = @"请输入用户名";
    _nameTextField.delegate = self;
    [nameView addSubview:_nameTextField];
    
    UIView* pwdView = [[UIView alloc]initWithFrame:CGRectMake(nameView.left, nameView.bottom + 10, nameView.width, nameView.height)];
    [self.view addSubview:pwdView];
    pwdView.backgroundColor = [UIColor whiteColor];
    pwdView.layer.masksToBounds = YES;
    pwdView.layer.cornerRadius = 5;
    UIImageView* pwdImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 30)];
    pwdImgView.image = [UIImage imageNamed:@"login_02"];
    [pwdView addSubview:pwdImgView];
    _pwdTextField= [[UITextField alloc]initWithFrame:CGRectMake(pwdImgView.right+10, 0, pwdView.width - pwdImgView.width - 10, pwdImgView.height)];
    _pwdTextField.delegate = self;
    _pwdTextField.secureTextEntry = YES;//密码遮掩
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    [pwdView addSubview:_pwdTextField];
    
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(pwdView.left, pwdView.bottom+20, pwdView.width, pwdView.height+10);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    loginBtn.backgroundColor = NavBarColor;
    [loginBtn addTarget:self action:@selector(loginInBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)backClick:(UINavigationItem*)sender
{
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)setAction:(UIButton*)sender
{
    RegistViewController* registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)loginInBtn:(UIButton*)sender
{
    if (!IsEmptyValue(_nameTextField.text)&&!IsEmptyValue(_pwdTextField.text))
    {
        [self loginRequestData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    

}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)loginRequestData
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //版本信息移动设备操作系统信息"osPlatform"
    NSString * systemVersion =[[UIDevice currentDevice]systemVersion];
    NSString * model = [[UIDevice currentDevice]model];
    NSString* url = @"index.php";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"login" forKey:@"act"];
    [params setObject:model forKey:@"deviceModel"];
    [params setObject:adId forKey:@"deviceImei"];
    [params setObject:systemVersion forKey:@"osPlatform"];
    
    [params setObject:_nameTextField.text forKey:@"username"];
    [params setObject:_pwdTextField.text forKey:@"password"];
    [params setObject:@"ios" forKey:@"client"];
    NSLog(@"params---------%@",params);
    [Httptool postWithURL:url Params:params Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*) json;
        NSLog(@"typedic----------%@",dic);
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSLog(@"登录成功");
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IsLogin];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"datas"][@"username"] forKey:kLoginUserName];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"datas"][@"key"] forKey:kLoginUserKey];
            
            if (_typeLoginSource == typeHomeViewShopToLogin) {
                [self.navigationController popViewControllerAnimated:YES];
            }if (_typeLoginSource == typeTabBarShopToLogin) {
                [self.tabBarController setSelectedIndex:2];
                [self.navigationController popViewControllerAnimated:YES];
            }if (_typeLoginSource == typeTabBarMineToLogin) {
                [self.tabBarController setSelectedIndex:3];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }
 
    } Failure:^(NSError *error) {
       
        
    }];
    

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
