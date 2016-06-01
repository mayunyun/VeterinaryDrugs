//
//  ShopModel.h
//  VeterinaryDrugs
//
//  Created by 联祥 on 16/5/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property(nonatomic,copy)NSString *store_name;
@property(nonatomic,copy)NSString *goods_image_url;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *goods_price;
@property(nonatomic,copy)NSString *goods_num;

@property(nonatomic,copy)NSString *goods_sum;

/*
 bl_id: "0"
 buyer_id: "25"
 cart_id: "57"
 goods_id: "100127"
 goods_image: "7_05138830675141971.jpg"
 goods_image_url: "http://192.168.1.41/newsoyaom/data/upload/shop/common/default_goods_image_240.gif"
 goods_name: "硫酸阿托品注射液"
 goods_num: "18"
 goods_price: "0.01"
 goods_sum: "0.18"
 store_id: "7"
 store_name: "山东中抗药业有限公司"
 */

@end
