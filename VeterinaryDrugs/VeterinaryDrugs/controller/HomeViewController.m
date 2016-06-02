//
//  HomeViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#define USERNAEM @"username"
#define PWD @"pwd"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "EScrollerView.h"
#import "CustomCell.h"
#import "HomeSelarCell.h"
#import "HomeSelarModel.h"
#import "FirstCollectionView.h"
#import "SecondCollectionView.h"
//
#import "LeadScrollView.h"

@interface HomeViewController ()<UIWebViewDelegate,UICollectionViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD* _HUD;
    UIView* navBarView;
    UIRefreshControl* refreshControl;
}
@property (nonatomic,strong)UITextField* searchTextField;
@property (nonatomic,strong)UIWebView* webView;
@property (nonatomic,strong)UIScrollView* bgScrollView;
@property (nonatomic,strong)EScrollerView* adView;
@property (nonatomic,strong)UIScrollView* selarBottomView;
@property (nonatomic,strong)FirstCollectionView* collView;
@property (nonatomic,strong)SecondCollectionView* secondCollectionView;
@property (nonatomic,strong)NSMutableArray* shopArr;
@property (nonatomic,strong)NSMutableArray* selarArr;
@property (nonatomic,strong)NSMutableArray* adImgArr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selarArr = [[NSMutableArray alloc]init];
    _shopArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    if ([LeadScrollView launchFirst]) {
        [self creatLeadUI];
    }else{
        [self creatNavBarView];
        [self creatUI];
        [self initUIData];
    }
    


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

- (void)creatLeadUI
{
    LeadScrollView *leadVC = [[LeadScrollView alloc] initWithFrame:APPDelegate.window.bounds];
    leadVC.scrollsToTop = NO;
    leadVC.backgroundColor = [UIColor clearColor];
    //设置尺寸
    leadVC.contentSize = CGSizeMake(leadVC.width * LeadPictures.count, leadVC.height);
    [APPDelegate.window addSubview:leadVC];
    [leadVC createPageContrl];
    
    leadVC.beginBlock = ^()
    {
        [self creatNavBarView];
        [self creatUI];
        [self initUIData];
    };
}

#pragma mark ---- 原生界面
- (void)creatNavBarView
{
    navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, 40)];
    navBarView.userInteractionEnabled = YES;
    navBarView.backgroundColor = [UIColor clearColor];
//    [_bgScrollView addSubview:navBarView];
    [[UIApplication sharedApplication].delegate.window addSubview:navBarView];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, navBarView.width, navBarView.height)];
    bgView.backgroundColor = [UIColor blueColor];
    bgView.alpha = 0;
    [navBarView addSubview:bgView];
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn setImage:[UIImage imageNamed:@"ft_logo"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(navBarView.right - 30, 0, 30, 30);
    UIImageView* rightimgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
    rightimgView.image = [UIImage imageNamed:@"bk_icon"];
    [rightBtn addSubview:rightimgView];
    UILabel* textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, rightimgView.bottom, rightBtn.width, rightBtn.height-rightimgView.height)];
    textLabel.text = @"消息";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:10];
    [rightBtn addSubview:textLabel];
