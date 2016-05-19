//
//  UIView+HTErrorAnimation.h
//  iOS客户端框架
//
//  Created by 黄铁 on 14-7-7.
//  Copyright (c) 2014年 Risenb App Department With iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TransienceRockKey @"transienceRock"

#define LongRockKey @"LongRockKey"

#define filpKey @"filpKey"

#define flashingKey @"flashingKey"

#define flashLayet @"flashLayet"

@interface UIView (HTErrorAnimation)


/**
 *  短暂摇摆
 */

- (void)rock;

/**
 *  长时间摇摆
 */
- (void)rockLong;

/**
 *  停止摇摆
 */
- (void)rockStop;

/**
 *  顺时针翻转
 */
- (void)flip;

/**
 *  顺时针翻转
 *
 *  @param count 次数
 */
- (void)flip:(NSInteger)count;

/**
 *  停止翻转
 */
- (void)stopFilp;

/**
 *  不停闪烁
 */
- (void)flashing;

/**
 *  闪烁
 *
 *  @param delay 闪烁次数
 */
- (void)flashing:(NSInteger)delay;


/**
 *  停止闪烁
 */
- (void)stopFlashing;

/**
 *  边框闪烁
 */
- (void)flashLayer;
/**
 *  边框闪烁
 *
 *  @param delay 闪烁次数
 */
- (void)flashLayer:(NSInteger)delay;

/**
 *  停止边框闪烁
 */
- (void)stopFlashLayer;

/**
 *  放大再缩小
 */
- (void)popUp;

- (void)popUp:(void(^)())finish;

/**
 *  移动
 *
 *  @param point 坐标
 */
- (void)move:(CGPoint)point;

- (void)move:(CGPoint)point finish:(void(^)())finish;

/**
 *  渐隐
 *
 *  @param finish
 */
- (void)fadeHide:(void(^)())finish;

- (void)fadeShow:(void(^)())finish;

/**
 *  抛物线
 *
 *  @param point 终点的中心点
 */
-(void)parabola:(CGPoint)point;

-(void)parabola:(CGPoint)point scale:(float)scale;



@end
