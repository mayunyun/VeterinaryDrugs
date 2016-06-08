//
//  ViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "EScrollerView.h"
#import "CustomCell.h"
#import "HomeSelarCell.h"
#import "HomeSelarModel.h"
#import "FirstCollectionView.h"
#import "SecondCollectionView.h"
#import "ShouYaoVC.h"

@interface ViewController ()<UIWebViewDelegate,UICollectionViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD* _HUD;
    UIView* navBarView;
}
@property (nonatomic,strong)UITextField* searchTextField;
@property (nonatomic,strong)UIWebView* webView;
@property (nonatomic,strong)UIScrollView* bgScrollView;
@property (nonatomic,strong)EScrollerView* adView;
@property (nonatomic,strong)UIScrollView* selarBottomView;
@property (nonatomic,strong)FirstCollectionView* collView;
@property (nonatomic,strong)SecondCollectionView* secondCollectionView;
@property (nonatomic,strong)NSMutableArray* selarArr;
@property (nonatomic,strong)NSMutableArray* adImgArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selarArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self creatNavBarView];
    [self creatTotalUI];
    [self initUIData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    navBarView.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    navBarView.hidden = YES;
    
}


#pragma mark ---- 原生界面
- (void)creatNavBarView
{
    navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, 40)];
    navBarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navBarView];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, navBarView.width, navBarView.height)];
    bgView.backgroundColor = [UIColor blueColor];
    bgView.alpha = 0;
    [navBarView addSubview:bgView];
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn setImage:[UIImage imageNamed:@"ft_logo"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(navBarView.right - 40, 0, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:@"ft_logo"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    
    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 5;
    searchBtn.frame = CGRectMake(leftBtn.right, 0, navBarView.width - rightBtn.width - leftBtn.width, 40);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.alpha = 0.5;
    [navBarView addSubview:searchBtn];
    UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    searchImgView.image = [UIImage imageNamed:@"ft_logo"];
    [searchBtn addSubview:searchImgView];
    _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right, 0, searchBtn.width-searchImgView.width - 40, 30)];
    _searchTextField.delegate = self;
    [_searchTextField setPlaceholder:@"搜索商品"];
    [searchBtn addSubview:_searchTextField];
    
    
}
- (void)creatUI
{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    UIImageView* adbgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 120)];
    adbgView.image = [UIImage imageNamed:@"default_img_banner"];
    adbgView.backgroundColor = [UIColor clearColor];
    [_bgScrollView addSubview:adbgView];
    
    
    NSArray* btn1Arr = @[@"img_navi01",@"img_navi02",@"img_navi04",@"img_navi05",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi09"];
    NSArray* btn1LabelArr = @[@"商品分类",@"购物车",@"兽药添加剂",@"兽类用品",@"禽类用品",@"水产用药",@"宠物用药",@"兽药原料"];
    for (int i = 0; i < 2; i ++) {
        for (int  j =0; j < 4; j++) {
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((mScreenWidth*0.25-44)/2+j*mScreenWidth*0.25,5+adbgView.bottom+i*75, 44, 44)];
            imgView.tag = 100+i*4+j;
            imgView.image = [UIImage imageNamed:btn1Arr[j+i*4]];
            [_bgScrollView addSubview:imgView];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(j*mScreenWidth*0.25, adbgView.bottom+55+i*75, mScreenWidth*0.25, 20)];
            label.tag = 100+i*4+j;
            label.text = btn1LabelArr[j+i*4];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            [_bgScrollView addSubview:label];
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(j*mScreenWidth*0.25,adbgView.bottom+i*75, mScreenWidth*0.25, 75);
            btn.tag = 100+i*4+j;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bgScrollView addSubview:btn];
        }
    }
    UILabel* lineFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, adbgView.bottom+150+9, mScreenWidth, 1)];
    lineFirstLabel.backgroundColor = LineColor;
    [_bgScrollView addSubview:lineFirstLabel];
    
    UIView* limitTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+lineFirstLabel.bottom, mScreenWidth, 340)];
    limitTimeView.backgroundColor = [UIColor clearColor];
    [_bgScrollView addSubview:limitTimeView];
    for (int i = 0; i <2; i++) {
        for (int j = 0; j < 2; j ++) {
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(j*mScreenWidth*0.5, i*82.5, limitTimeView.width/2, 82.5)];
            imgView.userInteractionEnabled = YES;
            [self framAdd:imgView];
            imgView.tag = 200+i*2+j;
            imgView.image = [UIImage imageNamed:@"default_img_banner"];
            [limitTimeView addSubview:imgView];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(limitImgClick:)];
            [imgView addGestureRecognizer:tap];
        }
    }
    UIImageView* leftlimitView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+165, limitTimeView.width/2, limitTimeView.height-10-165)];
    leftlimitView.userInteractionEnabled = YES;
    leftlimitView.image = [UIImage imageNamed:@"default_img_banner"];
    [self framAdd:leftlimitView];
    leftlimitView.tag = 200+4;
    [limitTimeView addSubview:leftlimitView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(limitImgClick:)];
    [leftlimitView addGestureRecognizer:tap];
    for (int i = 0; i < 2; i ++) {
        UIImageView* rightView = [[UIImageView alloc]initWithFrame:CGRectMake(limitTimeView.width/2, 10+165+i*leftlimitView.height/2, limitTimeView.width/2, leftlimitView.height/2)];
        rightView.userInteractionEnabled = YES;
        rightView.image = [UIImage imageNamed:@"default_img_banner"];
        [self framAdd:rightView];
        rightView.tag = 205+i;
        [limitTimeView addSubview:rightView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(limitImgClick:)];
        [rightView addGestureRecognizer:tap];
    }
    
    UIView* shopbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 5+limitTimeView.bottom, mScreenWidth, 420)];
    [_bgScrollView addSubview:shopbgView];
    [self creatLabelTag:shopbgView tab:0 text:@"明星店铺"];
    
    _collView = [[FirstCollectionView alloc]initWithFrame:CGRectMake(0, 40, mScreenWidth, 380)];
    _collView.delegate = self;
    [shopbgView addSubview:_collView];
    
    UIView* selarBgView = [[UIView alloc]initWithFrame:CGRectMake(0, shopbgView.bottom, mScreenWidth, 410)];
    [_bgScrollView addSubview:selarBgView];
    [self creatLabelTag:selarBgView tab:1 text:@"商家付闪"];
    UIImageView* selarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, selarBgView.width, 240)];
    selarImgView.userInteractionEnabled = YES;
    selarImgView.tag = 400;
    selarImgView.image = [UIImage imageNamed:@"default_img_banner"];
    [selarBgView addSubview:selarImgView];
    UITapGestureRecognizer* selarImgtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selarImgClick:)];
    [selarImgView addGestureRecognizer:selarImgtap];
    
    _selarBottomView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, selarImgView.bottom + 10, mScreenWidth, 120)];
    [selarBgView addSubview:_selarBottomView];
    _selarBottomView.contentSize = CGSizeMake(1000, 120);
    
    _bgScrollView.contentSize = CGSizeMake(mScreenWidth, adbgView.height+150+limitTimeView.height+shopbgView.height+selarBgView.height+49 +20);
    
}

