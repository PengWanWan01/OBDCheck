//
//  DashStyleB.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/26.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "DashStyleB.h"
@interface DashStyleB()
{
    CGPoint _center; // 中心点
    CGFloat _radius; // 外环半径
    NSInteger _dialCount; // 刻度线的个数
    NSInteger _dialPieceCount;
    groupView *backView;
}
@property (nonatomic,strong)   UIView *triangleView ; //指针视图
@end

@implementation DashStyleB

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor clearColor];
    
    self.userInteractionEnabled = YES;
    _dialPieceCount  =5;
    _dialCount = 8 * _dialPieceCount;
  
    return self;
}
- (void)initWithModel:(CustomDashboard *)model{
     //第一个表盘
    groupView *Outerback = [[groupView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    Outerback.backgroundColor = [UIColor orangeColor];
    
    [Outerback initWithborderwidth:20];
    [self addSubview:Outerback];
    
    //第二个表盘
    backView = [[groupView alloc]initWithFrame:CGRectMake(22, 22,Outerback.frame.size.width - 44, Outerback.frame.size.height - 44)];
    [backView initWithborderwidth:0];
    [Outerback addSubview:backView];
    
    BackGradient *progress = [[BackGradient alloc]initWithFrame:CGRectMake(0,1, backView.frame.size.width, backView.frame.size.height)];
    //767676 //C9C9C
    [progress  initWithUIWidth:backView.frame.size.width/4 withStartAngle:M_PI- M_PI/4 withendAngle:2*M_PI+M_PI/8 withstartPoint:CGPointMake(0, 0) withendPoint:CGPointMake(1, 1) withStartColor:[ColorTools colorWithHexString:@"00d2ff"] withendColor:[ColorTools colorWithHexString:@"825dff"]];
    //加进度条
    [backView addSubview:progress];
    
    //画表盘的刻度
    _center = CGPointMake(backView.frame.size.width/ 2, backView.frame.size.width/ 2);
    _radius = (backView.bounds.size.width-2)/2 ;
    [self addLine:model];
    
    //画指针圆形⭕️和三角形▶️
    [self adddrawPointerModel:model];
    //三个信息Label
    [self initWithInfoLabel:model];
    
}
#pragma mark 三个信息
- (void)initWithInfoLabel:(CustomDashboard *)model{
   
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, backView.frame.size.height/2 - 50, backView.frame.size.width-30, 30)];
    //        self.infoLabel.backgroundColor = [UIColor whiteColor];
    
    //model.DashboardPID
    self.infoLabel.text = @"VSS";
    self.infoLabel.textColor = [ColorTools colorWithHexString:model.DashboardAtitleColor];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.font = [UIFont systemFontOfSize:40];
    self.infoLabel.adjustsFontSizeToFitWidth = YES;
    
    [backView addSubview:self.infoLabel];
    
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,  backView.frame.size.height/2 +20, backView.bounds.size.width-30, 50)];
    //    self.numberLabel.backgroundColor = [UIColor whiteColor];
    
    self.numberLabel.font = [UIFont boldSystemFontOfSize:[model.DashboardAValueFontScale doubleValue]*56];
    self.numberLabel.textColor = [ColorTools colorWithHexString: model.DashboardAValueColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"63";
    
    if (model.DashboardAValueVisble==YES) {
        [backView addSubview:self.numberLabel];
    }else{
        
    }
    
    self.unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, backView.frame.size.height - 30,  backView.bounds.size.width-30, 20)];
    //        self.unitLabel.backgroundColor = [UIColor whiteColor];
    self.unitLabel.text = @"KM/H";
    self.unitLabel.font = [UIFont ToAdapFont:[model.DashboardAUnitFontScale doubleValue]*18.f];
    self.unitLabel.textColor = [ColorTools colorWithHexString:model.DashboardAUnitColor];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.unitLabel];
    
}
#pragma mark 画指针 圆与三角形
- (void)adddrawPointerModel:(CustomDashboard *)model{
    
    
    //画圆 发光
    CGFloat startAngle = 0; // 开始角度
    CGFloat endAngle = 2*M_PI; // 结束角度
    BOOL clockwise = YES; // 顺时针
    
    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 4;
    //圆环的颜色
    circleLayer.strokeColor = [UIColor lightBLue].CGColor;
    //背景填充色
    circleLayer.fillColor = [UIColor blackColor].CGColor;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:17 startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;
    [backView.layer addSublayer:circleLayer];
    
    
    //    [model.DashboardAPointerWidth doubleValue]
    _triangleView= [[UIView alloc]initWithFrame:CGRectMake((backView.bounds.size.width/2)+16, (backView.bounds.size.width/2)-40,12,(backView.bounds.size.width/2)+10)];
    CGPoint oldOrigin = _triangleView.frame.origin;
        _triangleView.backgroundColor = [UIColor orangeRed];
    //设置triangleView的角度与开始位置一直
    _triangleView.layer.anchorPoint = CGPointMake(0.5, 0);
    CGPoint newOrigin = _triangleView.layer.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    _triangleView.center = CGPointMake (_triangleView.center.x - transition.x, _triangleView.center.y - transition.y);
    
    _triangleView.transform = CGAffineTransformMakeRotation([model.DashboardAStartAngle floatValue]+M_PI/2);
    [backView addSubview:_triangleView];
    // 线的路径 三角形
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    
    // 这些点的位置都是相对于所在视图的
    // 起点
    [polygonPath moveToPoint:CGPointMake(6,_triangleView.frame.size.height)];
    // 其他点
    [polygonPath addLineToPoint:CGPointMake(0, 0)];
    //
    [polygonPath addLineToPoint:CGPointMake(12, 0)];
    
    [polygonPath closePath]; // 添加一个结尾点和起点相同
    
    CAShapeLayer *polygonLayer = [CAShapeLayer layer];
    polygonLayer.lineWidth = 1;
    //ColorTools colorWithHexString:model.DashboardAPointerColor
    polygonLayer.strokeColor = [UIColor lightBLue].CGColor;
    polygonLayer.path = polygonPath.CGPath;
    polygonLayer.fillColor = [UIColor lightBLue].CGColor; //
    // 让三角形发光效果
    //    polygonLayer.shadowRadius = 2;
    //    polygonLayer.shadowColor = [UIColor whiteColor].CGColor;
    //    polygonLayer.shadowOffset = CGSizeMake(0, 0);
    //    polygonLayer.shadowOpacity = 1.0;
    if (model.DashboardAPointerVisble == YES) {
        [_triangleView.layer addSublayer:polygonLayer];
    }else{
        
    }
  
    
    
    
}
#pragma mark 画刻度的线条和数字
- (void)addLine:(CustomDashboard *)model{
    NSString *StartAngleStr = [NSString stringWithFormat:@"%d",0] ;
     NSString *endAngleStr = [NSString stringWithFormat:@"%f",M_PI] ;
    
    DLog(@"%@",StartAngleStr);
    double perAngle = (double)([endAngleStr doubleValue]  - [StartAngleStr doubleValue])  / _dialCount;
     DLog(@"%@",[NSString stringWithFormat:@"%f",(double)(4*M_PI)/3]);
    if (perAngle< 0) {
        
        perAngle=    -([endAngleStr doubleValue] - [StartAngleStr doubleValue] )/_dialCount;
    }else
    {
        perAngle = ([endAngleStr doubleValue] - [StartAngleStr doubleValue])  / _dialCount;
    }
    
    
    for (int i = 0; i<= _dialCount; i++) {
        CGFloat startAngel = (- M_PI + perAngle * i+[StartAngleStr floatValue])+0.01;
        CGFloat endAngel = startAngel + perAngle/([model.DashboardAmiWidth doubleValue]);
        //设置指针的宽度
//        if(i%2 == 0){
//            endAngel = endAngel+0.02;
//        }
        if (i % 5 == 0) {
            UIBezierPath *LongtickPath    =   [UIBezierPath bezierPathWithArcCenter:_center radius:(_radius-8) startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *LongperLayer    = [CAShapeLayer layer];
            LongperLayer.strokeColor = [ColorTools colorWithHexString:model.DashboardAmaColor].CGColor;
            //画长指针的长度,LongtickPath  radius = 半径减去lineWidth/2 ,(lineWidth为指针线的长度)
            LongperLayer.lineWidth = 16;
                 _center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2);
            //设置point文字radius半径.应为实际半径减去长度*2+5
            CGPoint point = [self calculateTextPositonWithArcCenter:_center Angle:endAngel radius:(_radius-LongperLayer.lineWidth*2) Rotate:model.DashboardALabelRotate];
 
            //四舍五入
            NSString *tickText = [NSString stringWithFormat:@"%.f",((roundf([model.DashboardmaxNumber doubleValue]- [model.DashboardminNumber doubleValue])/8)*(i/5) +[model.DashboardminNumber doubleValue])];
            //point.y - 10 ,时而point为空会崩溃
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(((point.x - 10)), ((point.y- 10)), floor(30),  floor(30))];
            //            text.backgroundColor = [UIColor orangeColor];
            text.text = tickText;
            text.font = [UIFont systemFontOfSize:[model.DashboardALabelFontScale doubleValue]*16.f];
            text.textColor = [UIColor whiteColor];
            text.textAlignment = NSTextAlignmentCenter;
            
            //让文字刻度显示
            if (model.DashboardALabelVisble == YES) {
                [backView addSubview:text];
            }else{
                
            }
            
            //让文字显示的形式，是正的还是斜的
            if (model.DashboardALabelRotate == YES) {
                
            }else{
                
            }
            LongperLayer.path = LongtickPath.CGPath;
            [backView.layer addSublayer:LongperLayer];
            
        }else{
            UIBezierPath *tickPath  = [UIBezierPath bezierPathWithArcCenter:_center radius:(_radius-8) startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *perLayer = [CAShapeLayer layer];
            
            perLayer.strokeColor = [ColorTools colorWithHexString:model.DashboardAmiColor].CGColor;
            perLayer.lineWidth = 16;
            perLayer.path = tickPath.CGPath;
            [backView.layer addSublayer:perLayer];
            //            //设置渐变颜色  让指针渐变
            //            CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
            //            gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);  // 设置显示的frame
            //            [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor blueColor] CGColor], nil]];
            //            gradientLayer.startPoint = CGPointMake(0.5, 0);
            //            gradientLayer.endPoint = CGPointMake(0.5, 1);
            //            [backView.layer addSublayer:gradientLayer];
            //            [gradientLayer setMask:perLayer];
            
        }
    }
}
#pragma mark // 计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel radius:(CGFloat)Theradius Rotate:(BOOL)labelRotate{
    CGFloat x = (Theradius) * cosf(angel);
    CGFloat y = (Theradius) * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}
@end
