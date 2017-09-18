//
//  DashboardViewStyleB.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DashboardB;
@protocol StyleBtouchMoveDelegate <NSObject>

- (void)touchMoveWithcenterX:(CGFloat)centerX WithcenterY:(CGFloat)WithcenterY;
- (void)tap:(UILongPressGestureRecognizer *)sender;
- (void)pinchtap:(UIPinchGestureRecognizer *)sender OrignX:(CGFloat )orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height;
@end
@interface DashboardViewStyleB : UIImageView
{
    CGPoint startPoint;
}
@property (nonatomic,weak) id<StyleBtouchMoveDelegate> delegate;
@property (nonatomic,strong)   UIView *triangleView ; //指针视图

@property (nonatomic,strong)UILabel *PIDLabel;
@property (nonatomic,strong)UILabel *NumberLabel;
@property (nonatomic,strong)UILabel *UnitLabel;

- (void)initWithModel:(DashboardB *)model;

- (void)rotateImageView:(CGFloat)StartAngle Withend:(CGFloat)endAngle ;


@end
