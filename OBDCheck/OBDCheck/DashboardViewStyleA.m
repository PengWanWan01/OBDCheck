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
    CGFloat _pointerLength; // 指针长度记录
    
}
@end

@implementation DashboardView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor clearColor];
   
    self.userInteractionEnabled = YES;
    _center = CGPointMake(ViewWidth / 2, ViewWidth / 2);
    _radius = ViewWidth/ 2 ;
    _dialPieceCount  =5;
    _dialCount = 8 * self.dialPieceCount;
    // 添加外环
    self.infoLabeltext = self.infoLabel.text;
    //注册通知
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewNumber:) name:@"updateNumber"object:nil];

     
    return self;
}
- (void)setNeedsDisplay{
    [super setNeedsDisplay];
    
    
}
- (void)updateTOFont{
    if ([DashboardSetting sharedInstance].isDashboardFont == YES) {
        [[self superview] bringSubviewToFront:self];
        [DashboardSetting sharedInstance].isDashboardFont = NO;
    }
}
- (void)getNewNumber:(NSNotification *)text{
    NSString *presentStr = [NSString stringWithFormat:@"%@", [text.userInfo objectForKey:@"StyleAViewnumber"]];
    NSString *PreviouStr = [NSString stringWithFormat:@"%@", [text.userInfo objectForKey:@"PreStyleAViewnumber"]];
    
    CGFloat start = [PreviouStr doubleValue];
    CGFloat end = [presentStr doubleValue];
    if ([text.userInfo[@"StyleAViewTag"] doubleValue] == self.tag) {
    
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: self.tag]];
        switch ([ DashboardSetting sharedInstance].dashboardMode) {
            case DashboardCustomMode:
            {
                NSArray* pAll = [CustomDashboard findByCriteria:findsql];
                for(CustomDashboard* dashboard in pAll){
                    CGFloat Space =   ([dashboard.dashboardA.endAngle doubleValue]- [dashboard.dashboardA.StartAngle doubleValue])/([dashboard.dashboardA.maxNumber doubleValue] - [dashboard.dashboardA.minNumber doubleValue]);
                    [self rotationWithStartAngle:[dashboard.dashboardA.StartAngle doubleValue] + start*Space  WithEndAngle:[dashboard.dashboardA.StartAngle doubleValue] + end*Space];
                    self.numberLabel.text = presentStr;
                }
            }
                break;
            case DashboardClassicMode:
            {
                NSArray* pAll = [DashboardA findByCriteria:findsql];
                for(DashboardA* dashboard in pAll){
                    CGFloat Space =   ([dashboard.endAngle doubleValue]- [dashboard.StartAngle doubleValue])/([dashboard.maxNumber doubleValue] - [dashboard.minNumber doubleValue]);
                    [self rotationWithStartAngle:[dashboard.StartAngle doubleValue] + start*Space  WithEndAngle:[dashboard.StartAngle doubleValue] + end*Space];
                     self.numberLabel.text = presentStr;
                }
            }
                break;
            default:
                break;
        }
   
                   
      
    }

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self];
    


}
//[ColorTools colorWithHexString:@"18191C"].CGColor
- (void)addGradientView:(NSString *)gradientColor GradientViewWidth:(CGFloat)gradientViewWidth{
    gradientView *gradientview = [[gradientView alloc]initWithFrame:CGRectMake(0, 0, gradientViewWidth, gradientViewWidth)];
    gradientview.gradientRadius = gradientViewWidth/2;
    gradientview.startGradientColor =   [UIColor clearColor];
    gradientview.endGradientColor =  [ColorTools colorWithHexString:gradientColor];
    [self addSubview:gradientview];
    

}
#pragma mark 画圆
- (void)addCircleLayer:(CGFloat)RingWidth withInnerColor:(NSString *)color {
    CGFloat startAngle = 0; // 开始角度
    CGFloat endAngle = 2*M_PI; // 结束角度
    BOOL clockwise = YES; // 顺时针
//    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 0;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.fillColor = [ColorTools colorWithHexString:color].CGColor;
    circleLayer.strokeColor = [ColorTools colorWithHexString:color].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius-RingWidth startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    [self.layer addSublayer:circleLayer];
   
   
}
// 画刻度
- (void)initWithModel:(DashboardA *)model{


//       NSLog(@"innerColor%@",model);
//    NSLog(@"innerColor%@%@",model,model.innerColor);
     [self addCircleLayer:[model.ringWidth doubleValue] withInnerColor:model.innerColor];
    
    [self adddrawPointerVisble:model.PointerVisble PointerWidth:[model.PointerWidth  doubleValue] PointerLength:[model.PointerLength  doubleValue] PointerColor:model.PointerColor KNOBRadius:[model.KNOBRadius doubleValue] KNOBColor:model.KNOBColor withStartAngle:[model.StartAngle doubleValue] withModel:(DashboardA *)model];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_center.x - 60*KFontmultiple, (_center.y- 40*KFontmultiple)*[model.titlePosition doubleValue], 120*KFontmultiple, 30*KFontmultiple)];
    self.infoLabel.textColor = [ColorTools colorWithHexString:model.titleColor];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.font = [UIFont ToAdapFont:[model.titleFontScale doubleValue]*16.f];
    [self addSubview:self.infoLabel];
    
    self.unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(((ViewWidth/2) - 20*KFontmultiple)*[model.UnitHorizontalPosition doubleValue], ((ViewWidth/2)+ 10)*[model.UnitVerticalPosition doubleValue], 40*KFontmultiple, 20*KFontmultiple)];
    self.unitLabel.text = @"F";
    self.unitLabel.font = [UIFont ToAdapFont:[model.UnitFontScale doubleValue]*16.f];
    self.unitLabel.textColor = [ColorTools colorWithHexString:model.UnitColor];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.unitLabel];
    [self addSubview:self.unitLabel];
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake((ViewWidth/3)*[model.ValuePosition doubleValue], ViewWidth + 5, ViewWidth/3, 20)];
   
    self.numberLabel.font = [UIFont boldSystemFontOfSize:[model.ValueFontScale doubleValue]*17];
    self.numberLabel.textColor = [ColorTools colorWithHexString: model.ValueColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"N/A";
   
    if (model.ValueVisble==YES) {
         [self addSubview:self.numberLabel];
    }else{
    }

    
    CGFloat perAngle = ([model.endAngle doubleValue] - [model.StartAngle doubleValue])  / _dialCount;
    
    if (perAngle< 0) {
     perAngle=    -([model.endAngle doubleValue] - [model.StartAngle doubleValue])/_dialCount;
    }else
    {
    perAngle = ([model.endAngle doubleValue] - [model.StartAngle doubleValue])  / _dialCount;
    }
   
   
    for (int i = 0; i<= _dialCount; i++) {
        CGFloat startAngel = (- M_PI + perAngle * i+[model.StartAngle doubleValue]);
        CGFloat endAngel = startAngel + perAngle/[model.miWidth doubleValue];
  
        if (i % 5 == 0) {
            CGFloat endAngel = startAngel + perAngle/[model.maWidth doubleValue];

         UIBezierPath *LongtickPath    =   [UIBezierPath bezierPathWithArcCenter:_center radius:_radius-[model.ringWidth doubleValue]- [model.miLength doubleValue] startAngle:startAngel endAngle:endAngel clockwise:YES];
         CAShapeLayer *LongperLayer    = [CAShapeLayer layer];
            
            LongperLayer.strokeColor = [ColorTools colorWithHexString:model.maColor].CGColor;
            LongperLayer.lineWidth = [model.maLength doubleValue];
            //添加刻度
            NSLog(@"%@",model.orignwidth);
            
             _center = CGPointMake([model.orignwidth doubleValue]/2, [model.orignwidth doubleValue]/2);
            
            CGPoint point = [self calculateTextPositonWithArcCenter:_center Angle:-endAngel radius:(_radius-[model.ringWidth doubleValue]- [model.maLength doubleValue]- 5)*[model.LabelOffest doubleValue] Rotate:model.LabelRotate];
            //四舍五入
            NSString *tickText = [NSString stringWithFormat:@"%.f",((roundf([model.maxNumber doubleValue]- [model.minNumber doubleValue])/8)*(i/5) +[model.minNumber doubleValue])];
            
            //默认label的大小14 * 14
            NSLog(@"%f",_center.x);
            NSLog(@"point%f%f",point.x,point.y);
          
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake((point.x - 15), (point.y - 15), 30, 30)];
            
            text.text = tickText;
            text.font = [UIFont systemFontOfSize:[model.LabelFontScale doubleValue]*10.f];
            text.textColor = [UIColor whiteColor];
            text.textAlignment = NSTextAlignmentCenter;
            
            LongperLayer.path = LongtickPath.CGPath;
            [self.layer addSublayer:LongperLayer];
            //让文字刻度显示
            if (model.LabelVisble == YES) {
                [self addSubview:text];
            }else{
               
            }
            
            //让文字显示的形式，是正的还是斜的
            if (model.LabelRotate == YES) {
                
            }else{
            
            }
            
        }else{
            UIBezierPath *tickPath  = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius-[model.ringWidth doubleValue] startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *perLayer = [CAShapeLayer layer];
            
            perLayer.strokeColor = [ColorTools colorWithHexString:model.miColor].CGColor;
            perLayer.lineWidth = [model.miLength doubleValue];
            perLayer.path = tickPath.CGPath;
            [self.layer addSublayer:perLayer];
        }
        
        
    }
    [self addDrawFillstartAngle:[model.FillstartAngle doubleValue] FillendAngle:[model.FillEndAngle doubleValue] FillColor:model.FillColor withRingWidth:[model.ringWidth doubleValue] withModel:(DashboardA *)model];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:LongPress];
    if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
    UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinchGR];
    }
    [self setNeedsDisplay];
    

}
#pragma mark 捏合手势
- (void)pinchAction:(UIPinchGestureRecognizer*)recognizer{
    
    if (recognizer.state==UIGestureRecognizerStateBegan || recognizer.state==UIGestureRecognizerStateChanged)
        
    {
        
//        UIView *view=[recognizer view];
        
        //扩大、缩小倍数
        
        self.transform=CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
        
        recognizer.scale=1;
        if ([self.delegate respondsToSelector:@selector(pinchtap:OrignX:OrignY:Width:Height:)]) {
            [self.delegate pinchtap:recognizer OrignX:self.frame.origin.x OrignY:self.frame.origin.y Width:self.frame.size.width Height:self.frame.size.height];
        }
    }
    
}
#pragma mark 长按手势
-(void)tap:(UILongPressGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(tap:)]) {
        [self.delegate tap:sender];
    }
}
#pragma mark // 计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel radius:(CGFloat)Theradius Rotate:(BOOL)labelRotate{    
    CGFloat x = (Theradius) * cosf(angel);
    CGFloat y = (Theradius) * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}

