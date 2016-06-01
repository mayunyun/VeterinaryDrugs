//
//  BaseViewController.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (BOOL)isLoginSeccessWap:(NSString*)client username:(NSString*)user password:(NSString*)pwd;

- (BOOL)ConnectYesOrNo;
//删除多余的cell
- (void)setExtraCellLineHidden: (UITableView *)tableView;

@end
