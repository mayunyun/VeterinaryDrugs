//
//  HomeViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "EScrollerView.h"
#import "CustomCell.h"
#import "HomeSelarCell.h"
#import "HomeSelarModel.h"
#import "FirstCollectionView.h"
#import "SecondCollectionView.h"

@interface HomeViewController ()<UIWebViewDelegate,UICollectionViewDelegate>
{
    MBProgressHUD* _HUD;
}
@property (nonatomic,strong)UIWebView* webView;
@property (nonatomic,strong)UIScrollView* bgScrollView;
@property (nonatomic,strong)EScrollerView* adView;
@property (nonatomic,strong)UIScrollView* selarBottomView;
@property (nonatomic,strong)FirstCollectionView* collView;
@property (nonatomic,strong)SecondCollectionView* secondCollectionView;
@property (nonatomic,strong)NSMutableArray* selarArr;
@property (nonatomic,strong)NSMutableArray* adImgArr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selarArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
//    [self createweb];
    [self creatUI];
    [self requestADdata];
    [self requestLimitData];
    [self requestSelarData];
    [self requestSelarData1];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark ---- 原生界面
- (void)creatUI
{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_bgScrollView];
    UIView* adbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 120)];
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
    limitTimeView.backgroundColor = [UIColor redColor];
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
    rightImg.image = [UIImage imageNamed:@"iconn1"];
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

- (void)btnClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 100:
        {
            
        }break;
        case 101:
        {
            
        }break;
        case 102:
        {
            
        }break;
        case 103:
        {
            
        }break;
        case 104:
        {
            
        }break;
        case 105:
        {
            
        }break;
        case 106:
        {
            
        }break;
        case 107:
        {
            
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


////协议中的方法，用于返回分区中的单元格个数
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
////    if (collectionView == _shopCollectionView) {
//        return 8;
////    }else{
////        return _selarArr.count;
////    }
//}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
//    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    
////    HomeSelarCell* selarCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSelarCellID" forIndexPath:indexPath];
////    selarCell.backgroundColor = [UIColor whiteColor];
////    
////    if (collectionView == _shopCollectionView) {
//        cell.textLabel.text = [NSString stringWithFormat:@"照片:%ld", (long)indexPath.row];
//        cell.imageView.image = [UIImage imageNamed:@"img_navi01"];
//        return cell;
////    }else{
////        HomeSelarModel* model = _selarArr[indexPath.row];
////        selarCell.textLabel.text = model.title;;
////        selarCell.imgView.image = [UIImage imageNamed:model.url];
////        return selarCell;
////    }
//    
//
//}

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

//协议中的方法，选中某个单元格时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您选择了第%ld个单元格",(long)indexPath.row);
    
//    [self requestSelarData1];
//    _collView.dataArr = [[NSArray alloc]initWithArray:_selarArr];
//    [_collView reloadData];
}

- (void)initUIData
{
    [self requestADdata];
}

- (void)requestSelarData
{
    NSArray* btn1Arr = @[@"img_navi01",@"img_navi02",@"img_navi04",@"img_navi05",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi09"];
    NSArray* btn1LabelArr = @[@"商品分类",@"购物车",@"兽药添加剂",@"兽类用品",@"禽类用品",@"水产用药",@"宠物用药",@"兽药原料"];
    _selarArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < btn1Arr.count; i ++) {
        HomeSelarModel* model = [[HomeSelarModel alloc]init];
        model.title = btn1LabelArr[i];
        model.url = btn1Arr[i];
        [_selarArr addObject:model];
    }
    _collView.dataArr = [[NSArray alloc]initWithArray:_selarArr];

}

- (void)requestSelarData1
{
    NSArray* btn1Arr = @[@"img_navi04",@"img_navi05",@"img_navi06",@"img_navi07",@"img_navi08",@"img_navi09",@"img_navi01",@"img_navi02"];
    NSArray* btn1LabelArr = @[@"兽药添加剂",@"兽类用品",@"禽类用品",@"水产用药",@"宠物用药",@"兽药原料",@"商品分类",@"购物车"];
    [_selarArr removeAllObjects];
    _selarArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < btn1Arr.count; i ++) {
        HomeSelarModel* model = [[HomeSelarModel alloc]init];
        model.title = btn1LabelArr[i];
        model.url = btn1Arr[i];
        [_selarArr addObject:model];
    }
    _secondCollectionView = [[SecondCollectionView alloc]initWithFrame:CGRectMake(0, 0, _selarArr.count*(mScreenWidth/3+5), _selarBottomView.height)];
    _secondCollectionView.dataArr = _selarArr;
    _secondCollectionView.delegate = self;
    [_selarBottomView addSubview:_secondCollectionView];
    
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
        
        
    }];

   
    

}

- (void)requestLimitData
{
    for (int i = 0; i < 7; i ++) {
        UIImageView* imgView = (UIImageView*)[_bgScrollView viewWithTag:200+i];
        [imgView setImage:[UIImage imageNamed:@"img_navi02"]];
    }
    
    
}



#pragma mark ---web页面
-(void)createweb
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    [self.webView scalesPageToFit];
    self.webView.delegate = self;
    NSString* url = [NSString stringWithFormat:@"%@/index.html",RootPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.webView goBack];
    [self.view addSubview:self.webView];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_HUD show:YES];
    _HUD.labelText = @"页面加载中";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_HUD hide:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = @"http://www.soyaow.com/wap/index.html";
    NSString * url = request.URL.absoluteString;
    NSLog(@"--------url%@",url);
    if ([url isEqualToString: urlStr]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }else{
        
        return YES;
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
