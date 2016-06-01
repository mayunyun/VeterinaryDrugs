//
//  Httptool.m
//  zhicai
//
//  Created by 陈思思 on 15/7/21.
//  Copyright (c) 2015年 perfect. All rights reserved.
//

#import "Httptool.h"

@implementation Httptool

+ (void)showCustInfo:(NSString*)title MessageString:(NSString*)message
{
    //empty
    if (message == nil || message.length == 0) {
        return;
    }
    
    //found html tag and other unexpected message
    if ([message.lowercaseString rangeOfString:@"<html"].location != NSNotFound ||
        [message.lowercaseString rangeOfString:@"an error has occurred"].location != NSNotFound)
    {
        message = @"服务器错误发生，我们正在解决中";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}

+ (AFHTTPRequestOperationManager *)manager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return manager;
}


/**
 *  完整的url
 */
+(NSString *)intactUrlWithUrl:(NSString *)url
{
    return [NSString stringWithFormat:@"%@/%@",ShouYaoHttpServer,url];
}

/**
 * GET请求
 */
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure{
 //   NSLog(@"%@",[self intactUrlWithUrl:url]);
    [[self manager] GET:[self intactUrlWithUrl:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            NSInteger code = [operation response].statusCode;
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(json,code);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error - %@", error);
        if(failure){
            failure(error);
        }
    }];
}

/**
 * POST请求
 */
+ (void)postWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure{
   //  NSLog(@"%@",[self intactUrlWithUrl:url]);
    [[self manager] POST:[self intactUrlWithUrl:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            NSInteger code = [operation response].statusCode;
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
//#if DEBUG
//            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            DebugLog(@"\n\n urlString : %@ \n%@\n\n",url,string);
//#endif
            
            success(json,code);
           
        }
        // NSLog(@"%@",[self intactUrlWithUrl:url]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
             NSLog(@"%@",[self intactUrlWithUrl:url]);
        }
    }];
}

+(NSString *)intactHtmlUrlWithUrl:(NSString *)url
{
    return [NSString stringWithFormat:@"%@/%@",ZhiXuanLCHTMLServer,url];
}

+ (void)postHtmlWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure
{
    //  NSLog(@"%@",[self intactUrlWithUrl:url]);
    [[self manager] POST:[self intactHtmlUrlWithUrl:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            NSInteger code = [operation response].statusCode;
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(json,code);
            
        }
        // NSLog(@"%@",[self intactUrlWithUrl:url]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
            NSLog(@"%@",[self intactUrlWithUrl:url]);
        }
    }];
}

@end
