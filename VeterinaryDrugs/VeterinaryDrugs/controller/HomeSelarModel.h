//
//  HomeSelarModel.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//



#import "BaseModel.h"
#import <Foundation/Foundation.h>

@interface HomeSelarModel : BaseModel
@property (nonatomic,strong)NSString* evaluation_count;
@property (nonatomic,strong)NSString* evaluation_good_star;
@property (nonatomic,strong)NSString* goods_id;
@property (nonatomic,strong)NSString* goods_image;
@property (nonatomic,strong)NSString* goods_image_url;
@property (nonatomic,strong)NSString* goods_marketprice;
@property (nonatomic,strong)NSString* goods_name;
@property (nonatomic,strong)NSString* goods_price;
@property (nonatomic,strong)NSString* goods_salenum;
@property (nonatomic,strong)NSString* group_flag;
@property (nonatomic,strong)NSString* xianshi_flag;

/*"evaluation_count" = 0;
 "evaluation_good_star" = 5;
 "goods_id" = 100273;
 "goods_image" = "15_05163805118430418.jpg";
 "goods_image_url" = "http://192.168.1.41/newsoyaom/data/upload/shop/common/default_goods_image_360.gif";
 "goods_marketprice" = "20000.00";
 "goods_name" = "\U3010\U9999\U6e2f\U6fb3\U95e8\U54c1\U8d28\U4e94\U65e5\U6e38\U30116\U67086.13.19.20.24.25\U65e5";
 "goods_price" = "10000.00";
 "goods_salenum" = 0;
 "group_flag" = 0;
 "xianshi_flag" = 0;
 */

@end

@interface HomeShopModel : BaseModel
@property (nonatomic,strong)NSString* brand_apply;
@property (nonatomic,strong)NSString* brand_class;
@property (nonatomic,strong)NSString* brand_id;//id
@property (nonatomic,strong)NSString* brand_initial;
@property (nonatomic,strong)NSString* brand_name;
@property (nonatomic,strong)NSString* brand_pic;//图片
@property (nonatomic,strong)NSString* brand_recommend;
@property (nonatomic,strong)NSString* brand_sort;
@property (nonatomic,strong)NSString* class_id;
@property (nonatomic,strong)NSString* show_type;
@property (nonatomic,strong)NSString* store_id;
/*
 "brand_apply" = 1;
 "brand_class" = "\U6297\U6bd2\U6e05\U70ed\U7c7b";
 "brand_id" = 14;
 "brand_initial" = L;
 "brand_name" = "\U7eff\U90fd\U751f\U7269";
 "brand_pic" = "05140617099212555_sm.jpg";
 "brand_recommend" = 1;
 "brand_sort" = 0;
 "class_id" = 1067;
 "show_type" = 0;
 "store_id" = 0;
 */
@end
