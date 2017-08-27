//
//  DashboardViewStyleB.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardViewStyleB.h"
#define KMultipleB  ViewWidth/300
@implementation DashboardViewStyleB

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //添加仪表盘的底盘
        self.image = [UIImage imageNamed:@"Dashboard"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        
      
        
    }
    return self;
}
- (void)drawgradient:(NSString *)backViewColor GradientRadius:(CGFloat)gradientRadius TitlteColor:(NSString *)titlteColor TitlteFontScale:(CGFloat )titlteFontScale TitlePositon:(CGFloat)titlePositon ValueVisible:(BOOL )valueVisible Valuecolor:(NSString *)ValueColor  ValueFontScale:(CGFloat)valueFontScale ValuePositon:(CGFloat)valuePositon UnitColor:(NSString *)unitColor UnitFontScale:(CGFloat)unitFontScale  UnitPositon:(CGFloat)unitPositon PointColor:(NSString *)PointColor PointWidth:(CGFloat )PointWidth Fillenable:(BOOL)fillenable  FillPosition:(CGFloat)fillPosition{
    //添加渐变色
//    [ColorTools colorWithHexString:@"00a6ff"];

    gradientView *view = [[gradientView alloc]initWithFrame:self.bounds];
    view.gradientColor = [ColorTools colorWithHexString:backViewColor];
    self.backColor = backViewColor;
    self.GradientRadius = gradientRadius;
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    //添加仪表盘中间的内容
    [self addmiddle:titlteColor TitlteFontScale:titlteFontScale TitlePositon:titlePositon ValueVisible:valueVisible Valuecolor:ValueColor ValueFontScale:valueFontScale ValuePositon:valuePositon UnitColor:unitColor UnitFontScale:unitFontScale UnitPositon:unitPositon ];

    //添加仪表盘 底部的内容
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 100*KMultipleB, self.bounds.size.width -73.0*KMultipleB , 200.0*KMultipleB,  70.0*KMultipleB)];
    image2.image = [UIImage imageNamed:@"yuanhu"];
    image2.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:image2];

    //添加进度条
    [self draw:self.bounds.size.width/2 - 23.0*KMultipleB lineWidth:12.0*KMultipleB lineColor:[ColorTools colorWithHexString:@"1d2027"] startAngle:(M_PI / 4) +(M_PI/18) endAngle: M_PI *3/4-M_PI/18];
    [self draw:self.bounds.size.width/2 - (23.0/300)*self.frame.size.width lineWidth:12.0*KMultipleB lineColor:[ColorTools colorWithHexString:backViewColor] startAngle:(M_PI / 2) endAngle: M_PI *3/4-M_PI/18];
}
- (void)addmiddle:(NSString *)titlteColor TitlteFontScale:(CGFloat )titlteFontScale TitlePositon:(CGFloat)titlePositon ValueVisible:(BOOL )valueVisible Valuecolor:(NSString *)ValueColor  ValueFontScale:(CGFloat)valueFontScale ValuePositon:(CGFloat)valuePositon UnitColor:(NSString *)unitColor UnitFontScale:(CGFloat)unitFontScale  UnitPositon:(CGFloat)unitPositon {
    
    UIImageView *innerimage = [[UIImageView alloc]initWithFrame:CGRectMake(43.0*KMultipleB, 43.0*KMultipleB, self.bounds.size.width - 86.0*KMultipleB,  self.bounds.size.width - 86.0*KMultipleB)];
    innerimage.image = [UIImage imageNamed:@"circle-top"];
    innerimage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:innerimage];
    
    _NumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(innerimage.bounds.size.width/2 - 25.0*KMultipleB)*valuePositon , innerimage.bounds.size.width, 60.0*KMultipleB)];
     _NumberLabel.font =    [UIFont fontWithName:@"DBLCDTempBlack"size:56.0*KMultipleB*valueFontScale];
  
    // [ColorTools colorWithHexString:@"#FFFFFF"]
    _NumberLabel.textColor = [ColorTools colorWithHexString: ValueColor];
    
    _NumberLabel.textAlignment = NSTextAlignmentCenter;
    _NumberLabel.text = @"2500";
    self.ValueColor  = ValueColor;
    self.ValueFontScale = valueFontScale;
    self.ValuePositon = valuePositon;
    [innerimage addSubview:_NumberLabel];
    
    self.ValueVisible = valueVisible;
    //[ColorTools colorWithHexString:@"#757476"]
    _PIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (25*KMultipleB)*titlePositon, innerimage.bounds.size.width, 30.0*KMultipleB)];
    _PIDLabel.font = [UIFont boldSystemFontOfSize:24.0*KMultipleB*titlteFontScale];
    _PIDLabel.textColor =[ColorTools colorWithHexString: titlteColor];
    _PIDLabel.textAlignment = NSTextAlignmentCenter;
    _PIDLabel.text = @"MPH";
    self.titleColor  = titlteColor;
    self.titleFontScale = titlteFontScale;
    self.titlePositon = titlePositon;
    [innerimage addSubview:_PIDLabel];
    
    
    //[ColorTools colorWithHexString:@"#757476"];
    _UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(_NumberLabel.frame) + 10*KMultipleB)*unitPositon, innerimage.bounds.size.width, 24.0*KMultipleB)];
    _UnitLabel.font = [UIFont boldSystemFontOfSize:17*KMultipleB*unitFontScale];
    _UnitLabel.textColor =  [ColorTools colorWithHexString:unitColor];
    _UnitLabel.textAlignment = NSTextAlignmentCenter;
    _UnitLabel.text = @"R/MIN";
    self.UnitColor = unitColor;
    self.UnitFontScale = unitFontScale;
    self.UnitPositon = unitPositon;
    [innerimage addSubview:_UnitLabel];
}
- (void)draw:(CGFloat )radius lineWidth:(CGFloat)width lineColor:(UIColor *)color startAngle:(CGFloat)start endAngle:(CGFloat)end{
    CGPoint _c = CGPointMake(self.bounds.size.width/2   , self.bounds.size.width/2 );
    CGFloat _r = radius;
    CGFloat startAngle =start; // 开始角度
    CGFloat endAngle = end; // 结束角度
    BOOL clockwise = YES; // 顺时针
    
    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = width;
    //    circleLayer.lineCap = kCALineCapRound;
    //    circleLayer.lineJoin = kCALineJoinMiter;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = color.CGColor;
    
    // path
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_c radius:_r startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    
    [containerLayer addSublayer:circleLayer];
    
    [ self.layer addSublayer:containerLayer];
    
    
}
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //保存触摸起始点位置
//    CGPoint point = [[touches anyObject] locationInView:self];
//    startPoint = point;
//    
//    //该view置于最前
//    [[self superview] bringSubviewToFront:self];
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //计算位移=当前位置-起始位置
//    CGPoint point = [[touches anyObject] locationInView:self];
//    float dx = point.x - startPoint.x;
//    float dy = point.y - startPoint.y;
//    
//    //计算移动后的view中心点
//    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
//    
//    
//    /* 限制用户不可将视图托出屏幕 */
//    float halfx = CGRectGetMidX(self.bounds);
//    //x坐标左边界
//    newcenter.x = MAX(halfx, newcenter.x);
//    //x坐标右边界
//    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
//    
//    //y坐标同理
//    float halfy = CGRectGetMidY(self.bounds);
//    newcenter.y = MAX(halfy, newcenter.y);
//    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
//    
//    //移动view
//    self.center = newcenter;
//}

@end
