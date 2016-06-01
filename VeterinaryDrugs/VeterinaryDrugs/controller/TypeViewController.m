//
//  TypeViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "TypeViewController.h"
#import "MBProgressHUD.h"
#import "TypeDetailCollViewCell.h"
#import "TypeListModel.h"
#import "MyNavViewController.h"
#import "HomeViewController.h"

@interface TypeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    MBProgressHUD* _hud;
}
@property (nonatomic,strong)UITableView* listTableView;
@property (nonatomic,strong)UICollectionView* detailCollView;
@property(nonatomic,retain)NSMutableArray* listArray;
@property(nonatomic,retain)NSMutableArray* detailArray;

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"商品分类";
    UIBarButtonItem* backBar = [MyNavViewController backBarButtonItemTarget:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItem = backBar;
    self.navigationController.navigationBar.backgroundColor = TabLableTextColor;
    _listArray = [[NSMutableArray alloc]init];
    _detailArray = [[NSMutableArray alloc]init];
    [self creatUI];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
    [self listdataRequest];
    [self requestDetailData];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)creatUI
{
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth*0.35, mScreenHeight) style:UITableViewStylePlain];
    _listTableView.bounces = NO;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.showsHorizontalScrollIndicator = NO;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.scrollsToTop = NO;
    [self.view addSubview:_listTableView];
    [self setExtraCellLineHidden:_listTableView];
    [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5; //列间距
    flowLayout.minimumLineSpacing = 5;      //行间距
    _detailCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(mScreenWidth*0.35, 0, mScreenWidth*0.65,  mScreenHeight - 64)collectionViewLayout:flowLayout];
    _detailCollView.contentSize = CGSizeMake(_detailCollView.width, _detailCollView.height);
    _detailCollView.backgroundColor = [UIColor whiteColor];
    _detailCollView.showsVerticalScrollIndicator = NO;
    _detailCollView.showsHorizontalScrollIndicator = NO;
    _detailCollView.delegate = self;
    _detailCollView.dataSource = self;
    _detailCollView.scrollsToTop = YES;
    _detailCollView.scrollEnabled = YES;
    [self.view addSubview:_detailCollView];
    [_detailCollView registerNib:[UINib nibWithNibName:@"TypeDetailCollViewCell" bundle:nil] forCellWithReuseIdentifier:@"TypeDetailCollViewCellID"];
    
    
    
    
    
}
- (void)btnBackClick:(UIBarButtonItem*)sender
{
    [self.tabBarController setSelectedIndex:0];
}

//取消多余cell
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark --- UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    TypeListModel* model = _listArray[indexPath.row];
    cell.textLabel.text = model.gc_name;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    if ([model.select  isEqual: @"1"]) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_selected_bg"]];
        
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    }
    return cell;

}
#pragma mark --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld个cell",(long)indexPath.row);
    for (int i =0; i < _listArray.count; i++) {
        TypeListModel* model = _listArray[i];
        if (indexPath.row == i) {
            model.select = @"1";
        }else{
            model.select = @"0";
        }
    }
    [_listTableView reloadData];
    _listTableView.contentSize = CGSizeMake(_listTableView.width, _listArray.count*49);
}

#pragma mark UICollectionViewDelegateFlowLayout
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return CGSizeMake(collectionView.width/2-5, 150);
    
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
        return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
#pragma mark UICollectionDatasource
//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _detailArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    TypeDetailCollViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TypeDetailCollViewCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    TypeDetailModel* model = _detailArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
    cell.titleLabel.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    
    return cell;
    
}

#pragma mark UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld个单元格",(long)indexPath.row);
    
}


#pragma mark ---dataRequest
- (void)listdataRequest
{
    //index.php?act=goods_class&callback=jQuery18307126728408038616_1464584787493&_=1464584787536
    NSString* url = @"index.php?act=goods_class";
    
    [Httptool postWithURL:url Params:nil Success:^(id json, HttpCode code) {
        NSDictionary* dic = (NSDictionary*) json;
        
//        NSLog(@"typedic----------%@",dic);
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSArray* listArr = dic[@"datas"][@"class_list"];
            [_listArray removeAllObjects];
            for (int i = 0; i <listArr.count; i++) {
                TypeListModel * model = [[TypeListModel alloc]init];
                [model setValuesForKeysWithDictionary:listArr[i]];
                if (i == 0) {
                    [model setValue:@"1" forKey:@"select"];
                }else{
                    [model setValue:@"0" forKey:@"select"];
                }
                [_listArray addObject:model];
            }
            [_listTableView reloadData];
            _listTableView.contentSize = CGSizeMake(_listTableView.width, _listArray.count*49);
           
        }
        else
        {
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }

        
        [_hud hide:YES];
        
    } Failure:^(NSError *error) {
        [_hud hide:YES];
        
    }];
    
}

- (void)requestDetailData
{
    NSString* url = @"index.php?act=store&op=goods_list&key=4&page=7&curpage=1&store_id=7";
    [Httptool postWithURL:url Params:nil Success:^(id json, HttpCode code) {
        NSDictionary *dic = (NSDictionary *)json;
        
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSLog(@"requestSelarData%@",dic);
            NSArray* datasArr = dic[@"datas"][@"goods_list"];
            [_detailArray removeAllObjects];
            for (int i = 0; i < datasArr.count; i ++) {
                
                TypeDetailModel* model = [[TypeDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:datasArr[i]];
                [_detailArray addObject:model];
                
            }
            [_detailCollView reloadData];
            _detailCollView.contentSize = CGSizeMake(_detailCollView.width, _detailArray.count/2*150+_detailArray.count%2*150);
           
        }
        else
        {
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
    }];
    
    
}


//#pragma mark 分类
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    WebViewController* webViewVC = [[WebViewController alloc]init];
//    webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/product_first_categroy.html",ShouYaoWapServer];
//    [self.navigationController pushViewController:webViewVC animated:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
