//
//  AddAddressViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/6/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddAddressProvCityTownModel.h"

@interface AddAddressViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString* _prov_id;
    NSString* _city_id;
}
@property (nonatomic,strong)UITableView* provtbView;
@property (nonatomic,strong)UITableView* citytbView;
@property (nonatomic,strong)UITableView* towntbView;
@property (nonatomic,strong)NSMutableArray* provArray;
@property (nonatomic,strong)NSMutableArray* cityArray;
@property (nonatomic,strong)NSMutableArray* townArray;
@property (nonatomic,strong)UITextView* streetTextView;
@property (nonatomic,strong)UIView* m_keHuPopView;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _provArray = [[NSMutableArray alloc]init];
    _cityArray = [[NSMutableArray alloc]init];
    _townArray = [[NSMutableArray alloc]init];
    if (_typeAddAddress == 0) {
        self.title = @"添加地址";
    }else{
        self.title = @"编辑地址";
    }
    
    [self creatUI];
    
    
    
}

- (void)creatUI
{
    self.view.backgroundColor = TabBarColor;
    UIScrollView* bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    bgScrollView.scrollsToTop = NO;
    bgScrollView.bounces = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.contentSize = CGSizeMake(mScreenWidth, 740);
    [self.view addSubview:bgScrollView];
    UIView* userView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, mScreenWidth - 10, 300)];
    [bgScrollView addSubview:userView];
    [self creatLabelTag:userView text:@"收货人信息"];
    UIView* textFView = [[UIView alloc]initWithFrame:CGRectMake(20, 40, userView.width - 20, userView.height - 40)];
    [userView addSubview:textFView];
    NSArray* userLabelTextArr = @[@"姓名：（*必填）",@"手机号码：（*必填）",@"电话号码："];
    for (int i = 0; i < 3; i ++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*i, textFView.width, 40)];
        label.text = userLabelTextArr[i];
        [textFView addSubview:label];
        if (i!=2) {
            [self changeTextColor:label Txt:label.text changeTxt:@"（*必填）"];
        }
        UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 40+80*i, textFView.width, 40)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.tag = 100+i;
        textField.delegate = self;
        [textFView addSubview:textField];
    }
    
    
    UIView* addressView = [[UIView alloc]initWithFrame:CGRectMake(userView.left, userView.bottom, userView.width, 500)];
    [bgScrollView addSubview:addressView];
    [self creatLabelTag:addressView text:@"地址信息"];
    UIView* addBtnView = [[UIView alloc]initWithFrame:CGRectMake(20, 40, addressView.width - 20, addressView.height)];
    [addressView addSubview:addBtnView];
    NSArray* addTextLabelArr = @[@"省份：（*必填）",@"城市：（*必填）",@"区县：（*必填）",@"街道：（*必填）"];
    for (int i = 0; i < 4; i ++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*i, addBtnView.width, 40)];
        label.text = addTextLabelArr[i];
        [addBtnView addSubview:label];
        [self changeTextColor:label Txt:label.text changeTxt:@"（*必填）"];
        if (i == 3) {
            _streetTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 40+80*i, addBtnView.width, 100)];
            [addBtnView addSubview:_streetTextView];
        }else{
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(0, 40+80*i, addBtnView.width, 40);
            [btn setTitle:@"请选择..." forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            btn.tag = 200+i;
            [addBtnView addSubview:btn];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width - 20, btn.top+10, 20, 20)];
            imgView.userInteractionEnabled = YES;
            imgView.image = [UIImage imageNamed:@"rg_r1_c1"];
            [btn addSubview:imgView];
        }
    }
    UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendBtn setBackgroundColor:[UIColor redColor]];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:sendBtn action:@selector(SendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    
    
}
- (void)creatLabelTag:(UIView*)bgView text:(NSString*)text
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 40)];
    [bgView addSubview:view];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, bgView.width-20, view.height)];
    label.text = text;
    [view addSubview:label];
    
    UILabel* redLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, view.height)];
    redLabel.backgroundColor = [UIColor redColor];
    [view addSubview:redLabel];

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
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}

#pragma mark NavClick
- (void)leftBarClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick:(UIButton*)sender
{
    if (sender.tag == 201) {
        if (!IsEmptyValue(_prov_id)) {
            [self creatTableViewUI:(sender.tag - 200)];
        }else{
            [Httptool showCustInfo:@"提示" MessageString:@"请先选择省份"];
        }
        
    }else if (sender.tag == 202){
        if (!IsEmptyValue(_prov_id)&&!IsEmptyValue(_city_id)) {
            [self creatTableViewUI:(sender.tag - 200)];
        }else if(!IsEmptyValue(_prov_id)){
            [Httptool showCustInfo:@"提示" MessageString:@"请先选择城市"];
        }else{
            [Httptool showCustInfo:@"提示" MessageString:@"请先选择省份，城市"];
        }
    
    }else{
        [self creatTableViewUI:(sender.tag - 200)];
    }

    
}

