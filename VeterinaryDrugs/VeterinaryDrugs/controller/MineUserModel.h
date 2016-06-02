//
//  MineUserModel.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MineUserModel : BaseModel
@property (nonatomic,strong)NSString* avator;//头像
@property (nonatomic,strong)NSString* point;//代金券
@property (nonatomic,strong)NSString* predepoit;//可用余额
@property (nonatomic,strong)NSString* user_name;

@end
/*
 avator: "http://www.soyaom.com/data/upload/shop/avatar/avatar_25.jpg"
 point: "530"
 predepoit: "0.00"
 user_name: "wanghao"
 */

@interface MineUserAddressListModel : BaseModel
@property (nonatomic,strong)NSString* address;
@property (nonatomic,strong)NSString* address_id;
@property (nonatomic,strong)NSString* area_id;
@property (nonatomic,strong)NSString* area_info;
@property (nonatomic,strong)NSString* city_id;
@property (nonatomic,strong)NSString* dlyp_id;
@property (nonatomic,strong)NSString* is_default;
@property (nonatomic,strong)NSString* member_id;
@property (nonatomic,strong)NSString* mob_phone;
@property (nonatomic,strong)NSString* province_id;
@property (nonatomic,strong)NSString* tel_phone;
@property (nonatomic,strong)NSString* true_name;

@end
/*
 address = 4;
 "address_id" = 409;
 "area_id" = 37;
 "area_info" = "\U5317\U4eac \U5317\U4eac\U5e02 \U4e1c\U57ce\U533a";
 "city_id" = 36;
 "dlyp_id" = 0;
 "is_default" = 0;
 "member_id" = 25;
 "mob_phone" = 2;
 "province_id" = "<null>";
 "tel_phone" = 3;
 "true_name" = 1;
 */

