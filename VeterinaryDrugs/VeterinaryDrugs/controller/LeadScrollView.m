//
//  LeadScrollView.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/27.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "LeadScrollView.h"

@interface LeadScrollView ()

@property (nonatomic , strong) UIPageControl *pageContrl;

@property (nonatomic , strong) NSTimer *codeTimer;


@end

@implementation LeadScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatIMG];
        [self setPagingEnabled:YES];
    }
    return self;
}

- (void)creatIMG
{
    self.pagingEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    //创建图片
    for(int i = 0 ; i < LeadPictures.count ; i ++)
    {
        UIImageView *leadPicture = [[UIImageView alloc] initWithFrame:self.bounds];
        leadPicture.left = i * self.width;
        leadPicture.image = [UIImage imageNamed:LeadPictures[i]];
        [self addSubview:leadPicture];
    }
}

- (void)createPageContrl
{
    //页码
    self.pageContrl = [[UIPageControl alloc] init];
    self.pageContrl.width = LeadPictures.count * 20;
    self.pageContrl.height = 20;
    self.pageContrl.right = self.left + self.width - mScreenWidth/2+self.pageContrl.width/2;
//    self.pageContrl.right = self.left + self.width -10;
    self.pageContrl.bottom = self.top + self.height;
    self.pageContrl.numberOfPages = LeadPictures.count;
    [self.superview addSubview:self.pageContrl];
}

- (void)beginTouchAction
{
    [self.codeTimer invalidate];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FristLaunch];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.beginBlock();
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 0;
        self.pageContrl.alpha =0;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageContrl.currentPage = self.contentOffset.x/mScreenWidth;
    
    if(self.pageContrl.currentPage == LeadPictures.count - 1)
    {
        self.pageContrl.currentPage = LeadPictures.count - 1;
        self.scrollEnabled = NO;
        //初始化定时器
        self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginTouchAction) userInfo:nil repeats:YES];
    }
}

#pragma mark 类方法-判断程序是否第一次启动
+ (BOOL)launchFirst
{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:FristLaunch] boolValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
