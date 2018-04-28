//
//  Message.m
//  C库
//
//  Created by yutaozhao on 2018/4/27.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "Message.h"

@implementation Message
-(void)SendMessgaeOC{
    NSLog(@"Test SendMessgaeOC");
    //
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"Tag", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"send" object:nil userInfo:dict];
    //
    
}
-(void) GetMessgaeOCWaitTime: (NSNumber *) mS{
    NSLog(@"%d",[mS intValue]);
    NSInteger mSInt = [mS intValue];
    if ([mS intValue]) {
        while ((!([OBDLibTools sharedInstance].MessageVal == 2)) && (mSInt--)) {//等待库线程处理完成
            sleep(1);//节约CPU资源
        }
    }else{
        while (!([OBDLibTools sharedInstance].MessageVal == 2)) {//等待库线程处理完成
            sleep(1);//节约CPU资源
        }
    }
    
}
@end
