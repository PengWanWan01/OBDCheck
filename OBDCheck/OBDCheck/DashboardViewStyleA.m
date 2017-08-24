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
    self.backgroundColor = [ColorTools colorWithHexString:@"18191C"];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    _center = CGPointMake(ViewWidth / 2, ViewWidth / 2);
    _ringWidth = 10;
    _radius = ViewWidth/ 2 ;
    _dialPieceCount  =5;
    _LongscaleWidth = 15.f;
    _ShortscaleWidth = 5.f;
    _dialCount = 8 * self.dialPieceCount;
    // 添加外环
    [self addCircleLayer];
    [self addSubview:self.pointerView];
    [self addSubview:self.infoLabel];
    
    return self;
}

- (void)addCircleLayer {
    CGFloat startAngle = self.StartAngle; // 开始角度
    CGFloat endAngle = self.endAngle; // 结束角度
    BOOL clockwise = YES; // 顺时针
    
    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = self.ringWidth;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    [containerLayer addSublayer:circleLayer];
    for (int i = 0; i <= _dialCount; i++) {
        [self containerLayer:self.layer addDialWithIndex:i]; // 添加刻度
    }
    [self.layer addSublayer:containerLayer];
   
}

- (void)containerLayer:(CALayer *)containerLayer addDialWithIndex:(NSInteger)index {
    self.StartAngle  = 0; // 开始角度
    self.endAngle = M_PI ; // 结束角度
    
    
    CGFloat perAngle = (self.endAngle - self.StartAngle)  / _dialCount;
    CGFloat startAngel = (- M_PI + perAngle * index);
    CGFloat endAngel = startAngel + perAngle/10;
    UIBezierPath *tickPath = [[UIBezierPath alloc]init];
    
    CAShapeLayer *perLayer = [CAShapeLayer layer];
    
    
    if (index % 5 == 0) {
        tickPath =   [UIBezierPath bezierPathWithArcCenter:self.center radius:_radius-self.LongscaleWidth startAngle:startAngel endAngle:endAngel clockwise:YES];
        perLayer = [CAShapeLayer layer];
        
        perLayer.strokeColor = [UIColor whiteColor].CGColor;
        perLayer.lineWidth = self.LongscaleWidth;
        //添加刻度
        CGPoint point = [self calculateTextPositonWithArcCenter:_center Angle:-endAngel];
        NSString *tickText = [NSString stringWithFormat:@"%ld",index * 2];
        
        //默认label的大小14 * 14
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 5, point.y - 5, 10, 10)];
        text.text = tickText;
        text.backgroundColor = [UIColor redColor];
        text.font = [UIFont systemFontOfSize:15];
        text.textColor = [UIColor whiteColor];
        text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:text];
        
    }else{
        tickPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:_radius-self.ShortscaleWidth startAngle:startAngel endAngle:endAngel clockwise:YES];
        perLayer = [CAShapeLayer layer];
        
        perLayer.strokeColor = [UIColor whiteColor].CGColor;
        perLayer.lineWidth = _ShortscaleWidth;
    }
    
    perLayer.path = tickPath.CGPath;
    [containerLayer addSublayer:perLayer];


}
// 计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel {
    NSLog(@"%f",_radius);
    
    CGFloat x = _radius-_LongscaleWidth-self.LongscaleWidth * cosf(angel);
    CGFloat y = _radius-_LongscaleWidth-self.LongscaleWidth * sinf(angel);
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

#pragma mark - InfoLabe;
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_center.x - 60*KFontmultiple, _center.y- 40*KFontmultiple, 120*KFontmultiple, 30*KFontmultiple)];
        _infoLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.text = @"0";
        _infoLabel.font = [UIFont ToAdapFont:16.f];
    }
    return _infoLabel;
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
