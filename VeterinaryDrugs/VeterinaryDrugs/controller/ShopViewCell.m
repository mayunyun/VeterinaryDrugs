//
//  ShopViewCell.m
//  VeterinaryDrugs
//
//  Created by 联祥 on 16/5/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ShopViewCell.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
@implementation ShopViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initView{
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, mScreenWidth - 20, 30)];
    _title.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_title];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _title.bottom, mScreenWidth, 1)];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    //
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, line.bottom + 10, 60, 60)];
    _imgView.contentMode =  UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imgView];
    //
    _proName = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right + 10, _imgView.top - 5, mScreenWidth - 100, 20)];
    _proName.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_proName];
    //
    _price = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right + 10, _proName.bottom, mScreenWidth - 100, 20)];
    _price.font = [UIFont systemFontOfSize:14];
    _price.textColor = [UIColor redColor];
    [self.contentView addSubview:_price];
    
    
}
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

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _title.text = _model.store_name;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.goods_image_url]];
    _proName.text = _model.goods_name;
    _price.text = [NSString stringWithFormat:@"¥%@",_model.goods_price];
}

@end
