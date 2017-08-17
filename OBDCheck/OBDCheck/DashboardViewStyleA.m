//
//  DashboardView.m
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import "DashboardViewStyleA.h"
#define KMultipleA   ViewWidth/150
static CGFloat kDefaultRingWidth = 10;
static CGFloat kDefaultDialLength = 5;
static CGFloat kDefaultDialPieceCount = 5;

@interface DashboardView()
{
    CGPoint _center; // 中心点
    CGFloat _radius; // 外环半径
    NSInteger _dialCount; // 刻度线的个数
}
@end

@implementation DashboardView

- (CGFloat)ringWidth {
    return _ringWidth ? _ringWidth : kDefaultRingWidth;
}

- (CGFloat)dialLength {
    return _dialLength ? _dialLength : kDefaultDialLength;
}

- (NSInteger)dialPieceCount {
    return _dialPieceCount ? _dialPieceCount : kDefaultDialPieceCount;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [ColorTools colorWithHexString:@"18191C"];
    self.layer.cornerRadius = ViewWidth / 2;
    self.layer.masksToBounds = YES;
    
    _center = CGPointMake(ViewWidth / 2, ViewWidth / 2);
    _radius = ViewWidth/ 2 - self.ringWidth / 2;
    _dialCount = 8 * self.dialPieceCount;
    // 添加外环
    [self addCircleLayer];
    [self addSubview:self.pointerView];
    [self addSubview:self.infoLabel];

    return self;
}

- (void)addCircleLayer {
    CGFloat startAngle = 0; // 开始角度
    CGFloat endAngle = 2*M_PI; // 结束角度
    BOOL clockwise = YES; // 顺时针
    
    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = self.ringWidth;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
//    circleLayer.strokeColor = [UIColor redColor].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    [containerLayer addSublayer:circleLayer];
    for (int i = 0; i <= _dialCount; i++) {
        [self containerLayer:containerLayer addDialWithIndex:i]; // 添加刻度
    }
    [self.layer addSublayer:containerLayer];
   
}

- (void)containerLayer:(CALayer *)containerLayer addDialWithIndex:(NSInteger)index {
    CAShapeLayer *dialItemLayer = [CAShapeLayer layer]; // 刻度层
    dialItemLayer.lineWidth = 1;
    dialItemLayer.lineCap = kCALineCapSquare;
    dialItemLayer.lineJoin = kCALineJoinRound;
    dialItemLayer.strokeColor = [UIColor whiteColor].CGColor;
    dialItemLayer.fillColor = [UIColor whiteColor].CGColor;
    
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat outsideRadius = _radius - self.ringWidth / 2; // 刻度 外点半径
    CGFloat insideRadius = outsideRadius - self.dialLength; // 刻度 内点半径
    
    if (index % self.dialPieceCount == 0) {
        dialItemLayer.strokeColor = [UIColor whiteColor].CGColor;
        insideRadius -= 5;
    }
    
    CGFloat angle = M_PI_2 + M_PI / 4 - index * (M_PI_2 + M_PI/2) *2 / _dialCount;// 角度
    CGPoint insidePoint = CGPointMake(_center.x - (insideRadius * sin(angle)), _center.y - (insideRadius * cos(angle)));// 刻度内点
    CGPoint outsidePoint = CGPointMake(_center.x - (outsideRadius * sin(angle)), _center.y - (outsideRadius * cos(angle)));// 刻度外点
    
    [path moveToPoint:insidePoint];
    [path addLineToPoint:outsidePoint];
    
    dialItemLayer.path = path.CGPath;
    [containerLayer addSublayer:dialItemLayer];
}

// 绘制文字
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.5);
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    UIColor *foregroundColor = [UIColor whiteColor];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: foregroundColor};
    
    CGFloat outsideRadius = _radius - self.ringWidth/2;// 刻度外点半径
    CGFloat insideRadius = outsideRadius - self.dialLength; // 刻度内点半径
    
    // 需要显示的文字数组
    NSArray *textArr = @[@"0", @"20", @"40",@"60", @"80", @"100", @"120", @"140"];
    
    // 计算所得各个文字显示的位置相对于其insidePoint的偏移量,
    NSArray *xOffsetArr = @[@(-5),@(10), @(7), @(5), @(-10), @(-30), @(-35), @(-30)];
    NSArray *yOffsetArr = @[@(-25),@(-20), @(-10), @(0), @(5), @(0), @(-10), @(-20)];
    
    for (int i = 0; i < textArr.count; i++) {
        CGFloat angle =  M_PI_2 + M_PI / 2 - 5 * i * (M_PI_2 + M_PI/2) *2 / _dialCount;
        CGPoint insidePoint = CGPointMake(_center.x - (insideRadius * sin(angle)), _center.y - (insideRadius * cos(angle)));
        CGFloat xOffset = [xOffsetArr[i] floatValue];
        CGFloat yOffset = [yOffsetArr[i] floatValue];
        CGRect rect = CGRectMake(insidePoint.x + xOffset, insidePoint.y + yOffset, 60, 20);
        NSString *text = textArr[i];
        [text drawInRect:rect withAttributes:attributes];
    }
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
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_center.x - 60, _center.y- 40, 120, 30)];
        _infoLabel.font = [UIFont boldSystemFontOfSize:17*KMultipleA];
        _infoLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.text = @"0";
    }
    return _infoLabel;
}
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
@end
