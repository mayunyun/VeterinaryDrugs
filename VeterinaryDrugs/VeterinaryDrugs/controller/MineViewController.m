//
//  MineViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MineViewController.h"
#import "AccountViewController.h"
#import "AddressViewController.h"
#import "MineUserModel.h"
#import "LoginViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UIScrollView* bgScrollView;
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)UICollectionView* collView;
@property (nonatomic,strong)MineUserModel* mineModel;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:IsLogin] isEqualToString:@"1"]) {
        //登录
        [self headerDataRequest];
    }else{
        LoginViewController* loginVC = [[LoginViewController alloc]init];
        loginVC.typeLoginSource = typeTabBarShopToLogin;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}

//创建视图
- (void)creatUI
{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    _bgScrollView.backgroundColor = [UIColor clearColor];
    _bgScrollView.bounces = NO;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];

    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 150)];
    imgView.userInteractionEnabled = YES;
    imgView.backgroundColor = BackColor;
//    imgView.image = [UIImage imageNamed:@"default_img_banner"];
    [_bgScrollView addSubview:imgView];
    UIImageView* localimgView = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth - 100, 20, 20, 30)];
    localimgView.userInteractionEnabled = YES;
    localimgView.backgroundColor = BackColor;
    localimgView.backgroundColor = [UIColor redColor];
    [imgView addSubview:localimgView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(localClick)];
    [localimgView addGestureRecognizer:tap];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BackColor;
    btn.frame = CGRectMake(mScreenWidth - 100 + 20, localimgView.top, 80, 30);
    [btn setTitle:@"上海" forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn addTarget:self action:@selector(localClick) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:btn];
    
    UIButton* setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.backgroundColor = BackColor;
    setBtn.frame = CGRectMake(10, 20, 30, 30);
    setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [setBtn setImage:[UIImage imageNamed:@"sdhsjhds"] forState:UIControlStateNormal];
    [imgView addSubview:setBtn];
    [setBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* headerView = [[UIImageView alloc]initWithFrame:CGRectMake(20, localimgView.bottom + 20, 70, 70)];
    headerView.userInteractionEnabled = YES;
    headerView.layer.masksToBounds = YES;
    headerView.layer.cornerRadius = 35;
    [imgView addSubview:headerView];
    headerView.image = [UIImage imageNamed:@"default_img_banner"];
    headerView.tag = 200;
    UITapGestureRecognizer* headertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImgClick:)];
    [headerView addGestureRecognizer:headertap];
    UILabel* headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(headerView.right+20, headerView.top, 150, 30)];
    headerTitleLabel.text = @"";
    headerTitleLabel.tag = 201;
    headerTitleLabel.backgroundColor = [UIColor redColor];
    [imgView addSubview:headerTitleLabel];
    
    UILabel* moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(headerTitleLabel.left, headerTitleLabel.bottom + 10, headerTitleLabel.width, headerTitleLabel.height - 10)];
    moneyLabel.text = [NSString stringWithFormat:@"￥%@",@"0.20"];
    moneyLabel.tag = 202;
    moneyLabel.font = [UIFont systemFontOfSize:13];
    [imgView addSubview:moneyLabel];
    
    UILabel* moneyBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.left, moneyLabel.bottom, moneyLabel.width, moneyLabel.height)];
    [imgView addSubview:moneyBottomLabel];
    moneyBottomLabel.text = @"可用余额";
    moneyBottomLabel.font = [UIFont systemFontOfSize:13];
    
    UIButton* discountNumLabel = [MineViewController createButtonFrame:CGRectMake(headerTitleLabel.right, moneyLabel.top, 150, moneyLabel.height) Title:[NSString stringWithFormat:@"%@张",@"0"] TitleColor:[UIColor whiteColor] font:13 BgColor:BackColor BgImageName:nil ImageName:nil contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft SeleImage:nil Method:@selector(discountClick) target:self];
    discountNumLabel.tag = 203;
    [imgView addSubview:discountNumLabel];
    
    UIButton* discountLabel =[MineViewController createButtonFrame:CGRectMake(headerTitleLabel.right, discountNumLabel.bottom, discountNumLabel.width, discountNumLabel.height) Title:@"优惠券" TitleColor:[UIColor whiteColor] font:13 BgColor:BackColor BgImageName:nil ImageName:nil contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft SeleImage:nil Method:@selector(discountClick) target:self];
    [imgView addSubview:discountLabel];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, imgView.bottom + 5, mScreenWidth, 492) style:UITableViewStylePlain];
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollEnabled = NO;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgScrollView addSubview:_tbView];
    
    _bgScrollView.contentSize = CGSizeMake(mScreenWidth, 540) ;
}





