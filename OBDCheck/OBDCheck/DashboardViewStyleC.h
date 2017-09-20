//
//  DashboardViewStyleC.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DashboardC;
@protocol StyleCtouchMoveDelegate <NSObject>

- (void)touchMoveWithcenterX:(CGFloat)centerX WithcenterY:(CGFloat)WithcenterY;
- (void)tap:(UILongPressGestureRecognizer *)sender;
- (void)pinchtap:(UIPinchGestureRecognizer *)sender OrignX:(CGFloat )orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height;
@end

@interface DashboardViewStyleC : UIView
{
    CGPoint startPoint;
}
@property (nonatomic,weak) id<StyleCtouchMoveDelegate> delegate;

@property (nonatomic,strong) UILabel *PIDLabel;
@property (nonatomic,strong) UILabel *NumberLabel;
@property (nonatomic,strong) UILabel *UnitLabel;


- (void)initWithModel:(DashboardC *)model;



@end
