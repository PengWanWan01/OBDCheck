//
//  DashboardViewStyleC.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewStyleC : UIView
{
    CGPoint startPoint;
}
@property (nonatomic,strong) UILabel *PIDLabel;
@property (nonatomic,strong) UILabel *NumberLabel;
@property (nonatomic,strong) UILabel *UnitLabel;

@property (nonatomic,copy) NSString *innerColor;
@property (nonatomic,copy) NSString *outerColor;

@property (nonatomic,assign) CGFloat Gradientradius;

@property (nonatomic,copy) NSString *titleColor;
@property (nonatomic,assign) CGFloat titleFontScale;
@property (nonatomic,assign) CGFloat titlePositon;

@property (nonatomic,assign) BOOL ValueVisible;
@property (nonatomic,copy ) NSString *ValueColor;
@property (nonatomic,assign) CGFloat ValueFontScale;
@property (nonatomic,assign) CGFloat ValuePositon;

@property (nonatomic,copy ) NSString *UnitColor;
@property (nonatomic,assign) CGFloat UnitFontScale;
@property (nonatomic,assign) CGFloat UnitPositon;

@property (nonatomic,copy) NSString *FrameColor;
@property (nonatomic,assign) CGFloat FrameScale;

- (void)drawinnerColor:(NSString *)innerColor OuterColor:(NSString *)outerColor Gradientradius:(CGFloat)gradientradius TitleColor:(NSString *)titlecolor TiltefontScale:(CGFloat)tiltefontScale TitlePosition:(CGFloat)titlePosition ValueVisible:(BOOL)valueVisible  Valuecolor:(NSString *)ValueColor  ValueFontScale:(CGFloat)valueFontScale ValuePositon:(CGFloat)valuePositon UnitColor:(NSString *)unitColor UnitFontScale:(CGFloat)unitFontScale  UnitPositon:(CGFloat)unitPositon FrameColor:(NSString *)frameColor FrameScale:(CGFloat)frameScale;



@end
