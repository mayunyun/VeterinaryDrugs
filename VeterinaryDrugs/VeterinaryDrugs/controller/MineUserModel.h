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
