//
//  NetWorkClient.h
//  Shove
//
//  Created by 李小斌 on 14-9-22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

//#define APP_PATH @"port188/Services"
//#define APP_PATH @"Login/Index"
#define APP_PATH @"Services"
@protocol HTTPClientDelegate;

@interface NetWorkClient : AFHTTPSessionManager

@property (nonatomic, weak) id<HTTPClientDelegate>delegate;

@property (assign, nonatomic) NSInteger tag;

- (instancetype)init;

- (NSURLSessionDataTask *) requestGet:(NSString *)URLString withParameters:(NSDictionary *)parameters;

- (NSURLSessionDataTask *) requestWithParameters:(NSMutableDictionary *)parameters withType:(NSString *) type;

/**
    取消任务
 */
-(void) cancel;

@end

@protocol HTTPClientDelegate <NSObject>

@optional

-(void) startRequest;

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj;

-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error;

/**
 *  请求成功的回调方法
 *
 *  @param client NetWorkClient
 *  @param task   NSURLSessionDataTask
 *  @param obj    请求成功返回的参数
 *  @param type   请求的接口
 */
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj withType:(NSString *)type;

/**
 *  请求失败的回调方法
 *
 *  @param client NetWorkClient
 *  @param task   NSURLSessionDataTask
 *  @param error  NSError
 *  @param type   请求的接口
 */
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error withType:(NSString *)type;

/**
 *  没有网络
 */
-(void) networkError;

/**
 *  登录超时事件
 */
- (void)outOfTimeAction;
@end
