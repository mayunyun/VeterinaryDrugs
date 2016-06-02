//
//  AddressViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AddressViewController.h"
#import "MineUserModel.h"
#import "AddAddressViewController.h"
@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _flag;
}
@property (nonatomic,strong)UIView* bgRightView;
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)UIView* noneView;
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)UIView* cellBgView;
@property (nonatomic,strong)UILabel* nameLabel;
@property (nonatomic,strong)UILabel* addressLabel;
@property (nonatomic,strong)UILabel* addressDetailLabel;
@property (nonatomic,strong)UILabel* telLabel;
@property (nonatomic,strong)UIButton* editBtn;
@property (nonatomic,strong)UIButton* delBtn;


@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.title = @"地址管理";
    [self creatUI];
    [self addressRequestData];
    
}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.rowHeight = 130;
    [self setExtraCellLineHidden:_tbView];
    [self.view addSubview:_tbView];
    _noneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49)];
    _noneView.hidden = YES;
    _noneView.backgroundColor = TabBarColor;
    [self.view addSubview:_noneView];
    UILabel* nonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, mScreenWidth - 20, 44)];
    nonelabel.text = @"暂无记录";
    [_noneView addSubview:nonelabel];
    
    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(20, mScreenHeight - 64 - 49, mScreenWidth - 40, 40);
    addBtn.backgroundColor = [UIColor redColor];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 10;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!IsEmptyValue(_dataArray)) {
        _noneView.hidden = YES;
        return _dataArray.count;
    }else{
        _noneView.hidden = NO;
        return 0;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.frame = CGRectMake(0, 0, mScreenWidth, 130);
    _cellBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, cell.contentView.width - 20, cell.contentView.height - 10)];
    [cell.contentView addSubview:_cellBgView];
    CALayer *layer = [_cellBgView layer];
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = .5f;
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _cellBgView.width, 30)];
    [_cellBgView addSubview:_nameLabel];
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _nameLabel.bottom, _cellBgView.width, 30)];
    [_cellBgView addSubview:_addressLabel];
    
    _addressDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _addressLabel.bottom, _cellBgView.width, 30)];
    [_cellBgView addSubview:_addressDetailLabel];
    
    _telLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _addressDetailLabel.bottom, _cellBgView.width, 30)];
    [_cellBgView addSubview:_telLabel];

    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(_cellBgView.width - 100, _addressDetailLabel.bottom, 100, 30)];
    [_cellBgView addSubview:view];
    _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _editBtn.frame = CGRectMake(0, 0, 49, 30);
    _editBtn.tag = 100+indexPath.row;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [view addSubview:_editBtn];
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_editBtn.right, 0, 2, view.height)];
    lineLabel.backgroundColor = [UIColor redColor];
    [view addSubview:lineLabel];
    _delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _delBtn.tag = 200+indexPath.row;
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    _delBtn.frame = CGRectMake(lineLabel.right, 0, 49, view.height);
    [view addSubview:_delBtn];
    [_delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (!IsEmptyValue(_dataArray)) {
        MineUserAddressListModel* model = _dataArray[indexPath.row];
        _nameLabel.text = model.true_name;
        _addressLabel.text = model.area_info;
        _addressDetailLabel.text = model.address;
        _telLabel.text = model.mob_phone;
    }else{
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)editBtnClick:(UIButton*)sender
{
    AddAddressViewController* addAddVC = [[AddAddressViewController alloc]init];
    addAddVC.typeAddAddress = typeEdit;
    [self.navigationController pushViewController:addAddVC animated:YES];
}
- (void)delBtnClick:(UIButton*)sender
{
    [self deleDataAddList:(sender.tag - 200)];
}

- (void)addBtnClick:(UIButton*)sender
{
    AddAddressViewController* addAddVC = [[AddAddressViewController alloc]init];
    addAddVC.typeAddAddress = typeAdd;
    [self.navigationController pushViewController:addAddVC animated:YES];

}

#pragma mark NavClick
- (void)leftBarClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 数据请求
- (void)addressRequestData
{
    //index.php?act=member_address&op=address_list
    NSString* url = @"index.php?act=member_address&op=address_list";
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserName] forKey:@"username"];
    [params setObject:@"ios" forKey:@"client"];
    [Httptool postWithURL:url Params:params Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*)json;
        NSLog(@"addRequestData ----- %@",dic);
        if ([dic[@"code"] integerValue] == kHttpStatusOK) {
            [_dataArray removeAllObjects];
            NSArray* array = dic[@"datas"][@"address_list"];
            for (int i = 0; i < array.count; i++) {
                MineUserAddressListModel* model = [[MineUserAddressListModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_dataArray addObject:model];
            }
            [_tbView reloadData];
            
        }
    } Failure:^(NSError *error) {
        
    }];
    
    
}

- (void)deleDataAddList:(NSInteger)index
{
    if (!IsEmptyValue(_dataArray)) {
        MineUserAddressListModel* model = _dataArray[index];
        NSString* url = @"index.php?act=member_address&op=address_del";
        NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
        [parmas setObject:model.address_id forKey:@"address_id"];
        [parmas setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserKey] forKey:@"key"];
        [Httptool postWithURL:url Params:parmas Success:^(id json, HttpCode code) {
            NSDictionary* dic = (NSDictionary*)json;
            if ([dic[@"code"] integerValue] == kHttpStatusOK) {
                //删除
                NSLog(@"_dataArray---%@",_dataArray);
                [_dataArray removeObjectAtIndex:index];
                NSLog(@"_dataArray--------%@",_dataArray);
                [_tbView reloadData];
                
            }
            
        } Failure:^(NSError *error) {
            
        }];
        
    }
    
    
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
