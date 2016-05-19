//
//  UIView+HTErrorAnimation.m
//  iOS客户端框架
//
//  Created by 黄铁 on 14-7-7.
//  Copyright (c) 2014年 Risenb App Department With iOS. All rights reserved.
//

#import "UIView+HTErrorAnimation.h"

@implementation UIView (HTErrorAnimation)

#pragma mark 短暂抖动
- (void)rock
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.duration = 0.5;
    animation.values = @[ @(0), @(10), @(-8), @(8), @(-5), @(5), @(0) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:TransienceRockKey];
}

#pragma mark 长时间抖动
- (void)rockLong
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.12];
    
    shake.toValue = [NSNumber numberWithFloat:+0.12];
    
    shake.duration = 0.1;
    
    shake.autoreverses = YES; //是否重复
    
    shake.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:shake forKey:LongRockKey];
}

- (void)rockStop
{
    [self.layer removeAnimationForKey:LongRockKey];
}

#pragma mark 顺时针旋转
- (void)flip
{
    [self flip:MAXFLOAT];
}

- (void)flip:(NSInteger)count
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    shake.fromValue = [NSNumber numberWithFloat:0];
    
    shake.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
    shake.duration = 1;
    
    shake.autoreverses = NO;
    
    shake.repeatCount = count;
    
    [self.layer addAnimation:shake forKey:filpKey];
}

- (void)stopFilp
{
    [self.layer removeAnimationForKey:filpKey];
}

#pragma mark 闪烁
- (void)flashing
{
    [self flashing:MAXFLOAT];
}

- (void)flashing:(NSInteger)delay
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    
    animation.toValue=[NSNumber numberWithFloat:0.4];
    
    animation.repeatCount=delay;
    
    animation.duration=.2;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.autoreverses=YES;
    
    [self.layer addAnimation:animation forKey:flashingKey];
}


- (void)stopFlashing
{
    [self.layer removeAnimationForKey:flashingKey];
}

#pragma mark 边框闪烁
- (void)flashLayer
{
    [self flashLayer:MAXFLOAT];
}

- (void)flashLayer:(NSInteger)delay
{
    CABasicAnimation *glowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowColor"];
    glowAnimation.fromValue = (id)self.layer.shadowColor;
    CGColorRef redColor = CGColorRetain([UIColor redColor].CGColor);
    glowAnimation.toValue = (__bridge id)redColor;
    CGColorRelease(redColor);
    
    CABasicAnimation *shadowOpacity = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacity.fromValue = @(self.layer.shadowOpacity);
    shadowOpacity.toValue = @1.f;
    
    CABasicAnimation *shadowOffset = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
    shadowOffset.fromValue = [NSValue valueWithCGSize:CGSizeMake(0,0)];
    shadowOffset.toValue = [NSValue valueWithCGSize:CGSizeMake(0,0)];
    
    CABasicAnimation *shadowRadius = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    shadowRadius.fromValue = @(self.layer.shadowRadius);
    shadowRadius.toValue = @10.f;

    
    CGColorRef whiteishColor = CGColorRetain([UIColor colorWithWhite:0.577 alpha:0.850].CGColor);
    CABasicAnimation *hudBackground = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    hudBackground.fromValue = (id)self.layer.backgroundColor;
    hudBackground.toValue = (__bridge id)whiteishColor;
    
    CGColorRelease(whiteishColor);
    
    CAAnimationGroup *glowGroup = [CAAnimationGroup animation];
    //glowGroup.animations = @[glowAnimation, shadowOpacity, hudBackground];
    glowGroup.animations = @[glowAnimation, shadowOpacity,shadowRadius,shadowOffset];
    glowGroup.duration = .3;
    glowGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    glowGroup.autoreverses = YES;
    glowGroup.repeatCount = delay;
    
    [self.layer addAnimation:glowGroup forKey:flashLayet];

}

- (void)stopFlashLayer
{
    [self.layer removeAnimationForKey:flashLayet];
}

#pragma mark 放大再缩小
- (void)popUp
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformScale(self.transform,1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)popUp:(void(^)())finish
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformScale(self.transform,1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if(finish)
            {
                finish();
            }
        }];
    }];
}

#pragma mark 移动
- (void)move:(CGPoint)point
{
    [UIView animateWithDuration:.4 animations:^{
        self.origin = point;
    }];
}

- (void)move:(CGPoint)point finish:(void(^)())finish
{
    [UIView animateWithDuration:.4 animations:^{
        self.origin = point;
    } completion:^(BOOL finished) {
        if(finish)
        {
            finish();
        }
    }];
}

#pragma mark 渐渐隐藏
- (void)fadeHide:(void(^)())finish
{
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finish)
        {
            finish();
        }
    }];
}

#pragma mark 渐渐显示
- (void)fadeShow:(void(^)())finish
{
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (finish)
        {
            finish();
        }
    }];
}

#pragma mark 抛物线

-(void)parabola:(CGPoint)point
{
    [self parabola:point scale:1];
}

-(void)parabola:(CGPoint)point scale:(float)scale
{
    float duration = 1.0;
    
    CGPoint orignal =  self.center;
    CGPoint focus = CGPointZero;
    CGPoint symPoint = CGPointZero;
    CGPoint destPoint = point;
    focus.x = orignal.x + (destPoint.x - orignal.x)/2;
    focus.y = orignal.y - (destPoint.y - orignal.y);
    
    symPoint.x = 2* focus.x - orignal.x;
    symPoint.y = orignal.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,orignal.x,orignal.y);
    CGPathAddQuadCurveToPoint(path,NULL,focus.x ,focus.y,destPoint.x,destPoint.y);
    CAKeyframeAnimation *
    animation = [CAKeyframeAnimation
                 animationWithKeyPath:@"position"];
    [animation setPath:path];
    [animation setDuration:duration];
    CFRelease(path);
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = [NSNumber numberWithFloat:scale];
    scaleAnimation.duration = duration;
    
    
    CAAnimationGroup * animationGp = [CAAnimationGroup animation];
    animationGp.duration = duration;
    animationGp.animations = @[animation,scaleAnimation];
    
    [self.layer addAnimation:animationGp forKey:nil];
    
    self.center = point;
    
    self.transform =CGAffineTransformMakeScale(scale, scale);
}



@end