//    [rightBtn setImage:[UIImage imageNamed:@"bk_icon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    
    
    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 5;
    searchBtn.userInteractionEnabled = YES;
    searchBtn.frame = CGRectMake(leftBtn.right, 0, navBarView.width - rightBtn.width - leftBtn.width, 35);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.alpha = 0.5;
    [navBarView addSubview:searchBtn];
    UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchImgView.userInteractionEnabled = YES;
    searchImgView.image = [UIImage imageNamed:@"ico_search"];
    [searchBtn addSubview:searchImgView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
    [searchImgView addGestureRecognizer:tap];
    
     _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, searchBtn.width-searchImgView.width - 40, 30)];
    _searchTextField.delegate = self;
    [_searchTextField setPlaceholder:@"  输入商品查找"];
    [searchBtn addSubview:_searchTextField];
    

}
- (void)creatUI
{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.scrollsToTop = YES;
    [self.view addSubview:_bgScrollView];
    //刷新控件
    refreshControl = [[UIRefreshControl alloc] init];
    //文本
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    //添加事件
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_bgScrollView addSubview:refreshControl];
    

    UIImageView* adbgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 120)];
    adbgView.image = [UIImage imageNamed:@"default_img_banner"];
    adbgView.backgroundColor = [UIColor clearColor];
    [_bgScrollView addSubview:adbgView];
    
    NSArray* btn1Arr = @[@"img_navi01",@"img_navi04",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi02",@"img_navi05",@"img_navi09"];
    NSArray* btn1LabelArr = @[@"精品推荐",@"畜类用品",@"禽类用品",@"水产用药",@"宠物用药",@"药品包装",@"化学药剂",@"设备仪器"];
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
    _collView.scrollsToTop = NO;
    [shopbgView addSubview:_collView];

    UIView* selarBgView = [[UIView alloc]initWithFrame:CGRectMake(0, shopbgView.bottom, mScreenWidth, 440)];
    [_bgScrollView addSubview:selarBgView];
    [self creatLabelTag:selarBgView tab:1 text:@"商家付闪"];
    
    UIImageView* selarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, selarBgView.width, 240)];
    selarImgView.userInteractionEnabled = YES;
    selarImgView.tag = 400;
    selarImgView.image = [UIImage imageNamed:@"default_img_banner"];
    [selarBgView addSubview:selarImgView];
    UITapGestureRecognizer* selarImgtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selarImgClick:)];
    [selarImgView addGestureRecognizer:selarImgtap];
    
    _selarBottomView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, selarImgView.bottom + 10, mScreenWidth, 150)];
    _selarBottomView.scrollsToTop = NO;
    _selarBottomView.scrollEnabled = YES;
    _selarBottomView.showsHorizontalScrollIndicator = NO;
    _selarBottomView.showsVerticalScrollIndicator = NO;
    [selarBgView addSubview:_selarBottomView];
    _selarBottomView.contentSize = CGSizeMake(_selarBottomView.width, _selarBottomView.height);
    
    _secondCollectionView = [[SecondCollectionView alloc]initWithFrame:CGRectMake(0, 0, 1700, _selarBottomView.height)];
    _secondCollectionView.delegate = self;
    _secondCollectionView.scrollEnabled = YES;
    _secondCollectionView.scrollsToTop = NO;
    _secondCollectionView.contentSize = CGSizeMake(_secondCollectionView.width, _selarBottomView.height);
    [_selarBottomView addSubview:_secondCollectionView];
    
    _bgScrollView.contentSize = CGSizeMake(mScreenWidth, adbgView.height+150+limitTimeView.height+shopbgView.height+selarBgView.height+49 +25);
    
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
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = .5f;
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
- (void)refresh
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    //开始刷新
    [refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshData) userInfo:nil repeats:NO];
}

- (void)refreshData
{
    [self initUIData];
    //结束刷新
    [refreshControl endRefreshing];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
}

- (void)leftBarClick:(UIButton*)sender
{

}
- (void)rightBarClick:(UIButton*)sender
{
    [self callTel:@"400-000-1234"];
}
- (void)searchClick:(UITapGestureRecognizer*)sender
{
//    [self searchData];
    [navBarView endEditing:YES];
    [self searchWeb];
    
    
}

