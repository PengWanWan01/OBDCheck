//
//  DashboardViewStyleB.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StyleBtouchMoveDelegate <NSObject>

- (void)touchMoveWithcenterX:(CGFloat)centerX WithcenterY:(CGFloat)WithcenterY;
- (void)tap:(UILongPressGestureRecognizer *)sender;

@end
@interface DashboardViewStyleB : UIImageView
{
    CGPoint startPoint;
}
@property (nonatomic,weak) id<StyleBtouchMoveDelegate> delegate;

@property (nonatomic,strong)UILabel *PIDLabel;
@property (nonatomic,strong)UILabel *NumberLabel;
@property (nonatomic,strong)UILabel *UnitLabel;

@property (nonatomic,copy) NSString *backColor;
@property (nonatomic,assign) CGFloat GradientRadius;

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

@property (nonatomic,copy) NSString *pointerColor;
@property (nonatomic,assign) CGFloat Pointerwidth;
@property (nonatomic,assign) BOOL FillEnable;
@property (nonatomic,copy ) NSString *FillColor;

- (void)drawgradient:(NSString *)backViewColor GradientRadius:(CGFloat)gradientRadius TitlteColor:(NSString *)titlteColor TitlteFontScale:(CGFloat )titlteFontScale TitlePositon:(CGFloat)titlePositon ValueVisible:(BOOL )valueVisible Valuecolor:(NSString *)ValueColor  ValueFontScale:(CGFloat)valueFontScale ValuePositon:(CGFloat)valuePositon UnitColor:(NSString *)unitColor UnitFontScale:(CGFloat)unitFontScale  UnitPositon:(CGFloat)unitPositon PointColor:(NSString *)PointColor PointWidth:(CGFloat )PointWidth Fillenable:(BOOL)fillenable  FillColor:(NSString *)fillColor;



@end
