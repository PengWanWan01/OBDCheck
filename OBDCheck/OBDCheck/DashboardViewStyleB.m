//
//  DashboardViewStyleB.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardViewStyleB.h"

@implementation DashboardViewStyleB

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加仪表盘的底盘
        self.image = [UIImage imageNamed:@"Dashboard"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        //添加渐变色
        gradientView *view = [[gradientView alloc]initWithFrame:self.bounds];
        view.gradientColor = [ColorTools colorWithHexString:@"00a6ff"];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        //添加仪表盘中间的内容
        [self addmiddle ];
        //添加仪表盘 底部的内容
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - (100.0/300)*self.frame.size.width, self.bounds.size.width -(73.0/300)*self.frame.size.width , (200.0/300)*self.frame.size.width,  (70.0/300)*self.frame.size.width)];
        image2.image = [UIImage imageNamed:@"yuanhu"];
        image2.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:image2];
        //添加进度条
        [self draw:self.bounds.size.width/2 - (23.0/300)*self.frame.size.width lineWidth:(12.0/300)*self.frame.size.width lineColor:[ColorTools colorWithHexString:@"1d2027"] startAngle:(M_PI / 4) +(M_PI/18) endAngle: M_PI *3/4-M_PI/18];
        [self draw:self.bounds.size.width/2 - (23.0/300)*self.frame.size.width lineWidth:(12.0/300)*self.frame.size.width lineColor:[ColorTools colorWithHexString:@"00a6ff"] startAngle:(M_PI / 2) endAngle: M_PI *3/4-M_PI/18];
        
    }
    return self;
}
- (void)addmiddle{
    UIImageView *innerimage = [[UIImageView alloc]initWithFrame:CGRectMake((43.0/300)*self.frame.size.width, (43.0/300)*self.frame.size.width, self.bounds.size.width - (86.0/300)*self.frame.size.width,  self.bounds.size.width - (86.0/300)*self.frame.size.width)];
    innerimage.image = [UIImage imageNamed:@"circle-top"];
    innerimage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:innerimage];
    
    _NumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,innerimage.bounds.size.width/2 - (25.0/300)*self.frame.size.width , innerimage.bounds.size.width, (50.0/300)*self.frame.size.width)];
    _NumberLabel.font = [UIFont boldSystemFontOfSize:(56.0/300)*self.frame.size.width];
    _NumberLabel.textColor = [ColorTools colorWithHexString:@"#FFFFFF"];
    _NumberLabel.textAlignment = NSTextAlignmentCenter;
    _NumberLabel.text = @"2500";
    [innerimage addSubview:_NumberLabel];
    
    _PIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, innerimage.bounds.size.width, 30)];
    _PIDLabel.font = [UIFont boldSystemFontOfSize:(24.0/300)*self.frame.size.width];
    _PIDLabel.textColor = [ColorTools colorWithHexString:@"#757476"];
    _PIDLabel.textAlignment = NSTextAlignmentCenter;
    _PIDLabel.text = @"MPH";
    [innerimage addSubview:_PIDLabel];
    
    
    
    _UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_NumberLabel.frame) + 10, innerimage.bounds.size.width, (24.0/300)*self.frame.size.width)];
    _UnitLabel.font = [UIFont boldSystemFontOfSize:17];
    _UnitLabel.textColor =  [ColorTools colorWithHexString:@"#757476"];
    _UnitLabel.textAlignment = NSTextAlignmentCenter;
    _UnitLabel.text = @"R/MIN";
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
