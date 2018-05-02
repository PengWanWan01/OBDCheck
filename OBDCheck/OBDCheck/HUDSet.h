//
//  HUDSet.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/5/2.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDSet : NSObject
@property (nonatomic,assign) NSInteger  ID;
@property (nonatomic,copy) NSString *PIDColor;
@property (nonatomic,copy) NSString *NumberColor;
@property (nonatomic,copy) NSString *UnitColor;

@end
