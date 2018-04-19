//
//  OBDTool.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/9.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "OBDTool.h"

@implementation OBDTool

+(instancetype )sharedInstance{
    static OBDTool *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OBDTool alloc] init];
        
    });
    return _sharedClient;
}
@end
