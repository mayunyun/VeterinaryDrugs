//
//  RightBgView.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "RightBgView.h"

@interface RightBgView ()
@property (nonatomic,strong)UIView* bgRightView;

@end

@implementation RightBgView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)creatRightView
{
    _bgRightView = [[UIView alloc]initWithFrame:CGRectMake(mScreenWidth - 130, 0, 120, 150)];
    _bgRightView.backgroundColor = NavBarColor;
    [self addSubview:_bgRightView];
    NSArray* titleArr = @[@"首页",@"购物车",@"我"];
    for (int i = 0; i < 3 ; i ++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, i*49, _bgRightView.width, 49);
        btn.tag = 100+i;
        [_bgRightView addSubview:btn];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (i+1)*49, _bgRightView.width, 1)];
        lineLabel.backgroundColor = LineColor;
        [_bgRightView addSubview:lineLabel];
    }
}

- (void)rightViewBtnClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
            
        default:
            break;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