//点击了上海事件
- (void)localClick
{

}
//点击了back按钮
- (void)backBtnClick:(UIButton*)sender
{
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//点击了头像
- (void)headerImgClick:(UITapGestureRecognizer*)tap
{

}
//点击了优惠券
- (void)discountClick
{

}
//点击了状态img
- (void)stateImageClick:(UITapGestureRecognizer*)tap
{
    UIImageView* imgView = (UIImageView*)tap.view;
    switch (imgView.tag) {
        case 100:
        {
        
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark UITableViewDataasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        
    }
    if (indexPath.row == 0) {
        UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.width, 1)];
        lineLabel.backgroundColor = LineColor;
        [cell.contentView addSubview:lineLabel];
        NSArray* labelTitle = @[@"处理中",@"已完成",@"待评价"];
        for (int i = 0; i < 3; i++) {
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((cell.contentView.width/3-40)/2+cell.contentView.width/3*i, 10, 40, 40)];
            imgView.tag = 100+i;
            [imgView setImage:[UIImage imageNamed:@"ico_03"]];
            [cell.contentView addSubview:imgView];
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stateImageClick:)];
            [imgView addGestureRecognizer:tap];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0+cell.contentView.width/3*i, imgView.bottom, cell.contentView.width/3, 30)];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 100+i;
            label.text = labelTitle[i];
            [cell.contentView addSubview:label];
            UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.width/3*(i+1), 10, 1, 64)];
            line.backgroundColor = LineColor;
            [cell.contentView addSubview:line];
            
        }
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 88 - 1, cell.contentView.width, 1)];
        line.backgroundColor = LineColor;
        [cell.contentView addSubview:line];
        
    }
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"全部订单";
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 - 1, cell.contentView.width, 1)];
        line.backgroundColor = LineColor;
        [cell.contentView addSubview:line];
        
    }
    if (indexPath.row == 2) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0; //列间距
        flowLayout.minimumLineSpacing = 0;      //行间距
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.width, 200) collectionViewLayout:flowLayout];
        _collView.delegate = self;
        _collView.dataSource = self;
        _collView.scrollEnabled = NO;
        _collView.showsVerticalScrollIndicator = NO;
        _collView.showsHorizontalScrollIndicator = NO;
        _collView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:_collView];
        
        [_collView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 88;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 200;
            break;
            
        default:
            return 44;
            break;
    }
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }

}

//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * collCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    CALayer *layer = [collCell layer];
    layer.borderColor = LineColor.CGColor;
    layer.borderWidth = 1.0f;
    NSArray* imgArr = @[@"Personal_01",@"Personal_02",@"Personal_03",@"Personal_04",@"Personal_05",@"Personal_06",@"Personal_07"];
    NSArray* textArr = @[@"我的收藏",@"浏览历史",@"店铺会员",@"附近店铺",@"地址管理",@"账号管理",@"帮助反馈"];
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((collCell.contentView.width - 40)/2 , 0, 40, 40)];
    imgView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    [collCell.contentView addSubview:imgView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, collCell.width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.text = textArr[indexPath.row];
    [collCell.contentView addSubview:label];
    return collCell;
    
}

//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width/4 , 100);
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

//协议中的方法，选中某个单元格时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您选择了第%ld个单元格",(long)indexPath.row);
    
    switch (indexPath.row) {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {
        }
            break;
        case 4:
        {
            //地址管理
            AddressViewController* addVC = [[AddressViewController alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 5:
        {
            //账号管理
            AccountViewController* accountVC = [[AccountViewController alloc]init];
            [self.navigationController pushViewController:accountVC animated:YES];
            
        }
            break;
        case 6:
        {
        }
            break;

            
        default:
            break;
    }
    
    //    [self requestSelarData1];
    //    _collView.dataArr = [[NSArray alloc]initWithArray:_selarArr];
    //    [_collView reloadData];
}

- (void)headerDataRequest
{
    NSString* url = @"index.php";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"member_index" forKey:@"act"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
    [Httptool postWithURL:url Params:params Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*) json;
//        NSLog(@"act=member_index----------%@------%@",dic,params);
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSDictionary* dict = dic[@"datas"][@"member_info"];
            _mineModel = [[MineUserModel alloc]init];
            [_mineModel setValuesForKeysWithDictionary:dict];
            UIImageView* headerImgView = (UIImageView*)[self.view viewWithTag:200];
            [headerImgView sd_setImageWithURL:[NSURL URLWithString:_mineModel.avator] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
            UILabel* titleLabel = (UILabel*)[self.view viewWithTag:201];
            [titleLabel setText:_mineModel.user_name];
            UILabel* predepoitLabel = (UILabel*)[self.view viewWithTag:202];
            [predepoitLabel setText:[NSString stringWithFormat:@"￥%@",_mineModel.predepoit]];
            UIButton* pointLabel = (UIButton*)[self.view viewWithTag:203];
            [pointLabel setTitle:[NSString stringWithFormat:@"%@张",_mineModel.point] forState:UIControlStateNormal];

        }
        else
        {
            [Httptool showCustInfo:nil MessageString:dic[@"datas"][@"error"]];
        }
        
    } Failure:^(NSError *error) {
        
        
    }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(UIButton*)createButtonFrame:(CGRect)frame Title:(NSString*)title TitleColor:(UIColor *)color font:(CGFloat)font BgColor:(UIColor *)bgColor BgImageName:(NSString*)bgImageName ImageName:(NSString*)imageName  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment SeleImage:(NSString *)sImage Method:(SEL)sel target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setBackgroundColor:bgColor];
    [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:sImage] forState:UIControlStateSelected];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = contentHorizontalAlignment;
    return button;
}



//#pragma mark webView
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    WebViewController* webViewVC = [[WebViewController alloc]init];
//    webViewVC.weburl = [NSString stringWithFormat:@"%@/user.html",ShouYaoWapServer];
//    [self.navigationController pushViewController:webViewVC animated:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
//}


@end
