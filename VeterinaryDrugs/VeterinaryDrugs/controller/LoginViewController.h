//
//  LoginViewController.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/30.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

typedef enum {
    typeHomeViewShopToLogin = 0,
    typeTabBarShopToLogin,
    typeTabBarMineToLogin,
}	TypeLoginSource;
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property(nonatomic)TypeLoginSource typeLoginSource;

@end
