//
//  ShopViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopModel.h"
#import "ShopViewCell.h"
#import "LoginViewController.h"

@interface ShopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_willPay;
    UIButton *_payBtn;
}


@property(nonatomic,retain)UITableView *shopTableView;


@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
//    ShopModel *model = [[ShopModel alloc]init];
//    [model setValue:@"山东中抗药业有限公司" forKey:@"store_name"];
//    [model setValue:@"硫酸阿托品注射液" forKey:@"goods_name"];
//    [model setValue:@"0.01" forKey:@"goods_price"];
//    [model setValue:@"http://192.168.1.41/newsoyaom/data/upload/shop/common/default_goods_image_240.gif" forKey:@"goods_image_url"];
//    [model setValue:@"10" forKey:@"goods_num"];
//    [model setValue:@"0.1" forKey:@"goods_sum"];
//    ShopModel *model1 = [[ShopModel alloc]init];
//    [model1 setValue:@"我的网站" forKey:@"store_name"];
//    [model1 setValue:@"名称范德萨" forKey:@"goods_name"];
//    [model1 setValue:@"12.00" forKey:@"goods_price"];
//    [model1 setValue:@"http://192.168.1.41/newsoyaom/data/upload/shop/store/goods/1/1_1611151307tb2dh9xx___894224787_240.jpg" forKey:@"goods_image_url"];
//    [model1 setValue:@"4" forKey:@"goods_num"];
//    [model1 setValue:@"48" forKey:@"goods_sum"];
//    [_dataArray addObject:model];
//    [_dataArray addObject:model1];
    
    [self creatUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:IsLogin] isEqualToString:@"1"]) {
        //登录
        [self dataRequest];
    }else{
    LoginViewController* loginVC = [[LoginViewController alloc]init];
    loginVC.typeLoginSource = typeTabBarShopToLogin;
    [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)creatUI{

    self.shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 70 - 49)];
    self.shopTableView.dataSource = self;
    self.shopTableView.delegate = self;
    self.shopTableView.rowHeight = 110;
    [self.view addSubview:self.shopTableView];
    //tableView的footView
    UIView *footBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 60)];
    footBack.backgroundColor = LineColor;
    self.shopTableView.tableFooterView = footBack;
    
    UILabel *title1  = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth- 130, 0, 60, 30)];
    title1.font = [UIFont systemFontOfSize:14];
    title1.textAlignment = NSTextAlignmentCenter;
    title1.textColor = [UIColor lightGrayColor];
    title1.text = @"运费";
    [footBack addSubview:title1];
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth - 130, 30, 60, 30)];
    _label1.font = [UIFont systemFontOfSize:14];
    _label1.textColor = [UIColor redColor];
    _label1.textAlignment = NSTextAlignmentCenter;
    [footBack addSubview:_label1];
    _label1.text = @"¥0.00";
    //
    UILabel *title2  = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth- 70, 0, 60, 30)];
    title2.font = [UIFont systemFontOfSize:14];
    title2.textAlignment = NSTextAlignmentCenter;
    title2.textColor = [UIColor lightGrayColor];
    title2.text = @"商品金额";
    [footBack addSubview:title2];
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth - 70, 30, 60, 30)];
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.textColor = [UIColor redColor];
    _label2.textAlignment = NSTextAlignmentCenter;
    [footBack addSubview:_label2];
    
    //底部视图
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, mScreenHeight - 64 - 70 -49, mScreenWidth, 70)];
    bottom.backgroundColor = LineColor;
    [self.view addSubview:bottom];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 10, mScreenWidth, 1)];
    topline.backgroundColor = [UIColor lightGrayColor];
    [bottom addSubview:topline];
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, 60, mScreenWidth, 1)];
    botline.backgroundColor = [UIColor lightGrayColor];
    [bottom addSubview:botline];
    
    UILabel *payTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 50)];
    payTitle.font = [UIFont systemFontOfSize:14];
    payTitle.text = @"应付金额";
    [bottom addSubview:payTitle];
    _willPay = [[UILabel alloc] initWithFrame:CGRectMake(payTitle.right, 10, 100, 50)];
    _willPay.font = [UIFont systemFontOfSize:16];
    _willPay.textColor = [UIColor redColor];
    [bottom addSubview:_willPay];
    //结算按钮
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(mScreenWidth - 90, 20, 80, 30);
    [_payBtn.layer setCornerRadius:5];
    [_payBtn setBackgroundColor:[UIColor redColor]];
    [_payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_payBtn addTarget:self action:@selector(payMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:_payBtn];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"cell_shop";
    ShopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (ShopViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"ShopViewCell" owner:self options:nil]firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    ShopModel *model = _dataArray[indexPath.row];
    
    
    UIButton *reduce = [UIButton buttonWithType:UIButtonTypeCustom];
    reduce.frame = CGRectMake(cell.imgView.right + 10, cell.price.bottom, 30, 25);
    [reduce setBackgroundColor:LineColor];
    [reduce setTitle:@"-" forState:UIControlStateNormal];
    [reduce setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reduce addTarget:self action:@selector(reduce:) forControlEvents:UIControlEventTouchUpInside];
    reduce.tag = indexPath.row;
    [cell.contentView addSubview:reduce];
    
    UITextField *count = [[UITextField alloc] initWithFrame:CGRectMake(cell.imgView.right + 40, reduce.top, 50, 25)];
    count.font = [UIFont systemFontOfSize:14];
    count.textAlignment = NSTextAlignmentCenter;
    [count.layer setBorderWidth:.5];
    [count.layer setBorderColor:LineColor.CGColor];
    count.text = model.goods_num;
    count.tag = indexPath.row;
    [cell.contentView addSubview:count];
    
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(cell.imgView.right + 90, cell.price.bottom, 30, 25);
    [add setBackgroundColor:LineColor];
    [add setTitle:@"+" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    add.tag = indexPath.row;
    [cell.contentView addSubview:add];
    
    
    UIButton *del = [UIButton buttonWithType:UIButtonTypeCustom];
    del.frame = CGRectMake(mScreenWidth - 40, cell.price.bottom, 30, 25);
    [del setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    [del addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    del.tag = indexPath.row;
    [cell.contentView addSubview:del];
    
    
    
    return cell;

}
- (void)refreshView{
    [self.shopTableView reloadData];
}

- (void)reduce:(UIButton *)btn{
    
    ShopModel *model = _dataArray[btn.tag];
    NSInteger count = [model.goods_num integerValue];
    double good_price = [model.goods_price doubleValue];
    count = count - 1;
    double sum = count * good_price;
    model.goods_num = [NSString stringWithFormat:@"%zi",count];
    model.goods_sum = [NSString stringWithFormat:@"%.2f",sum];
    
    [self refreshView];
    [self getSum];
}
- (void)add:(UIButton *)btn{
    ShopModel *model = _dataArray[btn.tag];
    NSInteger count = [model.goods_num integerValue];
    double good_price = [model.goods_price doubleValue];
    count = count + 1;
    double sum = count * good_price;
    model.goods_num = [NSString stringWithFormat:@"%zi",count];
    model.goods_sum = [NSString stringWithFormat:@"%.2f",sum];
    [self refreshView];
    [self getSum];
}
- (void)del:(UIButton *)btn{
    
    
}

- (void)payMoneyBtn:(UIButton*)sender
{

}

- (void)getSum{
    
    double sum = 0;
    for (ShopModel *model in _dataArray) {
        sum = sum + [model.goods_sum doubleValue];
    }
    _label2.text = [NSString stringWithFormat:@"¥%.2f",sum];
    _willPay.text = [NSString stringWithFormat:@"¥%.2f",sum];
}

- (void)dataRequest{
    /*
     act=member_cart
     op=cart_list
    
     */
    NSString *url = @"index.php";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"member_cart" forKey:@"act"];
    [params setObject:@"cart_list" forKey:@"op"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
    [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kLoginUserName] forKey:@"username"];
    [params setObject:@"ios" forKey:@"client"];
    [Httptool postWithURL:url Params:params Success:^(id json, HttpCode code) {
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"gou%@",dic);
      
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK){
            NSLog(@"购物车!!!!!!!!!!!===========%@",dic);
            [_dataArray removeAllObjects];
            NSArray* dataArr = dic[@"datas"][@"cart_list"];
            for (int i = 0; i < dataArr.count; i++) {
                ShopModel* model = [[ShopModel alloc]init];
                [model setValuesForKeysWithDictionary:dataArr[i]];
                [_dataArray addObject:model];
            }
            [self getSum];
            [self.shopTableView reloadData];
            
        }else{
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
        
    }];
    


}

//#pragma mark webView
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    WebViewController* webViewVC = [[WebViewController alloc]init];
//    webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/cart_list.html",ShouYaoWapServer];
//    [self.navigationController pushViewController:webViewVC animated:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



@end
