//
//  DashboardViewStyleC.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardViewStyleC.h"
#define KMultipleC   ViewWidth/320

@implementation DashboardViewStyleC

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)drawinnerColor:(NSString *)innerColor OuterColor:(NSString *)outerColor Gradientradius:(CGFloat)gradientradius TitleColor:(NSString *)titlecolor TiltefontScale:(CGFloat)tiltefontScale TitlePosition:(CGFloat)titlePosition ValueVisible:(BOOL)valueVisible  Valuecolor:(NSString *)ValueColor  ValueFontScale:(CGFloat)valueFontScale ValuePositon:(CGFloat)valuePositon UnitColor:(NSString *)unitColor UnitFontScale:(CGFloat)unitFontScale  UnitPositon:(CGFloat)unitPositon FrameColor:(NSString *)frameColor FrameScale:(CGFloat)frameScale{
  
    self.backgroundColor = [ColorTools colorWithHexString:outerColor];
    self.layer.borderColor=[ColorTools colorWithHexString:outerColor].CGColor;
    self.layer.borderWidth=1;
    self.layer.cornerRadius= gradientradius;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(21*KMultipleC, 21*KMultipleC, self.bounds.size.width - 42*KMultipleC, self.bounds.size.width - 42*KMultipleC)];
    view.backgroundColor = [ColorTools colorWithHexString:innerColor];
    view.layer.cornerRadius=gradientradius;
    //UIView设置阴影
    [[view layer] setShadowOffset:CGSizeMake(1, 1)];
    [[view layer] setShadowRadius:gradientradius];
    [[view layer] setShadowOpacity:0.1f]; //阴影的透明度
    [[view layer] setShadowColor:[ColorTools colorWithHexString:innerColor].CGColor];
   
    self.NumberLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, (view.bounds.size.height/2 - 35.0*KMultipleC)*valuePositon , view.bounds.size.width, 80.f*KMultipleC)];
    self.NumberLabel.font =    [UIFont fontWithName:@"DBLCDTempBlack"size:valueFontScale* 74.f*KMultipleC];
    self.NumberLabel.text = @"0.00";
    self.NumberLabel.textAlignment = NSTextAlignmentCenter;
    self.NumberLabel.textColor = [ColorTools colorWithHexString:ValueColor];
   
    
    self.PIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,(53*KMultipleC)*titlePosition , view.bounds.size.width, 35.0*KMultipleC)];
    self.PIDLabel.font = [UIFont systemFontOfSize:tiltefontScale* 36.f*KMultipleC];
    self.PIDLabel.text = @"RPM";
    self.PIDLabel.textAlignment = NSTextAlignmentCenter;
    self.PIDLabel.textColor = [ColorTools colorWithHexString:titlecolor];
  
    self.UnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,( view.bounds.size.height  - 78*KMultipleC)*unitPositon, view.bounds.size.width, 35.0*KMultipleC)];
    self.UnitLabel.font = [UIFont systemFontOfSize:36.f*KMultipleC*unitFontScale];
    self.UnitLabel.text = @"/min";
    self.UnitLabel.textAlignment = NSTextAlignmentCenter;
    self.UnitLabel.textColor = [ColorTools colorWithHexString:unitColor];
  
    [self addSubview:view];
    [view addSubview:self.PIDLabel];
    [view addSubview:self.NumberLabel];
    [view addSubview:self.UnitLabel];

    
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:LongPress];
    UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinchGR];
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
#pragma mark 开始点击
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    if ([DashboardSetting sharedInstance].isDashboardMove == YES && [DashboardSetting sharedInstance].Dashboardindex == self.tag) {
        
        
        //该view置于最前
        [[self superview] bringSubviewToFront:self];
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
    
}@end
