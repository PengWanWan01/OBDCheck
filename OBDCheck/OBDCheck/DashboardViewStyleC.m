//
//  DashboardViewStyleC.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardViewStyleC.h"

@implementation DashboardViewStyleC

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)setNeedsLayout{
    [super setNeedsLayout];
    view.frame = CGRectMake(21*KMultipleC, 21*KMultipleC, self.bounds.size.width - 42*KMultipleC, self.bounds.size.width - 42*KMultipleC);
    self.NumberLabel.frame = CGRectMake(0, view.bounds.size.height/3, view.bounds.size.width, view.bounds.size.height/3);
    self.NumberLabel.font =    [UIFont fontWithName:@"DBLCDTempBlack"size: 74.f*KMultipleC];
    self.PIDLabel.frame = CGRectMake(0,0, view.bounds.size.width,view.bounds.size.height/3);
    self.PIDLabel.font = [UIFont systemFontOfSize: 36.f*KMultipleC];
    self.UnitLabel.frame =CGRectMake(0,2*view.bounds.size.height/3, view.bounds.size.width, view.bounds.size.height/3);
    self.UnitLabel.font = [UIFont systemFontOfSize:36.f*KMultipleC];
}
- (void)initWithModel:(CustomDashboard *)model{
    
    self.backgroundColor = [ColorTools colorWithHexString:model.DashboardCouterColor];
    self.layer.borderColor=[ColorTools colorWithHexString:model.DashboardCouterColor].CGColor;
    self.layer.borderWidth=1;
    view = [[gradientView alloc]initWithFrame:CGRectMake(21*KMultipleC, 21*KMultipleC, self.bounds.size.width - 42*KMultipleC, self.bounds.size.width - 42*KMultipleC)];
    view.gradientRadius = [model.DashboardCGradientradius floatValue];
    view.startGradientColor =   [UIColor clearColor];
    view.endGradientColor =  [ColorTools colorWithHexString:model.DashboardCinnerColor];
     [self addSubview:view];
    self.NumberLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, view.bounds.size.height/3, view.bounds.size.width, view.bounds.size.height/3)];
    self.NumberLabel.font =    [UIFont fontWithName:@"DBLCDTempBlack"size:[model.DashboardCValueFontScale floatValue]* 74.f*KMultipleC];
    self.NumberLabel.text = @"0.00";
    self.NumberLabel.textAlignment = NSTextAlignmentCenter;
    self.NumberLabel.textColor = [ColorTools colorWithHexString:model.DashboardCValueColor];
    
    
    self.PIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, view.bounds.size.width,view.bounds.size.height/3)];
    self.PIDLabel.font = [UIFont systemFontOfSize:[model.DashboardCtitleFontScale floatValue]* 36.f*KMultipleC];
    self.PIDLabel.text = @"RPM";
    self.PIDLabel.textAlignment = NSTextAlignmentCenter;
    self.PIDLabel.textColor = [ColorTools colorWithHexString:model.DashboardCtitleColor];
    
    self.UnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,2*view.bounds.size.height/3, view.bounds.size.width, view.bounds.size.height/3)];
    self.UnitLabel.font = [UIFont systemFontOfSize:36.f*KMultipleC*[model.DashboardCUnitFontScale floatValue]];
    self.UnitLabel.text = @"/min";
    self.UnitLabel.textAlignment = NSTextAlignmentCenter;
    self.UnitLabel.textColor = [ColorTools colorWithHexString:model.DashboardCUnitColor];
    

    
    [view addSubview:self.PIDLabel];
    if (model.DashboardCValueVisible == YES) {
        [view addSubview:self.NumberLabel];
    }
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
    
    
}@end

