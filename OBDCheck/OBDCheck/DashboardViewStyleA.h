//
//  DashboardView.h
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomDashboard;
@protocol touchMoveDelegate <NSObject>
- (void)touchMoveWithcenterX:(CGFloat)centerX WithcenterY:(CGFloat)WithcenterY;
- (void)tap:(UILongPressGestureRecognizer *)sender;
- (void)pinchtap:(UIPinchGestureRecognizer *)sender OrignX:(CGFloat )orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height;

@end
@interface DashboardView : UIView
{
    CGPoint startPoint;
   
}
@property (nonatomic,strong)   UIView *triangleView ; //指针视图

@property (nonatomic,weak) id<touchMoveDelegate> delegate;
@property (nonatomic, assign) CGFloat dialLength;

/*
 * 每一个扇形块的刻度个数
 */
@property (nonatomic, assign) NSInteger dialPieceCount;

/*
 * 指针视图
 */
@property (nonatomic, strong) UIImageView *pointerView;

/*
 * 显示信息的label
 */
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic,strong)  UILabel  *numberLabel;
@property (nonatomic,strong)  UILabel  *unitLabel;
@property (nonatomic,strong) NSMutableArray *scaleNumberLabel;





@property (nonatomic,copy) NSString  *infoLabeltext; //名字

- (void)initWithModel:(CustomDashboard *)model;

- (void)addGradientView:(NSString *)gradientColor GradientViewWidth:(CGFloat )gradientViewWidth;
- (void)rotationWithStartAngle:(CGFloat)StartAngle WithEndAngle:(CGFloat)endAngle;
- (void)updateTOFont;
@end
