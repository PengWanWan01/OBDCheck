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
        self.userInteractionEnabled = YES;
        self.backgroundColor = [ColorTools colorWithHexString:@"202226"];
        self.layer.borderColor=[ColorTools colorWithHexString:@"202226"].CGColor;
        self.layer.borderWidth=1;
        self.layer.cornerRadius=16.f*KMultipleC;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(21*KMultipleC, 21*KMultipleC, self.bounds.size.width - 42*KMultipleC, self.bounds.size.width - 42*KMultipleC)];
        view.backgroundColor = [UIColor blackColor];
        view.layer.cornerRadius=16.f*KMultipleC;
        //UIView设置阴影
        [[view layer] setShadowOffset:CGSizeMake(1, 1)];
        [[view layer] setShadowRadius:16.f*KMultipleC];
        [[view layer] setShadowOpacity:0.1f]; //阴影的透明度
        [[view layer] setShadowColor:[ColorTools colorWithHexString:@"FFFFFF"].CGColor];
    self.NumberLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, view.bounds.size.height/2 - 35.0*KMultipleC , view.bounds.size.width, 80.f*KMultipleC)];
    self.NumberLabel.font =    [UIFont fontWithName:@"DBLCDTempBlack"size:74.f*KMultipleC];
        self.NumberLabel.text = @"0.00";
        self.NumberLabel.textAlignment = NSTextAlignmentCenter;
        self.NumberLabel.textColor = [ColorTools colorWithHexString:@"#FFFFFF"];
        
        self.PIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,53*KMultipleC , view.bounds.size.width, 35.0*KMultipleC)];
        self.PIDLabel.font = [UIFont systemFontOfSize:36.f*KMultipleC];
        self.PIDLabel.text = @"RPM";
        self.PIDLabel.textAlignment = NSTextAlignmentCenter;
        self.PIDLabel.textColor = [ColorTools colorWithHexString:@"#FFFFFF"];
        
        self.UnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.bounds.size.height  - 78*KMultipleC, view.bounds.size.width, 35.0*KMultipleC)];
        self.UnitLabel.font = [UIFont systemFontOfSize:36.f*KMultipleC];
        self.UnitLabel.text = @"/min";
        self.UnitLabel.textAlignment = NSTextAlignmentCenter;
        self.UnitLabel.textColor = [ColorTools colorWithHexString:@"#FFFFFF"];
        
        [self addSubview:view];
        [view addSubview:self.PIDLabel];
        [view addSubview:self.NumberLabel];
        [view addSubview:self.UnitLabel];
    }
    return self;
}
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //保存触摸起始点位置
//    CGPoint point = [[touches anyObject] locationInView:self];
//    startPoint = point;
//    
//    //该view置于最前
//    [[self superview] bringSubviewToFront:self];
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //计算位移=当前位置-起始位置
//    CGPoint point = [[touches anyObject] locationInView:self];
//    float dx = point.x - startPoint.x;
//    float dy = point.y - startPoint.y;
//    
//    //计算移动后的view中心点
//    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
//    
//    
//    /* 限制用户不可将视图托出屏幕 */
//    float halfx = CGRectGetMidX(self.bounds);
//    //x坐标左边界
//    newcenter.x = MAX(halfx, newcenter.x);
//    //x坐标右边界
//    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
//    
//    //y坐标同理
//    float halfy = CGRectGetMidY(self.bounds);
//    newcenter.y = MAX(halfy, newcenter.y);
//    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
//    
//    //移动view
//    self.center = newcenter;
//}
-(CGFloat)GetTextSize:(CGFloat)Size
{
    Size*=0.8;
//    if (IS_IPHONE_4_OR_LESS) {
//        Size*=0.7;
//    }
//    else if (IS_IPHONE_5)
//    {
//        Size*=0.8;
//    }
//    else if (IS_IPHONE_6)
//    {
//        
//    }
    
    return Size;
}
@end
