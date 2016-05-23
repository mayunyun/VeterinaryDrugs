//
//  EScrollerView.h
//  Hnair4iPhone
//
//  Created by 02 on 14-6-18.
//  Copyright (c) 2014年 yingkong1987. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end
@interface EScrollerView : UIView
@property(nonatomic,retain)id<EScrollerViewDelegate> delegate;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr;
@end