- (void)SendBtnClick:(UIButton*)sender
{
    [self saveAddRequestData];
}


- (void)creatTableViewUI:(NSInteger)index
{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.m_keHuPopView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.m_keHuPopView];
    
    UIView* bgView = [[UIView alloc]initWithFrame:self.m_keHuPopView.bounds];
    bgView.backgroundColor = [UIColor grayColor];
    bgView.alpha = 0.5;
    [self.m_keHuPopView addSubview:bgView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(KHclosePop)];
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
    
    UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 30, mScreenWidth-120, mScreenHeight - 174 -30)];
    windowView.backgroundColor = [UIColor whiteColor];
    windowView.layer.cornerRadius = 10.0;
    windowView.layer.masksToBounds = YES;
    windowView.userInteractionEnabled = YES;
    [self.m_keHuPopView addSubview:windowView];
    
    UIView* cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
    cancelView.backgroundColor  =[UIColor grayColor];
    [windowView addSubview:cancelView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(cancelView.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(KHclosePop) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:btn];
    
    switch (index) {
        case 0:
        {
            if (self.provtbView == nil) {
                self.provtbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, mScreenWidth-120, mScreenHeight-174) style:UITableViewStylePlain];
                self.provtbView.backgroundColor = [UIColor grayColor];
                
            }
            self.provtbView.dataSource = self;
            self.provtbView.delegate = self;
            [windowView addSubview:self.provtbView];
            [self provRequestData];
        }
            break;
        case 1:
        {
                if (self.citytbView == nil) {
                    self.citytbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, mScreenWidth - 120, mScreenHeight - 174) style:UITableViewStylePlain];
                    self.citytbView.backgroundColor = [UIColor grayColor];
                }
                self.citytbView.delegate = self;
                self.citytbView.dataSource = self;
                [windowView addSubview:self.citytbView];
                [self cityRequestData];

        }
            break;
        case 2:
        {
                if (self.towntbView == nil) {
                    self.towntbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, mScreenWidth - 120, mScreenHeight - 174) style:UITableViewStylePlain];
                    self.towntbView.backgroundColor = [UIColor grayColor];
                }
                self.towntbView.delegate = self;
                self.towntbView.dataSource = self;
                [windowView addSubview:self.towntbView];
                [self townRequestData];
            
            
        }
            break;
            
        default:
            break;
    }


}

- (void)KHclosePop
{
    [self.m_keHuPopView removeFromSuperview];
}

#pragma mark UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _provtbView) {
        if (IsEmptyValue(_provArray)) {
            return 0;
        }else{
            return _provArray.count;
        }
    }else if (tableView == _citytbView){
        if (IsEmptyValue(_cityArray)) {
            return 0;
        }else{
            return _cityArray.count;
        }
    }else{
        if (IsEmptyValue(_townArray)) {
            return 0;
        }else{
            return _townArray.count;
        }
    
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView == _provtbView) {
        AddAddressProvCityTownModel* model = _provArray[indexPath.row];
        cell.textLabel.text = model.area_name;
    }else if (tableView == _citytbView){
        AddAddressProvCityTownModel* model = _cityArray[indexPath.row];
        cell.textLabel.text = model.area_name;
    }else{
        AddAddressProvCityTownModel* model = _townArray[indexPath.row];
        cell.textLabel.text = model.area_name;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _provtbView) {
        AddAddressProvCityTownModel* model = _provArray[indexPath.row];
         _prov_id = model.area_id;
        UIButton* btn = (UIButton*)[self.view viewWithTag:200];
        [btn setTitle:model.area_name forState:UIControlStateNormal];
        
        [self.m_keHuPopView removeFromSuperview];
    }else if (tableView == _citytbView){
        AddAddressProvCityTownModel* model = _cityArray[indexPath.row];
        _city_id = model.area_id;
        UIButton* btn = (UIButton*)[self.view viewWithTag:201];
        [btn setTitle:model.area_name forState:UIControlStateNormal];
        [self.m_keHuPopView removeFromSuperview];
    }else{
        AddAddressProvCityTownModel* model = _townArray[indexPath.row];
        UIButton* btn = (UIButton*)[self.view viewWithTag:202];
        [btn setTitle:model.area_name forState:UIControlStateNormal];
        [self.m_keHuPopView removeFromSuperview];
    }

}


