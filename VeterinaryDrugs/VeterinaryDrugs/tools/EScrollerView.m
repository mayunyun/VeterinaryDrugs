//
//  EScrollerView.m
//  Hnair4iPhone
//
//  Created by 02 on 14-6-18.
//  Copyright (c) 2014年 yingkong1987. All rights reserved.
//

#import "EScrollerView.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+ProgressView.h"
#define width self.bounds.size.width
#define height self.bounds.size.height
@interface EScrollerView()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSMutableArray *_imageArray;
    NSTimer *timer;
    NSInteger _currentPageIndex;
    
}
@end

@implementation EScrollerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr
{
 
    self = [super initWithFrame:rect];
    if (self) {
        _currentPageIndex = 0;
        _imageArray = [[NSMutableArray alloc]initWithArray:imgArr];
        [_imageArray insertObject:[imgArr lastObject] atIndex:0];
        [_imageArray addObject:[imgArr firstObject]];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(width *_imageArray.count, height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.pagingEnabled = YES;
        
        for (int i = 0; i<_imageArray.count; i++) {
          //  NSLog(@"img %@ ",[_imageArray objectAtIndex:i]);
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, height)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];

            imgView.tag = i;
            imgView.userInteractionEnabled = YES;
//            imgView.layer.cornerRadius = 6.0f;
//            imgView.layer.masksToBounds = YES;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHaddle:)]];
            [_scrollView addSubview:imgView];
        }
        _scrollView.contentOffset = CGPointMake(width, 0);
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height - 30, width, 30)];
        _pageControl.currentPageIndicatorTintColor = RGB(240, 60, 70);
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = imgArr.count;
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(pageControlChange) forControlEvents:UIControlEventValueChanged];
        [_pageControl updateCurrentPageDisplay];
        
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(showNextImage) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)showNextImage
{
    CGFloat pageWidth = _scrollView.contentOffset.x + _scrollView.width;
    
    if (_scrollView.contentOffset.x < (([_imageArray count]-1) * _scrollView.width) ) {
        [UIView animateWithDuration:0.3f animations:^{
            _scrollView.contentOffset = CGPointMake(pageWidth, 0);
        }];
    }else {
        _scrollView.contentOffset = CGPointMake(width, 0);
    }
    
    _currentPageIndex = floor((_scrollView.contentOffset.x - width / 2) / width)+1;
    _pageControl.currentPage = _currentPageIndex - 1;
    if (_currentPageIndex == [_imageArray count] - 1) {
        _pageControl.currentPage = 0;
    }
    if (_currentPageIndex == 0) {
        _pageControl.currentPage = [_imageArray count] - 2;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([timer isValid]){
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:4]];
    }
    _currentPageIndex = floor((scrollView.contentOffset.x - width / 2) / width)+1;
    _pageControl.currentPage = _currentPageIndex - 1;
    if (_currentPageIndex == [_imageArray count] - 1) {
        _pageControl.currentPage = 0;
    }
    if (_currentPageIndex == 0) {
        _pageControl.currentPage = [_imageArray count] - 3;
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_currentPageIndex == 0) {
        
        [_scrollView setContentOffset:CGPointMake(([_imageArray count]-2)*width, 0)];
    }
    if (_currentPageIndex == [_imageArray count] - 1) {
        
        _currentPageIndex = -1;
        [_scrollView setContentOffset:CGPointMake(width, 0)];
        
    }
}
- (void)pageControlChange
{
    _currentPageIndex = _pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(width * _pageControl.currentPage, 0)];
}
- (void)tapHaddle:(UITapGestureRecognizer *)tap
{
        if ([_delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
    if (tap.view.tag == _imageArray.count - 1) {
        [_delegate EScrollerViewDidClicked:0];
        return;
    }
    if (tap.view.tag == 0) {
        [_delegate EScrollerViewDidClicked:_imageArray.count - 2];
        return;
    }
    [_delegate EScrollerViewDidClicked:tap.view.tag - 1];
}
}

@end
