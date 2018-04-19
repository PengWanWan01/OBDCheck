//
//  NetWorkClient.m
//  Shove
//
//  Created by 李小斌 on 14-9-22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "NetWorkClient.h"
#import "NetWorkConfig.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface NetWorkClient ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation NetWorkClient

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:Baseurl]];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        self.requestSerializer.timeoutInterval = 11;
    }
    return self;
}

+ (instancetype)manager
{
    return [[[self class] alloc] init];
}

- (NSURLSessionDataTask *) requestGet:(NSString *)URLString withParameters:(NSDictionary *)parameters
{
    NSString *restUrl = URLString;
    
    DLog(@"restUrl -> %@/%@", Baseurl, restUrl);
    
    if (![self isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequest)]) {
            [self.delegate startRequest];
        }

        _dataTask = [self GET:restUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            DLog(@"[NetWorkClient] -> task.response==============\n%@\n====================", task.response);
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseSuccess:dataTask:didSuccessWithObject:)]) {
                [self.delegate httpResponseSuccess:self dataTask:task didSuccessWithObject:responseObject];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseFailure:dataTask:didFailWithError:)]) {
                [self.delegate httpResponseFailure:self dataTask:task didFailWithError:error];
            }
        }];

    }
    return _dataTask;
}

- (NSURLSessionDataTask *) requestWithParameters:(NSMutableDictionary *)parameters withType:(NSString *)type
{
   
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *restUrl = [NSString stringWithFormat:@"%@/%@", APP_PATH,type];
      self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
     DLog(@"参数列表---->%@ \nrestUrl -> %@/%@", parameters,Baseurl, restUrl);
   
    if (![self isNetworkEnabled]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(networkError)]) {
            [self.delegate networkError];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRequest)]) {
            [self.delegate startRequest];
        }
    
        _dataTask = [self GET:restUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseSuccess:dataTask:didSuccessWithObject:withType:)]) {
                DLog(@"[NetWorkClient] -> task.response==============\n%@\n====================", task.response);
                [self.delegate httpResponseSuccess:self dataTask:task didSuccessWithObject:responseObject withType:type];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DLog(@"失败");
            if (self.delegate && [self.delegate respondsToSelector:@selector(httpResponseFailure:dataTask:didFailWithError:withType:)]) {
                [self.delegate httpResponseFailure:self dataTask:task didFailWithError:error withType:type];
            }
        }];
        
    }
    return _dataTask;
}


//-判断当前网络是否可用
-(BOOL) isNetworkEnabled
{
    BOOL bEnabled = FALSE;
    NSString *url = @"www.baidu.com";
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    
    bEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    
    CFRelease(ref);
    if (bEnabled) {
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        bEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
    }
    
    return bEnabled;
}

-(void)cancel
{
    if (_dataTask != nil) {
        [_dataTask cancel];
    }
}

@end
