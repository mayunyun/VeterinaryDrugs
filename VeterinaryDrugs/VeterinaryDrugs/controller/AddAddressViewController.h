//
//  AddAddressViewController.h
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/6/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

typedef enum {
    typeAdd = 0,
    typeEdit ,
}	TypeAddAddress;

#import "MineUserModel.h"
#import "MineNavCommonViewController.h"

@interface AddAddressViewController : MineNavCommonViewController

@property (nonatomic)TypeAddAddress typeAddAddress;
@property (nonatomic,strong)MineUserAddressListModel* editModel;

@end
