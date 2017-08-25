//
//  DashboardView.m
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import "DashboardViewStyleA.h"
#define KMultipleA   ViewWidth/150


@interface DashboardView()
{
    CGPoint _center; // 中心点
    CGFloat _radius; // 外环半径
    NSInteger _dialCount; // 刻度线的个数
}
@end

@implementation DashboardView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
   
    self.userInteractionEnabled = YES;
    _center = CGPointMake(ViewWidth / 2, ViewWidth / 2);
    _radius = ViewWidth/ 2 ;
    _dialPieceCount  =5;
    _dialCount = 8 * self.dialPieceCount;
    // 添加外环
    
    return self;
}
//[ColorTools colorWithHexString:@"18191C"].CGColor
- (void)addGradientView:(UIColor *)gradientColor GradientViewWidth:(CGFloat)gradientViewWidth{
//    gradientView *gradientview = [[gradientView alloc]initWithFrame:CGRectMake(0, 0, gradientViewWidth, gradientViewWidth)];
//    gradientview.layer.cornerRadius = ViewWidth/2;
//    gradientview.layer.masksToBounds = YES;
//    gradientview.gradientColor = gradientColor;
    UIView *gradientview =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, gradientViewWidth, gradientViewWidth)];
    gradientview.layer.cornerRadius = ViewWidth/2;
    gradientview.layer.masksToBounds = YES;
    gradientview.backgroundColor = gradientColor;
    [self addSubview:gradientview];
    

}
- (void)addCircleLayer:(CGFloat)RingWidth {
    CGFloat startAngle = 0; // 开始角度
    CGFloat endAngle = 2*M_PI; // 结束角度
    BOOL clockwise = YES; // 顺时针
    
//    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 0;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.fillColor = [ ColorTools colorWithHexString:@"18191c"].CGColor;
    circleLayer.strokeColor = [ColorTools colorWithHexString:@"18191c"].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius-RingWidth startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    [self.layer addSublayer:circleLayer];
   
   
}

// 画刻度
- (void)drawCalibration:(CGFloat )TheAngle WithendAngle:(CGFloat)TheendAngle WithRingWidth:(CGFloat)RingWidth MAJORTICKSWidth:(CGFloat)MAWidth MAJORTICKSLength:(CGFloat)MALength MAJORTICKSColor:(UIColor *)MAColor MINORTICKSWidth:(CGFloat)MIWidth MINORTICKSLength:(CGFloat)MILength MAJORTICKSColor:(UIColor *)MIColor LABELSVisible:(BOOL)Visible Rotate:(BOOL)rotate Font:(UIFont *)font OffestTickline:(CGFloat)offestTick  


{
    [self addCircleLayer:RingWidth];
    [self addSubview:self.pointerView];
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_center.x - 60*KFontmultiple, _center.y- 40*KFontmultiple, 120*KFontmultiple, 30*KFontmultiple)];
    self.infoLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = @"0";
    self.infoLabel.font = [UIFont ToAdapFont:16.f];
    [self addSubview:self.infoLabel];
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ViewWidth + 5, ViewWidth, 20)];
    self.numberLabel.font = [UIFont boldSystemFontOfSize:17];
    self.numberLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"N/A";
    [self addSubview:self.numberLabel];

    self.StartAngle = TheAngle;
    self.endAngle = TheendAngle;
    self.ringWidth = RingWidth;
    self.maLength = MALength;
    self.miLength = MILength;
    self.miWidth =  MIWidth;
    self.maWidth = MAWidth;
    self.maColor = MAColor;
    self.miColor = MIColor;
    
    CGFloat perAngle = (TheendAngle - TheAngle)  / _dialCount;
    
    if (perAngle< 0) {
     perAngle=    -(TheendAngle - TheAngle)/_dialCount;
    }else
    {
    perAngle = (TheendAngle - TheAngle)  / _dialCount;
    }
    for (int i = 0; i<= _dialCount; i++) {
        CGFloat startAngel = (- M_PI + perAngle * i+TheAngle);
        CGFloat endAngel = startAngel + perAngle/10;
        UIBezierPath *tickPath = [[UIBezierPath alloc]init];
        
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        
        
        if (i % 5 == 0) {
            tickPath =   [UIBezierPath bezierPathWithArcCenter:_center radius:_radius-RingWidth- MILength startAngle:startAngel endAngle:endAngel clockwise:YES];
            perLayer = [CAShapeLayer layer];
            
            perLayer.strokeColor = MAColor.CGColor;
            perLayer.lineWidth = MALength;
            //添加刻度
            CGPoint point = [self calculateTextPositonWithArcCenter:_center Angle:-endAngel radius:_radius-RingWidth- MALength- 5];
            NSString *tickText = [NSString stringWithFormat:@"%d",i * 2];
            
            //默认label的大小14 * 14
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 5, point.y - 5, 14, 14)];
            text.text = tickText;
            text.font = font;
            text.textColor = [UIColor whiteColor];
            text.textAlignment = NSTextAlignmentCenter;
            [self addSubview:text];
            
        }else{
            tickPath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius-RingWidth startAngle:startAngel endAngle:endAngel clockwise:YES];
            perLayer = [CAShapeLayer layer];
            
            perLayer.strokeColor = MIColor.CGColor;
            perLayer.lineWidth = MILength;
        }
        
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
}

// 计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel radius:(CGFloat)Theradius{    
    CGFloat x = (Theradius) * cosf(angel);
    CGFloat y = (Theradius) * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}

- (void)drawRect:(CGRect)rect {
   
}


#pragma mark - PointerView
- (UIImageView *)pointerView {
    if (!_pointerView) {
        _pointerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"指针"]];
        _pointerView.frame =  CGRectMake(_center.x - 10, _center.y - self.bounds.size.width/6, 20, self.bounds.size.width/3);
        _pointerView.contentMode = UIViewContentModeScaleAspectFit;
        _pointerView.layer.anchorPoint = CGPointMake(0.5f, 0.9f); // 锚点
        _pointerView.transform = CGAffineTransformMakeRotation(-(M_PI/2 + + M_PI/2));
    }
    return _pointerView;
}


#pragma mark 颜色转化
- (NSString *)hexFromUIColor:(UIColor *)color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

/*
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self];
    startPoint = point;
    
    //该view置于最前
    [[self superview] bringSubviewToFront:self];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - startPoint.x;
    float dy = point.y - startPoint.y;
    
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    
    /* 限制用户不可将视图托出屏幕 */
/*
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    //移动view
    self.center = newcenter;
}
*/
@end
