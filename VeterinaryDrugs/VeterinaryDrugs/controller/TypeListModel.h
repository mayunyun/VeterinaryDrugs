//
//  TypeListModel.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/30.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface TypeListModel : BaseModel
@property (nonatomic,strong)NSString* select;
@property (nonatomic,strong)NSString* commis_rate;
@property (nonatomic,strong)NSString* gc_description;
@property (nonatomic,strong)NSString* gc_id;
@property (nonatomic,strong)NSString* gc_keywords;
@property (nonatomic,strong)NSString* gc_name;
@property (nonatomic,strong)NSString* gc_parent_id;
@property (nonatomic,strong)NSString* gc_sort;
@property (nonatomic,strong)NSString* gc_title;
@property (nonatomic,strong)NSString* gc_virtual;
@property (nonatomic,strong)NSString* image;
@property (nonatomic,strong)NSString* text;
@property (nonatomic,strong)NSString* type_id;
@property (nonatomic,strong)NSString* type_name;

@end
/*
 {
 "commis_rate" = 0;
 "gc_description" = "\U7f51\U8d2d{name}\U5c31\U4e0a\U4e13\U4e1a\U517d\U836f\U7535\U5546\U5e73\U53f0\U517d\U836f\U5546\U57ce{sitename}\Uff0c{name}\U517d\U836f\U5382\U5bb6\U517d\U836f\U76f4\U9500\U6279\U53d1\Uff0c\U517d\U836f\U4ef7\U683c\U4f18\U60e0\U8d28\U91cf\U6709\U4fdd\U8bc1-{sitename}";
 "gc_id" = 3;
 "gc_keywords" = "{name},\U9e21\U836f,\U9e2d\U9e45\U836f,\U79bd\U7528\U836f\U4ef7\U683c,{sitename}";
 "gc_name" = "\U79bd\U7528\U836f\U54c1";
 "gc_parent_id" = 0;
 "gc_sort" = 3;
 "gc_title" = "{name}|\U9e21\U836f|\U9e2d\U9e45\U836f|\U79bd\U7528\U836f\U4ef7\U683c-{sitename}";
 "gc_virtual" = 0;
 image = "";
 text = "\U6297\U6bd2\U6e05\U70ed\U7c7b/\U6297\U83cc\U6d88\U708e\U7c7b/\U547c\U5438\U7cfb\U7edf\U7c7b/\U80a0\U9053\U6d88\U708e\U7c7b/\U9a71\U866b\U6740\U866b\U7c7b/\U9632\U6e29\U964d\U6691\U7c7b/\U591a\U7ef4\U8425\U517b\U7c7b/\U50ac\U80a5\U4fc3\U957f\U7c7b/\U751f\U6b96\U4fdd\U5065\U7c7b/\U89e3\U6bd2\U8131\U9709\U7c7b/\U6d88\U6bd2\U9632\U8150\U7c7b/\U4fdd\U809d\U62a4\U80be\U7c7b/\U514d\U75ab\U589e\U6548\U7c7b/\U5176\U5b83\U4ea7\U54c1\U7c7b";
 "type_id" = 0;
 "type_name" = "";
 },
 */
@interface TypeDetailModel : BaseModel
//假数据
#warning 假数据
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

@end


