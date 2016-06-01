//
//  PullingRefreshScrollView.h
//  WeddingSweet
//
//  Created by yyt on 14-12-19.
//  Copyright (c) 2014年 iwed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@class PullingRefreshScrollView;
@protocol PullingRefreshScrollViewDelegate <NSObject>

@required
- (void)pullingscrollViewDidStartRefreshing:(PullingRefreshScrollView *)scrollView;

@optional
//Implement this method if headerOnly is false
- (void)pullingscrollViewDidStartLoading:(PullingRefreshScrollView *)scrollView;
//Implement the follows to set date you want,Or Ignore them to use current date
- (NSDate *)pullingscrollViewRefreshingFinishedDate;
- (NSDate *)pullingscrollViewLoadingFinishedDate;
@end


@interface PullingRefreshScrollView : UIScrollView
<UIScrollViewDelegate>{
    PullLoadingView *_headerView;
    PullLoadingView *_footerView;
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    NSInteger _bottomRow;
}
@property (assign,nonatomic) id <PullingRefreshScrollViewDelegate> pullingDelegate;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;


- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshScrollViewDelegate>)aPullingDelegate;

- (void)ascrollViewDidScroll:(UIScrollView *)scrollView;

- (void)ascrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)ascrollViewDidFinishedLoading;

- (void)ascrollViewDidFinishedLoadingWithMessage:(NSString *)msg;

- (void)launchRefreshing;

- (void)flashMessage:(NSString *)msg;
@end





