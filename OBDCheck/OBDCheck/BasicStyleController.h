//
//  BasicStyleController.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/21.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "BasicViewController.h"
@protocol chosseBoardStyleDelegete <NSObject>

- (void)chosseBoardStyleBetouched:(NSInteger)index;

@end

@interface BasicStyleController : BasicViewController
@property (nonatomic, weak) id <chosseBoardStyleDelegete> delegate;

@end