- (void)creatTotalUI
{
    UIView*btnview = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 49, mScreenWidth, 49)];
    btnview.backgroundColor = TabBarColor;
    [self.view addSubview:btnview];
    NSArray* imgArray = @[@"iconn1",
                 @"iconn2",
                 @"iconn3",
                 @"iconn4"];
    NSArray* imgArray1 = @[@"iconn11",
                          @"iconn22",
                          @"iconn33",
                          @"iconn44"];
    NSArray* labelArr = @[@"首页",@"分类",@"购物车",@"我"];
    for (int i = 0; i < 4; i ++) {
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(((mScreenWidth*0.25)-30)/2+i*(mScreenWidth*0.25), 0, 30 , 30)];
        img.image = [UIImage imageNamed:imgArray[i]];
        img.highlightedImage = [UIImage imageNamed:imgArray1[i]];
        [btnview addSubview:img];
        img.tag = 2001+i;
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(i*(mScreenWidth*0.25), img.bottom, mScreenWidth*0.25, 20)];
        label.text = labelArr[i];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = TabLableTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [btnview addSubview:label];
        label.tag = 3001+i;
        if (i!= 0) {
            UIImageView* imgView = (UIImageView*)[self.view viewWithTag:2001+i];
            imgView.highlighted = YES;
            
        }else{}
        if (i==0) {
            UILabel* label = (UILabel*)[self.view viewWithTag:3001+i];
            label.textColor = TabLableLightTextColor;
        }
        
    }
    
    
    for (int i = 0; i < 4; i ++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(i*mScreenWidth*0.25, 0, mScreenWidth*0.25, btnview.height)];
        btn.tag = 2001+i;
        [btn addTarget:self action:@selector(tabbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        [btnview addSubview:btn];
    }
    
    
    
    
}



- (void)creatLabelTag:(UIView*)bgView tab:(NSInteger)index text:(NSString*)text
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 40)];
    [bgView addSubview:view];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, mScreenWidth-40, 40)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    
    UILabel* redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 5, 20)];
    redLabel.backgroundColor = [UIColor redColor];
    [view addSubview:redLabel];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(mScreenWidth - 150, 0, 150, view.height);
    [btn setTitle:@"全部" forState:UIControlStateNormal];
    btn.tag = 300+index;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 20, 20)];
    rightImg.image = [UIImage imageNamed:@"ico_01"];
    rightImg.userInteractionEnabled = YES;
    [btn addSubview:rightImg];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 1)];
    lineView.backgroundColor = LineColor;
    [bgView addSubview:lineView];
}