- (void)btnClick:(UIButton*)sender
{
    NSArray* htmlArr = @[@"tmpl/product_first_categroy.html",
                         @"tmpl/product_list.html?gc_id=1067",
                         @"tmpl/product_list.html?gc_id=1077",
                         @"tmpl/product_list.html?gc_id=1220",
                         @"tmpl/product_list.html?gc_id=1099",
                         @"tmpl/product_list.html?gc_id=7",
                         @"tmpl/product_list.html?gc_id=8",
                         @"tmpl/product_list.html?gc_id=9"];
    
    WebViewController* webViewVC = [[WebViewController alloc]init];
    for (int i = 0; i < 8; i++) {
        if (sender.tag == 100+i) {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/%@",ShouYaoWapServer,htmlArr[i]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
    }
    switch (sender.tag) {
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
    NSArray* htmlArr = @[@"",
                         @"tmpl/product_detail.html?goods_id=100263",
                         @"tmpl/product_detail.html?goods_id=100118",
                         @"tmpl/product_detail.html?goods_id=100156",
                         @"tmpl/product_list.html?gc_id=1116",
                         @"tmpl/product_detail.html?goods_id=100280",
                         @"tmpl/product_detail.html?goods_id=100318"];
    
    WebViewController* webViewVC = [[WebViewController alloc]init];
    for (int i = 0; i < 7; i++) {
        if (sender.view.tag == 200+i) {
            webViewVC.weburl = [NSString stringWithFormat:@"%@/%@",ShouYaoWapServer,htmlArr[i]];
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
    }
}
- (void)selarImgClick:(UITapGestureRecognizer*)sender
{

}


#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collView) {
        return CGSizeMake(mScreenWidth/2-5, 86);
    }else{
        return CGSizeMake(mScreenWidth/3-5, 150);
    }

}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    if (collectionView == _collView) {
        return UIEdgeInsetsMake(5, 5, 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}
#pragma mark ---UICollectionViewDelegate
//协议中的方法，选中某个单元格时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您选择了第%ld个单元格",(long)indexPath.row);
    
    if (collectionView == _collView) {
        HomeShopModel* model = [[HomeShopModel alloc]init];
        model = _shopArr[indexPath.row];
        NSString* url = [NSString stringWithFormat:@"%@/tmpl/product_list.html?brand_id=%@",ShouYaoWapServer,model.brand_id];
        WebViewController* webView = [[WebViewController alloc]init];
        webView.weburl = url;
        [self.navigationController pushViewController:webView animated:YES];
        
    }else{
        
       // http://192.168.1.41/newsoyaom/wap/tmpl/product_detail.html?goods_id=100118
        HomeSelarModel* model = [[HomeSelarModel alloc]init];
        model = _selarArr[indexPath.row];
        NSString* url = [NSString stringWithFormat:@"%@/tmpl/product_detail.html?goods_id=%@",ShouYaoWapServer,model.goods_id];
        WebViewController* webView = [[WebViewController alloc]init];
        webView.weburl = url;
        [self.navigationController pushViewController:webView animated:YES];
        
    
    }
}

#pragma mark ---UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _searchTextField) {
        //    [self searchData];
        [self searchWeb];
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark ---data
- (void)initUIData
{
    [self requestADdata];
    [self requestLimitData];
    [self requestShopData];
    [self requestSelarData];
    
}

//- (void)requestSelarData1
//{
////    NSArray* btn1Arr = @[@"img_navi04",@"img_navi05",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi09",@"img_navi01",@"img_navi02"];
////    NSArray* btn1LabelArr = @[@"兽药添加剂",@"兽类用品",@"禽类用品",@"水产用药",@"宠物用药",@"兽药原料",@"商品分类",@"购物车"];
////    [_selarArr removeAllObjects];
////    _selarArr = [[NSMutableArray alloc]init];
////    for (int i = 0; i < btn1Arr.count; i ++) {
////        * model = [[HomeSelarModel alloc]init];
////        model.brand_name = btn1LabelArr[i];
////        model.brand_pic = btn1Arr[i];
////        [_selarArr addObject:model];
////    }
////    _secondCollectionView = [[SecondCollectionView alloc]initWithFrame:CGRectMake(0, 0, _selarArr.count*(mScreenWidth/3+5), _selarBottomView.height)];
////    _secondCollectionView.dataArr = _selarArr;
////    _secondCollectionView.delegate = self;
////    [_selarBottomView addSubview:_secondCollectionView];
//    
//}
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
    NSArray* imgArr = @[@"2016020105.jpg",@"manxingbing",@"xianshiqiang",@"xiaotu1 (2)1216",@"2015081204.jpg",@"xiaotu1 (3)1216",@"xiaotu1 (3)1216"];
    NSArray* htmlimeages = @[@"images/xianshiqiang.jpg",@"images/manxingbing.jpg",@"images/jiatingxiaoyaoxiang.jpg",@"images/changjianbing1208.jpg",@"images/2015081204.jpg",@"images/2016020105.jpg",@"images/xiaotu1%20(2)1216.jpg"];
    for (int i = 0; i < 7; i ++) {
        UIImageView* imgView = (UIImageView*)[_bgScrollView viewWithTag:200+i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ShouYaoWapServer,htmlimeages[i]]] placeholderImage:[UIImage imageNamed:imgArr[i]]];
    }
}

