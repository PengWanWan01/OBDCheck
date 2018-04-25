//
//  DashboardViewStyleB.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardViewStyleB.h"
#define KMultipleB  self.bounds.size.width/300
@interface DashboardViewStyleB()
{
    CGPoint _center; // 中心点
    gradientView *view;
    //添加仪表盘 底部的内容
    UIImageView *image2;
    UIImageView *innerimage;
    CALayer *containerLayer;
    CAShapeLayer *circleLayer;
    UIBezierPath *polygonPath;
    CAShapeLayer *polygonLayer;
    CAShapeLayer *lineLayer;
}
@end
@implementation DashboardViewStyleB

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //添加仪表盘的底盘
        self.image = [UIImage imageNamed:@"Dashboard"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        _center = CGPointMake(ViewWidth / 2, ViewWidth / 2);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewNumber:) name:@"StyleBupdateNumber"object:nil];
        
        
    }
    return self;
}

-(void)layoutFrames{
    if (isLandscape) {
        //        DLog(@"视图横屏");
        [self setHorizontalFrame];
    }else{
        //        DLog(@"视图竖屏");
        [self setVerticalFrame];
    }
    
    
}
- (void)setHorizontalFrame{
    CustomDashboard *dash = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:self.tag].lastObject;

    int page =  [dash.Dashboardorignx doubleValue]/SCREEN_MIN;
    if (page == 0) {
        if (([dash.Dashboardorignx floatValue]-page*SCREEN_MIN)>SCREEN_MIN/2) {
            //横屏时候上边的一排仪表盘
            self.frame = CGRectMake([dash.Dashboardorigny floatValue]+55+page*SCREEN_MAX+15*KFontmultiple, SCREEN_MIN -([dash.Dashboardorignx floatValue]-page*SCREEN_MIN+10*KFontmultiple)-([dash.Dashboardorignheight doubleValue]), [dash.Dashboardorignwidth doubleValue]-30*KFontmultiple, [dash.Dashboardorignheight doubleValue]-30*KFontmultiple);
            self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        }else{
            self.frame = CGRectMake([dash.Dashboardorigny floatValue]+55+page*SCREEN_MAX+15*KFontmultiple, SCREEN_MIN -([dash.Dashboardorignx floatValue]-page*SCREEN_MIN+30*KFontmultiple)-([dash.Dashboardorignheight doubleValue]), [dash.Dashboardorignwidth doubleValue]-30*KFontmultiple, [dash.Dashboardorignheight doubleValue]-30*KFontmultiple);
            self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
        }
      
    }else{
     self.frame = CGRectMake([dash.Dashboardorigny floatValue]+page*SCREEN_MAX+57,[dash.Dashboardorignx floatValue]-page*SCREEN_MIN-35, [dash.Dashboardorignwidth doubleValue] ,[dash.Dashboardorignheight doubleValue]);
     self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        }
}
- (void)setVerticalFrame{
    CustomDashboard *dash = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:self.tag].lastObject;

    self.frame = CGRectMake([dash.Dashboardorignx doubleValue],[dash.Dashboardorigny doubleValue], [dash.Dashboardorignwidth doubleValue], [dash.Dashboardorignheight doubleValue]);
    DLog(@"得到%ld竖屏后%f %f",self.tag,[dash.Dashboardorignx doubleValue], [dash.Dashboardorigny doubleValue] );
    self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);

}
- (void)getNewNumber:(NSNotification *)text{
    
    NSString *presentStr = [NSString stringWithFormat:@"%@", [text.userInfo objectForKey:@"StyleBViewnumber"]];
    NSString *PreviouStr = [NSString stringWithFormat:@"%@", [text.userInfo objectForKey:@"PreStyleBViewnumber"]];
    
    CGFloat start = [PreviouStr floatValue];
    CGFloat end = [presentStr floatValue];
    if ([text.userInfo[@"StyleBViewTag"] floatValue] == self.tag) {
        
        
        
//        switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"]) {
//            case DashboardCustomMode:
//            {
        NSArray *list = [[OBDataModel sharedDataBase]findTableAll:@"Dashboards"] ;
        for (CustomDashboard *dashboard in list) {
            CGFloat Space =   (3*M_PI/2)/([dashboard.DashboardmaxNumber floatValue] - [dashboard.DashboardminNumber floatValue]);
            [self rotateImageView:(-M_PI/2-M_PI/4) + Space*start Withend:(-M_PI/2-M_PI/4) +Space*end];
        }
//            }
//                break;
//            case DashboardClassicMode:
//            {
//                NSArray* pAll = [CustomDashboard findAll];
//                for(CustomDashboard * dashboard in pAll){
//                    CGFloat Space =   (3*M_PI/2)/([dashboard.DashboardBmaxNumber floatValue] - [dashboard.DashboardBminNumber floatValue]);
//                    [self rotateImageView:(-M_PI/2-M_PI/4) + Space*start Withend:(-M_PI/2-M_PI/4) +Space*end];
//
//                }
//            }
//                break;
//            default:
//                break;
//        }
    }
    
    
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)initWithModel:(CustomDashboard *)model{
    view = [[gradientView alloc]initWithFrame:self.bounds];
    view.gradientRadius = [model.DashboardBGradientRadius floatValue];
    view.startGradientColor =  [ColorTools colorWithHexString:model.DashboardBbackColor];
    view.endGradientColor =  [UIColor clearColor];
    [self addSubview:view];
    //添加仪表盘中间的内容
    [self addmiddle:model.DashboardBtitleColor TitlteFontScale:[model.DashboardBtitleFontScale floatValue] TitlePositon:[model.DashboardBtitlePositon floatValue] ValueVisible:model.DashboardBValueVisible Valuecolor:model.DashboardBValueColor ValueFontScale:[model.DashboardBValueFontScale floatValue] ValuePositon:[model.DashboardBValuePositon floatValue] UnitColor:model.DashboardBUnitColor UnitFontScale:[model.DashboardBUnitFontScale floatValue] UnitPositon:[model.DashboardBUnitPositon floatValue] withmoel:(CustomDashboard *)model  ];
    
    //添加仪表盘 底部的内容
    image2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 100*KMultipleB, self.frame.size.width -73.0*KMultipleB , 200.0*KMultipleB,  70.0*KMultipleB)];
    image2.image = [UIImage imageNamed:@"yuanhu"];
    image2.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:image2];
    
    //添加进度条
    //    [self draw:self.frame.size.width/2 - 23.0*KMultipleB lineWidth:12.0*KMultipleB lineColor:[ColorTools colorWithHexString:@"1d2027"] startAngle:(M_PI / 4) +(M_PI/18) endAngle: M_PI *3/4-M_PI/18];
    
    [self draw:self.frame.size.width/2 - (23.0/300)*self.frame.size.width lineWidth:12.0*KMultipleB lineColor:[ColorTools colorWithHexString:model.DashboardBFillColor] startAngle:(M_PI / 2) endAngle: M_PI *3/4-M_PI/18];
    [self adddrawPointColor:model.DashboardBpointerColor PointWidth:[model.DashboardBPointerwidth floatValue] Fillenable:model.DashboardBFillEnable   FillColor:model.DashboardBFillColor];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:LongPress];
    if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardCustomMode ) {
        UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [self addGestureRecognizer:pinchGR];
    }
}
-(void)tap:(UILongPressGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(tap:)]) {
        [self.delegate tap:sender];
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
#pragma mark画指针 圆与三角形
- (void)rotateImageView:(CGFloat)StartAngle Withend:(CGFloat)endAngle {
    CGPoint oldOrigin = _triangleView.frame.origin;
    //设置triangleView的角度与开始位置一直
    _triangleView.layer.anchorPoint = CGPointMake(0.5, 1);
    CGPoint newOrigin = _triangleView.layer.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    _triangleView.center = CGPointMake (_triangleView.center.x - transition.x, _triangleView.center.y - transition.y);
    CABasicAnimation *animation = [CABasicAnimation new];
    // 设置动画要改变的属性
    animation.keyPath = @"transform.rotation.z";
    animation.fromValue = @(endAngle);
    // 动画的最终属性的值（）
    animation.toValue = @(StartAngle);
    // 动画的播放时间
    animation.duration = 1;
    //    animation.repeatCount = 1;
    
    // 动画效果慢进慢出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 解决动画结束后回到原始状态的问题
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 将动画添加到视图bgImgV的layer上
    [_triangleView.layer addAnimation:animation forKey:@"rotation"];
    
}
- (void)adddrawPointColor:(NSString *)PointColor PointWidth:(CGFloat )PointWidth Fillenable:(BOOL)fillenable   FillColor:(NSString *)fillColor{
    
    polygonLayer.strokeColor = [ColorTools colorWithHexString:PointColor].CGColor;
    polygonLayer.path = polygonPath.CGPath;
    polygonLayer.fillColor = [ColorTools colorWithHexString:PointColor].CGColor; //
    lineLayer.strokeColor = [ColorTools colorWithHexString:PointColor].CGColor;
    
}

- (void)addmiddle:(NSString *)titlteColor TitlteFontScale:(CGFloat )titlteFontScale TitlePositon:(CGFloat)titlePositon ValueVisible:(BOOL )valueVisible Valuecolor:(NSString *)ValueColor  ValueFontScale:(CGFloat)valueFontScale ValuePositon:(CGFloat)valuePositon UnitColor:(NSString *)unitColor UnitFontScale:(CGFloat)unitFontScale  UnitPositon:(CGFloat)unitPositon withmoel:(CustomDashboard *)model {
    
    innerimage = [[UIImageView alloc]initWithFrame:CGRectMake(43.0*KMultipleB, 43.0*KMultipleB, self.frame.size.width - 86.0*KMultipleB,  self.frame.size.width - 86.0*KMultipleB)];
    innerimage.image = [UIImage imageNamed:@"circle-top"];
    innerimage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:innerimage];
    
    _NumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,innerimage.frame.size.height/3, innerimage.frame.size.width, innerimage.frame.size.height/3)];
    _NumberLabel.font =    [UIFont fontWithName:@"DBLCDTempBlack"size:56.0*KMultipleB*valueFontScale];
    
    _NumberLabel.textColor = [ColorTools colorWithHexString: ValueColor];
    
    _NumberLabel.textAlignment = NSTextAlignmentCenter;
    _NumberLabel.text = @"2500";
    
    if (model.DashboardBValueVisible == YES) {
        [innerimage addSubview:_NumberLabel];
    }else{
        
    }
    
    _PIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, innerimage.frame.size.width, innerimage.frame.size.height/3)];
    _PIDLabel.font = [UIFont boldSystemFontOfSize:24.0*KMultipleB*titlteFontScale];
    _PIDLabel.textColor =[ColorTools colorWithHexString: titlteColor];
    _PIDLabel.textAlignment = NSTextAlignmentCenter;
    _PIDLabel.text = model.DashboardPID;
    [innerimage addSubview:_PIDLabel];
    _UnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2*innerimage.frame.size.height/3, innerimage.frame.size.width, innerimage.frame.size.height/3)];
    _UnitLabel.font = [UIFont boldSystemFontOfSize:17*KMultipleB*unitFontScale];
    _UnitLabel.textColor =  [ColorTools colorWithHexString:unitColor];
    _UnitLabel.textAlignment = NSTextAlignmentCenter;
    _UnitLabel.text = @"km/h";
    
    [innerimage addSubview:_UnitLabel];
}
- (void)draw:(CGFloat )radius lineWidth:(CGFloat)width lineColor:(UIColor *)color startAngle:(CGFloat)start endAngle:(CGFloat)end{
    CGPoint _c = CGPointMake(self.frame.size.width/2   , self.frame.size.width/2 );
    CGFloat _r = radius;
    CGFloat startAngle =start; // 开始角度
    CGFloat endAngle = end; // 结束角度
    BOOL clockwise = YES; // 顺时针
    
    containerLayer = [CALayer layer];
    
    // 环形Layer层
    circleLayer = [CAShapeLayer layer];
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
#pragma mark 开始点击
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"chumochumo");
    //该view置于最前
    
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
        //        DLog(@"curP====%@",NSStringFromCGPoint(curP));
        //        DLog(@"preP====%@",NSStringFromCGPoint(preP));
        
        CGFloat offsetX = curP.x - preP.x;
        CGFloat offsetY = curP.y - preP.y;
        
        //平移
        self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    }
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([DashboardSetting sharedInstance].isDashboardMove == YES  && [DashboardSetting sharedInstance].Dashboardindex == self.tag) {
        
        if ([self.delegate respondsToSelector:@selector(touchMoveWithcenterX:WithcenterY:)]) {
            DLog(@"origin%f,%f",self.frame.origin.x,self.frame.origin.y );
            [self.delegate touchMoveWithcenterX:self.frame.origin.x WithcenterY:self.frame.origin.y];
            //移动view
        }
    }
    
    
}
@end