- (void)drawRect:(CGRect)rect {
   
}
#pragma mark 画指针 圆与三角形
- (void)adddrawPointerVisble:(BOOL)pointerVisble PointerWidth:(CGFloat)pointerWidth PointerLength:(CGFloat)pointerLength PointerColor:(NSString *)pointerColor KNOBRadius:(CGFloat)kNOBRadius KNOBColor:(NSString *)kNOBColor withStartAngle:(CGFloat )TheAngle withModel:(DashboardA *)model{

    
    _triangleView= [[UIView alloc]initWithFrame:CGRectMake(((ViewWidth/2) - (pointerWidth/2)), (ViewWidth/2), pointerWidth,pointerLength)];
    CGPoint oldOrigin = _triangleView.frame.origin;
    //设置triangleView的角度与开始位置一直
    _triangleView.layer.anchorPoint = CGPointMake(0.5, 0);
    CGPoint newOrigin = _triangleView.layer.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    _triangleView.center = CGPointMake (_triangleView.center.x - transition.x, _triangleView.center.y - transition.y);

    _triangleView.transform = CGAffineTransformMakeRotation(TheAngle+M_PI/2);
    [self addSubview:_triangleView];
    // 线的路径 三角形
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    
    // 这些点的位置都是相对于所在视图的
    // 起点
    [polygonPath moveToPoint:CGPointMake(pointerWidth/2,pointerLength)];
    // 其他点
    [polygonPath addLineToPoint:CGPointMake(0, 0)];
    [polygonPath addLineToPoint:CGPointMake(pointerWidth, 0)];
    
    [polygonPath closePath]; // 添加一个结尾点和起点相同
    
    CAShapeLayer *polygonLayer = [CAShapeLayer layer];
    polygonLayer.lineWidth = 2;
    
    polygonLayer.strokeColor = [ColorTools colorWithHexString:pointerColor].CGColor;
    polygonLayer.path = polygonPath.CGPath;
    polygonLayer.fillColor = [ColorTools colorWithHexString:pointerColor].CGColor; //
    if (model.PointerVisble == YES) {
            [_triangleView.layer addSublayer:polygonLayer];
    }else{
    
    }
    //画圆
    CGFloat startAngle = 0; // 开始角度
    CGFloat endAngle = 2*M_PI; // 结束角度
    BOOL clockwise = YES; // 顺时针
    //    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 0;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.fillColor = [ColorTools colorWithHexString:kNOBColor].CGColor;
    circleLayer.strokeColor = [ColorTools colorWithHexString:kNOBColor].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:kNOBRadius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    [self.layer addSublayer:circleLayer];
}
#pragma mark 指针旋转角度
- (void)rotationWithStartAngle:(CGFloat)StartAngle WithEndAngle:(CGFloat)endAngle{
    CGPoint oldOrigin = _triangleView.frame.origin;
    _triangleView.layer.anchorPoint = CGPointMake(0.5, 0);
    CGPoint newOrigin = _triangleView.layer.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    _triangleView.center = CGPointMake (_triangleView.center.x - transition.x, _triangleView.center.y - transition.y);
    //    aaView.transform = CGAffineTransformMakeRotation(M_PI * 0.15 );
    CABasicAnimation *animation = [CABasicAnimation new];
    // 设置动画要改变的属性
    animation.keyPath = @"transform.rotation.z";
    animation.fromValue = @(StartAngle+M_PI/2);
    // 动画的最终属性的值（）
    animation.toValue = @(endAngle+M_PI/2);
    // 动画的播放时间
    animation.duration = 1;
    // 动画效果慢进慢出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 解决动画结束后回到原始状态的问题
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 将动画添加到视图bgImgV的layer上
    [_triangleView.layer addAnimation:animation forKey:@"rotation"];
    
    
}
- (void)addDrawFillstartAngle:(CGFloat)startAngle FillendAngle:(CGFloat)endAngle FillColor:(NSString *)fillColor withRingWidth:(CGFloat)RingWidth withModel:(DashboardA *)model{
   
    BOOL clockwise = YES; // 顺时针
    //    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = RingWidth;
    circleLayer.lineCap = kCALineCapSquare;
    circleLayer.lineJoin = kCALineJoinMiter;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [ColorTools colorWithHexString:fillColor].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
     if (model.Fillenabled == YES) {
           [self.layer addSublayer:circleLayer];
    }else{
        
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

#pragma mark 开始点击
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    //保存触摸起始点位置
    if ([DashboardSetting sharedInstance].isDashboardMove == YES && [DashboardSetting sharedInstance].Dashboardindex == self.tag) {

    
   
    }
   
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    //计算位移=当前位置-起始位置
      if ([DashboardSetting sharedInstance].isDashboardMove == YES  && [DashboardSetting sharedInstance].Dashboardindex == self.tag) {
          //做UIView拖拽
          UITouch *touch = [touches anyObject];
          
          
          //求偏移量 = 手指当前点的X - 手指上一个点的X
          CGPoint curP = [touch locationInView:self];
          CGPoint preP = [touch previousLocationInView:self];
          NSLog(@"curP====%@",NSStringFromCGPoint(curP));
          NSLog(@"preP====%@",NSStringFromCGPoint(preP));
          
          CGFloat offsetX = curP.x - preP.x;
          CGFloat offsetY = curP.y - preP.y;
          
          //平移
          self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
      }
   
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
      if ([DashboardSetting sharedInstance].isDashboardMove == YES  && [DashboardSetting sharedInstance].Dashboardindex == self.tag) {
      
          if ([self.delegate respondsToSelector:@selector(touchMoveWithcenterX:WithcenterY:)]) {
               NSLog(@"origin%f,%f",self.frame.origin.x,self.frame.origin.y );
              [self.delegate touchMoveWithcenterX:self.frame.origin.x WithcenterY:self.frame.origin.y];
              //移动view
          }
  }
    
    
    
}

@end