- (void)requestShopData
{
    NSString* url = @"index.php?act=index_store&op=index";
    [Httptool postWithURL:url Params:nil Success:^(id json, HttpCode code) {
        NSDictionary *dic = (NSDictionary *)json;
        
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSLog(@"requestShopData%@",dic);
            NSArray* datasArr = dic[@"datas"];
            [_shopArr removeAllObjects];
            for (int i = 0; i < 8; i ++) {
                
               HomeShopModel* model = [[HomeShopModel alloc]init];
                [model setValuesForKeysWithDictionary:datasArr[i]];
                [_shopArr addObject:model];
            }
            _collView.dataArr = [[NSArray alloc]initWithArray:_shopArr];
            [_collView reloadData];
        }
        else
        {
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
    }];
    //    NSArray* btn1Arr = @[@"img_navi01",@"img_navi02",@"img_navi04",@"img_navi05",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi09"];
    //    NSArray* btn1LabelArr = @[@"商品分类",@"购物车",@"兽药添加剂",@"兽类用品",@"禽类用品",@"水产用药",@"宠物用药",@"兽药原料"];
    //    _selarArr = [[NSMutableArray alloc]init];
    //    for (int i = 0; i < btn1Arr.count; i ++) {
    //        HomeSelarModel* model = [[HomeSelarModel alloc]init];
    //        model.title = btn1LabelArr[i];
    //        model.url = btn1Arr[i];
    //        [_selarArr addObject:model];
    //    }
    //    _collView.dataArr = [[NSArray alloc]initWithArray:_selarArr];
}

- (void)requestSelarData
{
    
    UIImageView* imgView = (UIImageView*)[_bgScrollView viewWithTag:400];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/images/pay.jpg",ShouYaoWapServer]] placeholderImage:[UIImage imageNamed:@"pay.jpg"]];
    NSString* url = @"index.php?act=store&op=goods_list&key=4&page=7&curpage=1&store_id=7";
    [Httptool postWithURL:url Params:nil Success:^(id json, HttpCode code) {
        NSDictionary *dic = (NSDictionary *)json;
        
        if ([[dic objectForKey:@"code"] integerValue]== kHttpStatusOK)
        {
            NSLog(@"requestSelarData%@",dic);
            NSArray* datasArr = dic[@"datas"][@"goods_list"];
            [_selarArr removeAllObjects];
            for (int i = 0; i < datasArr.count; i ++) {
                
                HomeSelarModel* model = [[HomeSelarModel alloc]init];
                [model setValuesForKeysWithDictionary:datasArr[i]];
                [_selarArr addObject:model];
                
            }
            _secondCollectionView.dataArr = _selarArr;
            [_secondCollectionView reloadData];
            _selarBottomView.contentSize = CGSizeMake(_selarArr.count*(mScreenWidth/3+5), _selarBottomView.height);
            _secondCollectionView.contentSize = CGSizeMake( _selarArr.count*(mScreenWidth/3+5), _selarBottomView.height);
        }
        else
        {
            [Httptool showCustInfo:nil MessageString:[dic objectForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
    }];
    
    
}
//网络电话
-(void)callTel:(NSString *)telNum
{
    BOOL isPhone=[self isPhone];
    if(isPhone){
        
        //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-636-7870"]];
        NSString *telephoneStr = [[NSString alloc] initWithFormat:@"tel://%@", telNum];
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:telephoneStr];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        
        [self.view addSubview:callWebview];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持电话功能！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (BOOL)isPhone{
    //TARGET_IPHONE_SIMULATOR模拟器
    NSString *deviceModel = [NSString stringWithString:[UIDevice currentDevice].model];
    NSLog(@"device model = %@", deviceModel);
    //    if(DEBUG) DLog(@"device model = %@", deviceModel);
    if ([deviceModel rangeOfString:@"iPhone"].location != NSNotFound) {
        if ([deviceModel rangeOfString:@"Simulator"].location == NSNotFound) {
            return YES;
        }
        
    }
    return NO;
}
- (void)searchWeb
{
    /*
     *http://192.168.1.41/newsoyaom/wap/tmpl/product_list.html?act=goods&op=goods_list&key=4&page=1&curpage=1&keyword=%@&callback=jQuery18302537533081581216_1464079753126&_=1464079753133
     */
    WebViewController* webView = [[WebViewController alloc]init];
    
    NSString *unreserved = _searchTextField.text;
    NSMutableCharacterSet *allowed = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowed addCharactersInString:unreserved];
    webView.weburl = [NSString stringWithFormat:@"%@/tmpl/product_list.html?keyword=%@",ShouYaoWapServer,[_searchTextField.text stringByAddingPercentEncodingWithAllowedCharacters:allowed]];
    [self.navigationController pushViewController:webView animated:YES];
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
