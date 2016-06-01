//
//  LeadScrollView.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/27.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FristLaunch @"FristLaunch"

typedef void (^BeginBlock)();

#define LeadPictures @[@"2015081204.jpg",@"2016020105.jpg",@"2016021853.jpg",@"2016021863.jpg"]

@interface LeadScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic , copy) BeginBlock beginBlock;

- (id)initWithFrame:(CGRect)frame;

- (void)createPageContrl;

+ (BOOL)launchFirst;

@end
