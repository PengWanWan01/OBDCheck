//
//  DashboardView.m
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import "DashboardViewStyleA.h"
#define KMultipleA    self.bounds.size.width/150


@interface DashboardView()
{
    CGPoint _center; // 中心点
    CGFloat _radius; // 外环半径
    NSInteger _dialCount; // 刻度线的个数
    CGFloat _pointerLength; // 指针长度记录
    gradientView *gradientview; //地盘颜色
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
    _center = CGPointMake(ViewWidth/ 2, ViewWidth/ 2);
    _radius = self.bounds.size.width/ 2 ;
    _dialPieceCount  =5;
    _dialCount = 8 * self.dialPieceCount;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewNumber:) name:@"updateNumber"object:nil];
    
    
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (isLandscape) {
        [self setHorizontalFrame];
    }else{
        [self setVerticalFrame];
    }
}
- (void)setHorizontalFrame{
    CustomDashboard* dash = [CustomDashboard findByPK:self.tag];
    int page =  [dash.DashboardAorignx doubleValue]/SCREEN_MIN;
    if (([dash.DashboardAorignx floatValue]-page*SCREEN_MIN)>SCREEN_MIN/2) {
        //横屏时候上边的一排仪表盘
        self.frame = CGRectMake([dash.DashboardAorigny floatValue]+64+page*SCREEN_MAX+15*KFontmultiple, SCREEN_MIN -([dash.DashboardAorignx floatValue]-page*SCREEN_MIN+20*KFontmultiple)-([dash.DashboardAorignheight doubleValue]-30*KFontmultiple), [dash.DashboardAorignwidth doubleValue]-30*KFontmultiple, [dash.DashboardAorignheight doubleValue]-30*KFontmultiple);
        self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
    }else{
        //  //横屏时候下边的一排仪表盘，6P以上的大屏进行特殊适配
        if (IS_IPHONE_6P_OR_MORE) {
            self.frame = CGRectMake([dash.DashboardAorigny floatValue]+64+page*SCREEN_MAX+15*KFontmultiple, SCREEN_MIN -([dash.DashboardAorignx floatValue]-page*SCREEN_MIN+45*KFontmultiple)-([dash.DashboardAorignheight doubleValue]-30*KFontmultiple), [dash.DashboardAorignwidth doubleValue]-30*KFontmultiple, [dash.DashboardAorignheight doubleValue]-30*KFontmultiple);
            self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        }else{
            self.frame = CGRectMake([dash.DashboardAorigny floatValue]+64+page*SCREEN_MAX+15*KFontmultiple, SCREEN_MIN -([dash.DashboardAorignx floatValue]-page*SCREEN_MIN+40*KFontmultiple)-([dash.DashboardAorignheight doubleValue]-30*KFontmultiple), [dash.DashboardAorignwidth doubleValue]-30*KFontmultiple, [dash.DashboardAorignheight doubleValue]-30*KFontmultiple);
            self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        }
    }
    if (page>0) {
        self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }
}
- (void)setVerticalFrame{
    CustomDashboard* dash = [CustomDashboard findByPK:self.tag];
    self.frame =CGRectMake([dash.DashboardAorignx doubleValue], [dash.DashboardAorigny doubleValue], [dash.DashboardAorignwidth doubleValue], [dash.DashboardAorignheight doubleValue]);
    self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    
}

