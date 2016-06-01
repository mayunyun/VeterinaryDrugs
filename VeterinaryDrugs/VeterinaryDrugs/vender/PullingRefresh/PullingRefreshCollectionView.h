//
//  PullingRefreshCollectionView.h
//  ShareWedding
//
//  Created by yyt on 14-9-14.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@protocol PullingRefreshCollectionViewDelegate;

@interface PullingRefreshCollectionView : UICollectionView
<UIScrollViewDelegate>{
    PullLoadingView *_headerView;
    PullLoadingView *_footerView;
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    NSInteger _bottomRow;
}
@property (assign,nonatomic) id <PullingRefreshCollectionViewDelegate> pullingDelegate;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;


- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshCollectionViewDelegate>)aPullingDelegate;

- (void)collectionViewDidScroll:(UIScrollView *)scrollView;

- (void)collectionViewDidEndDragging:(UIScrollView *)scrollView;

- (void)collectionViewDidFinishedLoading;

- (void)collectionViewDidFinishedLoadingWithMessage:(NSString *)msg;

- (void)launchRefreshing;

- (void)flashMessage:(NSString *)msg;
@end



@protocol PullingRefreshCollectionViewDelegate <NSObject>

@required
- (void)pullingcollectionViewDidStartRefreshing:(PullingRefreshCollectionView *)collectionView;

@optional
//Implement this method if headerOnly is false
- (void)pullingcollectionViewDidStartLoading:(PullingRefreshCollectionView *)collectionView;
//Implement the follows to set date you want,Or Ignore them to use current date
- (NSDate *)pullingcollectionViewRefreshingFinishedDate;
- (NSDate *)pullingcollectionViewLoadingFinishedDate;
@end

//Usage example
/*
 _collectionView = [[PullingRefreshcollectionView alloc] initWithFrame:frame pullingDelegate:aPullingDelegate];
 [self.view addSubview:_collectionView];
 _collectionView.autoScrollToNextPage = NO;
 _collectionView.delegate = self;
 _collectionView.dataSource = self;
 */
