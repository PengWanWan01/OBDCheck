//
//  editDashboardsView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectStyleDelegete <NSObject>

@optional
- (void)selectStyleBtnBetouched:(NSInteger)index;
- (void)AlertBetouched:(NSInteger)index;

@end
@interface editDashboardsView : UIView
@property (nonatomic, weak) id <selectStyleDelegete> delegate;

- (void)show;
- (void)hide;
@end