- (void)provRequestData
{
    NSString* url = @"index.php?act=member_address&op=area_list";
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
    [Httptool postWithURL:url Params:parmas Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*)json;
        if ([dic[@"code"] integerValue] == kHttpStatusOK) {
            NSLog(@"provRequestDatadic------%@",dic);
            NSArray* areaListArr = dic[@"datas"][@"area_list"];
            [_provArray removeAllObjects];
            for (int i = 0; i < areaListArr.count; i ++) {
                AddAddressProvCityTownModel* model = [[AddAddressProvCityTownModel alloc]init];
                [model setValuesForKeysWithDictionary:areaListArr[i]];
                [_provArray addObject:model];
            }
            [_provtbView reloadData];
        }
    } Failure:^(NSError *error) {
        
    }];
    

}

- (void)cityRequestData
{
    NSString* url = @"index.php?act=member_address&op=area_list";
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
    [parmas setObject:_prov_id forKey:@"area_id"];
     NSLog(@"cityRequestDataparmas%@",parmas);
    [Httptool postWithURL:url Params:parmas Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*)json;
        if ([dic[@"code"] integerValue] == kHttpStatusOK) {
            NSLog(@"cityRequestDatadic------%@",dic);
            NSArray* areaListArr = dic[@"datas"][@"area_list"];
            [_cityArray removeAllObjects];
            for (int i = 0; i < areaListArr.count; i ++) {
                AddAddressProvCityTownModel* model = [[AddAddressProvCityTownModel alloc]init];
                [model setValuesForKeysWithDictionary:areaListArr[i]];
                [_cityArray addObject:model];
            }
            [_citytbView reloadData];
        }
    } Failure:^(NSError *error) {
        
    }];

}

- (void)townRequestData
{
    NSString* url = @"index.php?act=member_address&op=area_list";
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
    [parmas setObject:_city_id forKey:@"area_id"];
//    NSLog(@"townRequestDataparmas%@",parmas);
    [Httptool postWithURL:url Params:parmas Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*)json;
        if ([dic[@"code"] integerValue] == kHttpStatusOK) {
//            NSLog(@"townRequestDatadic------%@",dic);
            NSArray* areaListArr = dic[@"datas"][@"area_list"];
            [_townArray removeAllObjects];
            for (int i = 0; i < areaListArr.count; i ++) {
                AddAddressProvCityTownModel* model = [[AddAddressProvCityTownModel alloc]init];
                [model setValuesForKeysWithDictionary:areaListArr[i]];
                [_townArray addObject:model];
            }
            [_towntbView reloadData];
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (void)saveAddRequestData
{
    UITextField* nameField = (UITextField*)[self.view viewWithTag:100];
    UITextField* mobileField = (UITextField*)[self.view viewWithTag:101];
    UITextField* phoneField = (UITextField*)[self.view viewWithTag:102];
    UIButton* provBtn = (UIButton*)[self.view viewWithTag:200];
    UIButton* cityBtn = (UIButton*)[self.view viewWithTag:201];
    UIButton* townBtn = (UIButton*)[self.view viewWithTag:202];
    NSString* url = @"index.php?act=member_address&op=address_add";
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
//    if (!IsEmptyValue(nameField.text)&&!IsEmptyValue(mobileField.text)&&!IsEmptyValue(phoneField.text)&&!IsEmptyValue(_city_id)&&!IsEmptyValue(_prov_id)&&!IsEmptyValue(_streetTextView.text)&&!IsEmptyValue(provBtn.titleLabel.text)&&!IsEmptyValue(<#id thing#>)&&&&&&) {
//        
//    }
    [parmas setObject:nameField.text forKey:@"true_name"];
    [parmas setObject:mobileField.text forKey:@"mob_phone"];
    [parmas setObject:phoneField.text forKey:@"tel_phone"];
    [parmas setObject:_city_id forKey:@"city_id"];
    [parmas setObject:_prov_id forKey:@"area_id"];
    [parmas setObject:_streetTextView.text forKey:@"address"];
    [parmas setObject:[NSString stringWithFormat:@"%@ %@ %@",provBtn.titleLabel.text ,cityBtn.titleLabel.text,townBtn.titleLabel.text] forKey:@"area_info"];
    [Httptool postWithURL:url Params:parmas Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*)json;
        if ([dic[@"code"] integerValue] == kHttpStatusOK) {
            NSLog(@"saveAddRequestDatadic-------%@",dic);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
