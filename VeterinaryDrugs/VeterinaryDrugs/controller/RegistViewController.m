//
//  RegistViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "RegistViewController.h"
#import "WebViewController.h"
#import "LoginViewController.h"
@interface RegistViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField* nameTextField;
@property (nonatomic,strong)UITextField* FirstPwdTextField;
@property (nonatomic,strong)UITextField* SecondPwdTextField;
@property (nonatomic,strong)UITextField* EmailTextField;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self initNav];
    [self creatUI];
}

- (void)initNav
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 35, 35);
    [leftBtn setImage:[UIImage imageNamed:@"sdhsjhds"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(mScreenHeight - 40, 12, 40, 25);
    [setButton setTitle:@"登录" forState:UIControlStateNormal];
    setButton.backgroundColor = [UIColor clearColor];
    setButton.showsTouchWhenHighlighted = YES;
    [setButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)creatUI
{
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    bgView.backgroundColor = TabBarColor;
    [self.view addSubview:bgView];
    
    UIView* usernameView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, mScreenWidth - 20, 44)];
    usernameView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:usernameView];
    UIImageView* nameImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
    [nameImgView setImage:[UIImage imageNamed:@"login_01"]];
    [usernameView addSubview:nameImgView];
    _nameTextField  = [[UITextField alloc]initWithFrame:CGRectMake(45, 0, usernameView.width - 45, usernameView.height)];
    _nameTextField.placeholder = @"请输入用户名";
    _nameTextField.delegate = self;
    [usernameView addSubview:_nameTextField];
    
    UIView* firstPwdView = [[UIView alloc]initWithFrame:CGRectMake(usernameView.left, usernameView.bottom+10, usernameView.width, usernameView.height)];
    firstPwdView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:firstPwdView];
    UIImageView* firstPwdImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
    [firstPwdImgView setImage:[UIImage imageNamed:@"login_02"]];
    [firstPwdView addSubview:firstPwdImgView];
    _FirstPwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(_nameTextField.left, 0, _nameTextField.width, _nameTextField.height)];
    _FirstPwdTextField.placeholder = @"请输入密码";
    _FirstPwdTextField.delegate = self;
    [firstPwdView addSubview:_FirstPwdTextField];
    
    UIView* scoundPwdView = [[UIView alloc]initWithFrame:CGRectMake(usernameView.left, firstPwdView.bottom+10, usernameView.width, usernameView.height)];
    scoundPwdView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:scoundPwdView];
    UIImageView* scoundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
    [scoundImgView setImage:[UIImage imageNamed:@"login_02"]];
    [scoundPwdView addSubview:scoundImgView];
    _SecondPwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(_nameTextField.left, 0, _nameTextField.width, _nameTextField.height)];
    _SecondPwdTextField.delegate = self;
    _SecondPwdTextField.placeholder = @"确认密码";
    [scoundPwdView addSubview:_SecondPwdTextField];

    UIView* emailView = [[UIView alloc]initWithFrame:CGRectMake(usernameView.left, scoundPwdView.bottom+10, usernameView.width, usernameView.height)];
    [bgView addSubview:emailView];
    emailView.backgroundColor = [UIColor whiteColor];
    UIImageView* emailImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
    [emailImgView setImage:[UIImage imageNamed:@"login_02"]];
    [emailView addSubview:emailImgView];
    _EmailTextField = [[UITextField alloc]initWithFrame:CGRectMake(_nameTextField.left, 0, _nameTextField.width, _nameTextField.height)];
    _EmailTextField.delegate = self;
    _EmailTextField.placeholder = @"请输入邮箱";
    [emailView addSubview:_EmailTextField];
    
    //同意协议勾选视图
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(usernameView.left, emailView.bottom + 10, 150, 20)];
    aView.backgroundColor = [UIColor clearColor];
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(0, aView.height - 13, 13, 13)];
    img.image = [UIImage imageNamed:@"rg_r1_c1"];
    [aView addSubview:img];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(img.right+5, aView.height - 13, 150-img.right-5, 13)];
    lab.text = @"同意《兽药电商网协议》";
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = [UIColor colorWithHexString:@"746e7c"];
    [self changeTextColor:lab Txt:lab.text changeTxt:@"《兽药电商网协议》"];
    [aView addSubview:lab];
    [self.view addSubview:aView];
    
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeTapGesture:)];
    aView.userInteractionEnabled = YES;
    [aView addGestureRecognizer:aTap];
    //注册按钮
    UIButton* registVC = [UIButton buttonWithType:UIButtonTypeSystem];
    registVC.frame = CGRectMake(5, aView.bottom+10, bgView.width - 10, 44);
    [registVC setTitle:@"注册" forState:UIControlStateNormal];
    [registVC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [registVC setBackgroundColor:NavBarColor];
    [bgView addSubview:registVC];
    [registVC addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1683fb"] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}

- (void)agreeTapGesture:(UITapGestureRecognizer *)gesture
{
    WebViewController* payVC = [[WebViewController alloc]init];
    payVC.weburl = [NSString stringWithFormat:@"%@/register.html",ShouYaoWapServer];
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)registBtnClick:(UIButton*)sender
{

}
- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
