//
//  MyNavViewController.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavViewController : UINavigationController

//返回按钮
+ (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action;

@end
