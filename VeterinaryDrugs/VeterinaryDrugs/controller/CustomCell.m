//
//  CustomCell.m
//  CollectionViewDemo
//
//  Created by LaoWen on 15/5/29.
//  Copyright (c) 2015年 LaoWen. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)dealloc {
    [_textLabel release];
    [_imageView release];
    [super dealloc];
}
@end