- (void)framAdd:(UIImageView*)imageView
{
    CALayer *layer = [imageView layer];
    layer.borderColor = [UIColor grayColor].CGColor;
    layer.borderWidth = 1.0f;
    //    //添加四个边阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(0,0);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius = 10.0;//给imageview添加阴影和边框
    //    //添加两个边的阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(4,4);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius=2.0;
}

- (void)leftBarClick:(UIButton*)sender
{
    
}
- (void)rightBarClick:(UIButton*)sender
{
    
}
- (void)btnClick:(UIButton*)sender
{
    NSArray* htmlArr = @[@"tmpl/product_first_categroy.html",@"/tmpl/member/login.html"];
    NSArray* typeArr = @[@"1141",@"1067",@"1077",@"1220",@"1099",@"1139"];
    WebViewController* webViewVC = [[WebViewController alloc]init];
    switch (sender.tag) {
        case 100:
        {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/%@",ShouYaoWapServer,htmlArr[0]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }break;
        case 101:
        {
                       
        }break;
        case 102:
        {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/product_list.html?gc_id=%@",ShouYaoWapServer,typeArr[0]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }break;
        case 103:
        {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/product_list.html?gc_id=%@",ShouYaoWapServer,typeArr[1]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }break;
        case 104:
        {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/product_list.html?gc_id=%@",ShouYaoWapServer,typeArr[2]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }break;
        case 105:
        {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/product_list.html?gc_id=%@",ShouYaoWapServer,typeArr[3]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }break;
        case 106:
        {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/product_list.html?gc_id=%@",ShouYaoWapServer,typeArr[4]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }break;
        case 107:
        {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/tmpl/product_list.html?gc_id=%@",ShouYaoWapServer,typeArr[5]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }break;
        case 300:
        {
            //明星店铺全部
            
        }break;
        case 301:
        {
            //商家闪付全部
            
        }break;
        default:
            break;
    }
    
}
- (void)limitImgClick:(UITapGestureRecognizer*)sender
{
    switch (sender.view.tag) {
        case 200:
        {
            
        }
            break;
        case 201:
        {
            
        }
            break;
        case 202:
        {
            
        }
            break;
        case 203:
        {
            
        }
            break;
        case 204:
        {
            
        }
            break;
        case 205:
        {
            
        }
            break;
        case 206:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)selarImgClick:(UITapGestureRecognizer*)sender
{
    
}

#pragma 仿tabbar
-(void)tabbtnClick:(UIButton*)btn
{
    [self changeTabBarUIIndex:btn.tag];
    WebViewController * shouyao =[[WebViewController  alloc]init];
    NSLog(@"点击了%ld个tabbar",(long)btn.tag);
    if (btn.tag == 2001) {
        

        
    }
    if (btn.tag == 2002) {
        

        
        //        shouyao.weburl =
        //          [self.navigationController pushViewController:shouyao animated:YES];
    }if (btn.tag ==2003) {
        
        //一键拨号
//        shouyao.weburl = @"http://www.soyaow.com/wap/zhuanjia_xinxiliebiao.html";
//        //设置模式为进度框形的
//        [self.navigationController pushViewController:shouyao animated:YES];
        
    }if (btn.tag ==2004) {
        shouyao.weburl = [NSString stringWithFormat:@"%@/user.html",ShouYaoWapServer];
        [self.navigationController pushViewController:shouyao animated:YES];
    }
}

- (void)changeTabBarUIIndex:(int)index
{
    for (int i = 0; i < 4; i ++) {
        UIImageView* imgView = [self.view viewWithTag:2001+i];
        UILabel* label = [self.view viewWithTag:3001+i];
        if (i == (index - 2001)) {
            imgView.highlighted = NO;
            label.textColor = TabLableLightTextColor;
        }else{
            imgView.highlighted = YES;
            label.textColor = TabLableTextColor;
        }
    }

}


#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collView) {
        return CGSizeMake(mScreenWidth/2-5, 86);
    }else{
        return CGSizeMake(mScreenWidth/3, 120);
    }
    
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    if (collectionView == _collView) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}
#pragma mark ---UICollectionViewDelegate
//协议中的方法，选中某个单元格时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您选择了第%ld个单元格",(long)indexPath.row);
    
    //    [self requestSelarData1];
    //    _collView.dataArr = [[NSArray alloc]initWithArray:_selarArr];
    //    [_collView reloadData];
}

#pragma mark ---UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self searchData];
    //    [self searchWeb];
}
#pragma mark ---data
- (void)initUIData
{
    [self requestADdata];
    [self requestLimitData];
    [self requestSelarData];
    [self requestSelarData1];
}

- (void)requestSelarData
{
//    NSArray* btn1Arr = @[@"img_navi01",@"img_navi02",@"img_navi04",@"img_navi05",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi09"];
//    NSArray* btn1LabelArr = @[@"商品分类",@"购物车",@"兽药添加剂",@"兽类用品",@"禽类用品",@"水产用药",@"宠物用药",@"兽药原料"];
//    _selarArr = [[NSMutableArray alloc]init];
//    for (int i = 0; i < btn1Arr.count; i ++) {
//        HomeSelarModel* model = [[HomeSelarModel alloc]init];
//        model.brand_name = btn1LabelArr[i];
//        model.brand_pic = btn1Arr[i];
//        [_selarArr addObject:model];
//    }
//    _collView.dataArr = [[NSArray alloc]initWithArray:_selarArr];
    
}

- (void)requestSelarData1
{
//    NSArray* btn1Arr = @[@"img_navi04",@"img_navi05",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi09",@"img_navi01",@"img_navi02"];
//    NSArray* btn1LabelArr = @[@"兽药添加剂",@"兽类用品",@"禽类用品",@"水产用药",@"宠物用药",@"兽药原料",@"商品分类",@"购物车"];
//    [_selarArr removeAllObjects];
//    _selarArr = [[NSMutableArray alloc]init];
//    for (int i = 0; i < btn1Arr.count; i ++) {
//        HomeSelarModel* model = [[HomeSelarModel alloc]init];
//        model.brand_name = btn1LabelArr[i];
//        model.brand_pic = btn1Arr[i];
//        [_selarArr addObject:model];
//    }
//    _secondCollectionView = [[SecondCollectionView alloc]initWithFrame:CGRectMake(0, 0, _selarArr.count*(mScreenWidth/3+5), _selarBottomView.height)];
//    _secondCollectionView.dataArr = _selarArr;
//    _secondCollectionView.delegate = self;
//    [_selarBottomView addSubview:_secondCollectionView];
    
}
#pragma mark searchData
- (void)searchData
{
    /*
     *act=goods&op=goods_list&key=4&page=1&curpage=1&gc_id=lll
     *key 排序方式    /1.销量 2.浏览量 3.价格 4.最新排序
     */
    NSString *url = @"index.php";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"goods" forKey:@"act"];
    [params setObject:@"goods_list" forKey:@"op"];
    [params setObject:@"key" forKey:@"4"];
    [params setObject:@"page" forKey:@"1"];
    [params setObject:@"curpage" forKey:@"1"];
    [params setObject:@"gc_id" forKey:_searchTextField.text];
    [Httptool postWithURL:url Params:params Success:^(id json, HttpCode code) {
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"%@",dic);
        
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSLog(@"%@",dic);
            
        }
        else
        {
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark 轮播图数据
- (void)requestADdata
{
    NSString *url = @"index.php";//@"index.php?act=index";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"index" forKey:@"act"];
    [Httptool postWithURL:url Params:params Success:^(id json, HttpCode code) {
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"%@",dic);
        
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSLog(@"%@",dic);
            NSDictionary* dict = dic[@"datas"][0];
            [_adImgArr removeAllObjects];
            _adImgArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < 3 ; i ++) {
                NSDictionary* adDict = dict[@"adv_list"][@"item"][i];
                [_adImgArr addObject:adDict[@"image"]];
            }
            if (_adImgArr.count!= 0) {
                _adView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0 ,0, mScreenWidth,120) ImageArray:_adImgArr];
                [_bgScrollView addSubview:_adView];
            }
            
        }
        else
        {
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}

- (void)requestLimitData
{
    for (int i = 0; i < 7; i ++) {
        UIImageView* imgView = (UIImageView*)[_bgScrollView viewWithTag:200+i];
        [imgView setImage:[UIImage imageNamed:@"img_navi02"]];
    }
}

- (void)requestShopData
{
    
}


/*
 UIWebViewNavigationTypeLinkClicked，用户触击了一个链接。
 UIWebViewNavigationTypeFormSubmitted，用户提交了一个表单。
 UIWebViewNavigationTypeBackForward，用户触击前进或返回按钮。
 UIWebViewNavigationTypeReload，用户触击重新加载的按钮。
 UIWebViewNavigationTypeFormResubmitted，用户重复提交表单
 UIWebViewNavigationTypeOther，发生其它行为。
 */
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@/index.html",ShouYaoWapServer];
//    NSString * url = request.URL.absoluteString;
//    NSLog(@"--------url%@",url);
//    
//    
//    if ([url isEqualToString: urlStr]) {
//        [self.tabBarController setSelectedIndex:0];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//        return NO;
//    }else{
//        
//        return YES;
//    }
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