- (void)updateTOFont{
    if ([DashboardSetting sharedInstance].isDashboardFont == YES) {
        [[self superview] bringSubviewToFront:self];
        [DashboardSetting sharedInstance].isDashboardFont = NO;
    }
}
- (void)getNewNumber:(NSNotification *)text{
    DLog(@"得到通知");
    //    DLog(@"%ld",[text.userInfo[@"StyleAViewTag"] integerValue]);
    //    DLog(@"%ld",self.tag);
    NSString *presentStr = [NSString stringWithFormat:@"%@", [text.userInfo objectForKey:@"StyleAViewnumber"]];
    NSString *PreviouStr = [NSString stringWithFormat:@"%@", [text.userInfo objectForKey:@"PreStyleAViewnumber"]];
    
    CGFloat start = [PreviouStr doubleValue];
    CGFloat end = [presentStr doubleValue];
    //    DLog(@"%@%@%ld",PreviouStr,presentStr,(long)[text.userInfo[@"StyleAViewTag"] integerValue]);
    
    if ([text.userInfo[@"StyleAViewTag"] integerValue] == self.tag) {
        CustomDashboard *dashboard  = [CustomDashboard findByPK:self.tag];
        CGFloat Space =   ([dashboard.DashboardAendAngle doubleValue]- [dashboard.DashboardAStartAngle doubleValue])/([dashboard.DashboardmaxNumber doubleValue] - [dashboard.DashboardminNumber doubleValue]);
        [self rotationWithStartAngle:[dashboard.DashboardAStartAngle doubleValue] + ((double)start/[dashboard.DashboardmaxNumber doubleValue]*Space)  WithEndAngle:[dashboard.DashboardAStartAngle doubleValue] + (double)end/[dashboard.DashboardmaxNumber doubleValue]*Space];
        self.numberLabel.text = presentStr;
    }
    
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
//[ColorTools colorWithHexString:@"18191C"].CGColor
- (void)addGradientView:(NSString *)gradientColor GradientViewWidth:(CGFloat)gradientViewWidth{
    gradientview = [[gradientView alloc]initWithFrame:CGRectMake(0, 0, gradientViewWidth, gradientViewWidth)];
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
- (void)initWithModel:(CustomDashboard *)model{
    
    
    //       DLog(@"innerColor%@",model);
    [self addCircleLayer:[model.DashboardAringWidth doubleValue] withInnerColor:model.DashboardAinnerColor];
    
    CGFloat perAngle = ([model.DashboardAendAngle floatValue]  - [model.DashboardAStartAngle floatValue])  / _dialCount;
    
    if (perAngle< 0) {
        perAngle=    -([model.DashboardAendAngle floatValue] - [model.DashboardAStartAngle floatValue] )/_dialCount;
    }else
    {
        perAngle = ([model.DashboardAendAngle floatValue] - [model.DashboardAStartAngle floatValue])  / _dialCount;
    }
    
    
    for (int i = 0; i<= _dialCount; i++) {
        CGFloat startAngel = (- M_PI + perAngle * i+[model.DashboardAStartAngle floatValue]);
        CGFloat endAngel = startAngel + perAngle/([model.DashboardAmiWidth doubleValue]);
        //    _center = CGPointMake([model.DashboardAorignwidth doubleValue]/2, [model.DashboardAorignwidth doubleValue]/2);
        if (i % 5 == 0) {
            CGFloat endAngel = startAngel + perAngle/[model.DashboardAmaWidth doubleValue];
            UIBezierPath *LongtickPath    =   [UIBezierPath bezierPathWithArcCenter:_center radius:(_radius-[model.DashboardAringWidth doubleValue]*KMultipleA- [model.DashboardAmiLength doubleValue]*KMultipleA) startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *LongperLayer    = [CAShapeLayer layer];
            
            LongperLayer.strokeColor = [ColorTools colorWithHexString:model.DashboardAmaColor].CGColor;
            LongperLayer.lineWidth = [model.DashboardAmaLength doubleValue]*KMultipleA;
            //添加刻度
            //            DLog(@"%@",model.DashboardAorignwidth);
            
            CGPoint point = [self calculateTextPositonWithArcCenter:_center Angle:-endAngel radius:(_radius-[model.DashboardAringWidth doubleValue]*KMultipleA- [model.DashboardAmaLength doubleValue]*KMultipleA- 6*KMultipleA)*[model.DashboardALabelOffest doubleValue] Rotate:model.DashboardALabelRotate];
            //四舍五入
            NSString *tickText = [NSString stringWithFormat:@"%.f",((roundf([model.DashboardmaxNumber doubleValue]- [model.DashboardminNumber doubleValue])/8)*(i/5) +[model.DashboardminNumber doubleValue])];
            
            //默认label的大小14 * 14
            //            DLog(@"%f",_center.x);
            //            DLog(@"point%f%f",point.x,point.y);
            //            if (point.x [is nan]) {
            //
            //            }
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(((point.x - 10*KMultipleA)), ((point.y - 10*KMultipleA)), floor(20*KMultipleA),  floor(20*KMultipleA))];
            text.backgroundColor = [ColorTools colorWithHexString:model.DashboardAinnerColor];
            text.text = tickText;
            text.font = [UIFont systemFontOfSize:[model.DashboardALabelFontScale doubleValue]*10.f*KMultipleA];
            text.textColor = [UIColor whiteColor];
            text.textAlignment = NSTextAlignmentCenter;
            
            //让文字刻度显示
            if (model.DashboardALabelVisble == YES) {
                [self addSubview:text];
            }else{
                
            }
            
            //让文字显示的形式，是正的还是斜的
            if (model.DashboardALabelRotate == YES) {
                
            }else{
                
            }
            LongperLayer.path = LongtickPath.CGPath;
            [self.layer addSublayer:LongperLayer];
            
        }else{
            UIBezierPath *tickPath  = [UIBezierPath bezierPathWithArcCenter:_center radius:(_radius-[model.DashboardAringWidth doubleValue]*KMultipleA) startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *perLayer = [CAShapeLayer layer];
            
            perLayer.strokeColor = [ColorTools colorWithHexString:model.DashboardAmiColor].CGColor;
            perLayer.lineWidth = [model.DashboardAmiLength doubleValue]*KMultipleA;
            perLayer.path = tickPath.CGPath;
            [self.layer addSublayer:perLayer];
        }
        
        
    }
    
    [self adddrawPointerVisble:model.DashboardAPointerVisble PointerWidth:[model.DashboardAPointerWidth  doubleValue] PointerLength:[model.DashboardAPointerLength  doubleValue] PointerColor:model.DashboardAPointerColor KNOBRadius:[model.DashboardAKNOBRadius doubleValue] KNOBColor:model.DashboardAKNOBColor withStartAngle:[model.DashboardAStartAngle floatValue]  withModel:(CustomDashboard *)model];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_center.x - 60*KMultipleA, (_center.y- 40*KMultipleA)*[model.DashboardAtitlePosition doubleValue], 120*KMultipleA, 30*KMultipleA)];
    self.infoLabel.text = model.DashboardPID;
    self.infoLabel.textColor = [ColorTools colorWithHexString:model.DashboardAtitleColor];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.font = [UIFont systemFontOfSize:20.f*KMultipleA];
    self.infoLabel.adjustsFontSizeToFitWidth = YES;

    [self addSubview:self.infoLabel];
    
    self.unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(((self.bounds.size.width/2) - 20*KMultipleA)*[model.DashboardAUnitHorizontalPosition doubleValue], ((self.bounds.size.width/2)+ 10*KMultipleA)*[model.DashboardAUnitVerticalPosition doubleValue], 40*KMultipleA, 20*KMultipleA)];
    self.unitLabel.text = @"F";
    self.unitLabel.font = [UIFont ToAdapFont:[model.DashboardAUnitFontScale doubleValue]*16.f*KMultipleA];
    self.unitLabel.textColor = [ColorTools colorWithHexString:model.DashboardAUnitColor];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.unitLabel];
    [self addSubview:self.unitLabel];
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.bounds.size.width + 5), self.bounds.size.width, 20*KMultipleA)];
    self.numberLabel.font = [UIFont boldSystemFontOfSize:[model.DashboardAValueFontScale doubleValue]*17];
    self.numberLabel.textColor = [ColorTools colorWithHexString: model.DashboardAValueColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"N/A";
    
    if (model.DashboardAValueVisble==YES) {
        [self addSubview:self.numberLabel];
    }else{
        
    }
    
    [self addDrawFillstartAngle:[model.DashboardAFillstartAngle doubleValue] FillendAngle:[model.DashboardAFillEndAngle doubleValue] FillColor:model.DashboardAFillColor withRingWidth:[model.DashboardAringWidth doubleValue] withModel:(CustomDashboard *)model];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:LongPress];
    
    if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardCustomMode ) {
        UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [self addGestureRecognizer:pinchGR];
    }
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
- (void)adddrawPointerVisble:(BOOL)pointerVisble PointerWidth:(CGFloat)pointerWidth PointerLength:(CGFloat)pointerLength PointerColor:(NSString *)pointerColor KNOBRadius:(CGFloat)kNOBRadius KNOBColor:(NSString *)kNOBColor withStartAngle:(CGFloat )TheAngle withModel:(CustomDashboard *)model{
    
    
    _triangleView= [[UIView alloc]initWithFrame:CGRectMake(((self.bounds.size.width/2) - (pointerWidth/2)*KMultipleA), (self.bounds.size.width/2), pointerWidth*KMultipleA,((self.bounds.size.width/2)-20*KMultipleA)*pointerLength)];
    CGPoint oldOrigin = _triangleView.frame.origin;
    //设置triangleView的角度与开始位置一直
    _triangleView.layer.anchorPoint = CGPointMake(0.5, 0);
    CGPoint newOrigin = _triangleView.layer.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    _triangleView.center = CGPointMake (_triangleView.center.x - transition.x, _triangleView.center.y - transition.y);
    
    _triangleView.transform = CGAffineTransformMakeRotation(TheAngle+M_PI/2);
    //    _triangleView.backgroundColor = [UIColor redColor];
    [self addSubview:_triangleView];
    // 线的路径 三角形
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    
    // 这些点的位置都是相对于所在视图的
    // 起点
    [polygonPath moveToPoint:CGPointMake((pointerWidth/2)*KMultipleA,((self.bounds.size.width/2)-20*KMultipleA)*pointerLength)];
    // 其他点
    [polygonPath addLineToPoint:CGPointMake(0, 0)];
    [polygonPath addLineToPoint:CGPointMake(pointerWidth*KMultipleA, 0)];
    
    [polygonPath closePath]; // 添加一个结尾点和起点相同
    
    CAShapeLayer *polygonLayer = [CAShapeLayer layer];
    polygonLayer.lineWidth = 1;
    
    polygonLayer.strokeColor = [ColorTools colorWithHexString:pointerColor].CGColor;
    polygonLayer.path = polygonPath.CGPath;
    polygonLayer.fillColor = [ColorTools colorWithHexString:pointerColor].CGColor; //
    if (model.DashboardAPointerVisble == YES) {
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
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:kNOBRadius*KMultipleA startAngle:startAngle endAngle:endAngle clockwise:clockwise];
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
- (void)addDrawFillstartAngle:(CGFloat)startAngle FillendAngle:(CGFloat)endAngle FillColor:(NSString *)fillColor withRingWidth:(CGFloat)RingWidth withModel:(CustomDashboard *)model{
    
    BOOL clockwise = YES; // 顺时针
    //    CALayer *containerLayer = [CALayer layer];
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = RingWidth*KMultipleA;
    circleLayer.lineCap = kCALineCapSquare;
    circleLayer.lineJoin = kCALineJoinMiter;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [ColorTools colorWithHexString:fillColor].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius*KMultipleA startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    if (model.DashboardAFillenabled == YES) {
        [self.layer addSublayer:circleLayer];
    }else{
        
    }
}
#pragma mark - PointerView
- (UIImageView *)pointerView {
    if (!_pointerView) {
        _pointerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"指针"]];
        _pointerView.frame =  CGRectMake(_center.x - 10*KMultipleA, _center.y - self.bounds.size.width/6, 20*KMultipleA, self.bounds.size.width/3);
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
        //          DLog(@"curP====%@",NSStringFromCGPoint(curP));
        //          DLog(@"preP====%@",NSStringFromCGPoint(preP));
        //
        CGFloat offsetX = curP.x - preP.x;
        CGFloat offsetY = curP.y - preP.y;
        
        //平移
        self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    }
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([DashboardSetting sharedInstance].isDashboardMove == YES  && [DashboardSetting sharedInstance].Dashboardindex == self.tag) {
        
        if ([self.delegate respondsToSelector:@selector(touchMoveWithcenterX:WithcenterY:)]) {
            //               DLog(@"origin%f,%f",self.frame.origin.x,self.frame.origin.y );
            [self.delegate touchMoveWithcenterX:self.frame.origin.x WithcenterY:self.frame.origin.y];
            //移动view
        }
    }
    
    
    
}

@end

