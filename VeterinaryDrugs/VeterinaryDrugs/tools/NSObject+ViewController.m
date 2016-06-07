//
//  NSObject+ViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/6/6.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "NSObject+ViewController.h"

@implementation NSObject (ViewController)

- (UIViewController *)ViewController{
    
    UIViewController *viewC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    return viewC;
}

@end
