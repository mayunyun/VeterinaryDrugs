//
//  ShopViewCell.h
//  VeterinaryDrugs
//
//  Created by 联祥 on 16/5/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface ShopViewCell : UITableViewCell

@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UIImageView *imgView;
@property(nonatomic,retain)UILabel *proName;
@property(nonatomic,retain)UILabel *price;


@property(nonatomic,retain)ShopModel *model;
@end
