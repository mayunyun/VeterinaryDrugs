//
//  SecondCollectionView.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondCollectionView : UICollectionView<UICollectionViewDataSource>
@property (nonatomic,strong)NSArray* dataArr;
@end
