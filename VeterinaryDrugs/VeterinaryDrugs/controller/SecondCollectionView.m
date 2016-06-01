//
//  SecondCollectionView.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "SecondCollectionView.h"
#import "HomeSelarCell.h"
#import "HomeSelarModel.h"
@implementation SecondCollectionView

- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5; //列间距
    flowLayout.minimumLineSpacing = 5;      //行间距
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        //隐藏滑块
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置背景颜色（默认黑色）
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        
        //注册单元格
        [self registerNib:[UINib nibWithNibName:@"HomeSelarCell" bundle:nil] forCellWithReuseIdentifier:@"HomeSelarCellID"];
    }

    return self;
}

//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    HomeSelarCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSelarCellID" forIndexPath:indexPath];
    [self framAdd:cell];
    HomeSelarModel* model = _dataArr[indexPath.row];
    cell.textLabel.text = model.goods_name;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    return cell;
}

- (void)framAdd:(id)sender
{
    CALayer *layer = [sender layer];
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


@end
