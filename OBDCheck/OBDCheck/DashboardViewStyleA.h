//
//  DashboardView.h
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardView : UIView
{
    CGPoint startPoint;    
}
/*
 * 环形宽度
 */
@property (nonatomic, assign) CGFloat ringWidth;

/*
 * 刻度线长度
 */
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

@property (nonatomic,assign) NSInteger maxNumber;
@property (nonatomic,assign) NSInteger minNumber;

@property (nonatomic,assign) CGFloat StartAngle; //开始角度
@property (nonatomic,assign) CGFloat endAngle;  //结束角度
@property (nonatomic) UIColor *innerColor;  //内径的颜色
@property (nonatomic) UIColor *outerColor;  //外径的颜色
@property (nonatomic,assign) CGFloat LongscaleWidth; //长刻度宽度
@property (nonatomic,assign) CGFloat ShortscaleWidth; //短刻度宽度


@end
