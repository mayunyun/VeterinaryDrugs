//
//  FirstCollectionView.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "FirstCollectionView.h"
#import "CustomCell.h"
#import "HomeSelarModel.h"
@interface FirstCollectionView ()

@end
@implementation FirstCollectionView

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
        [self registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCellID"];
    }
 
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    HomeSelarModel* model = _dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];;
    return cell;
    
}



@end
