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
    self.innerColor = innerColor;
    self.outerColor = outerColor;
    self.Gradientradius = gradientradius;
    self.NumberLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, (view.bounds.size.height/2 - 35.0*KMultipleC)*valuePositon , view.bounds.size.width, 80.f*KMultipleC)];
    self.NumberLabel.font =    [UIFont fontWithName:@"DBLCDTempBlack"size:valueFontScale* 74.f*KMultipleC];
    self.NumberLabel.text = @"0.00";
    self.NumberLabel.textAlignment = NSTextAlignmentCenter;
    self.NumberLabel.textColor = [ColorTools colorWithHexString:ValueColor];
    
    self.ValueColor = ValueColor;
    self.ValueFontScale = valueFontScale;
    self.ValuePositon = valuePositon;
    
    self.PIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,(53*KMultipleC)*titlePosition , view.bounds.size.width, 35.0*KMultipleC)];
    self.PIDLabel.font = [UIFont systemFontOfSize:tiltefontScale* 36.f*KMultipleC];
    self.PIDLabel.text = @"RPM";
    self.PIDLabel.textAlignment = NSTextAlignmentCenter;
    self.PIDLabel.textColor = [ColorTools colorWithHexString:titlecolor];
    self.titlePositon = titlePosition;
    self.titleFontScale =tiltefontScale;
    self.titleColor = titlecolor;
    
    self.UnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,( view.bounds.size.height  - 78*KMultipleC)*unitPositon, view.bounds.size.width, 35.0*KMultipleC)];
    self.UnitLabel.font = [UIFont systemFontOfSize:36.f*KMultipleC*unitFontScale];
    self.UnitLabel.text = @"/min";
    self.UnitLabel.textAlignment = NSTextAlignmentCenter;
    self.UnitLabel.textColor = [ColorTools colorWithHexString:unitColor];
    self.UnitColor = unitColor;
    self.UnitFontScale = unitFontScale;
    self.UnitPositon = unitPositon;
    
    self.FrameColor = frameColor;
    self.FrameScale = frameScale;
    [self addSubview:view];
    [view addSubview:self.PIDLabel];
    [view addSubview:self.NumberLabel];
    [view addSubview:self.UnitLabel];

    
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:LongPress];
}
-(void)tap:(UILongPressGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(tap:)]) {
        [self.delegate tap:sender];
    }
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
    //    if ([self.delegate respondsToSelector:@selector(touchMoveWithcenterX:WithcenterY:)]) {
    //        [self.delegate touchMoveWithcenterX:newcenter.x WithcenterY:newcenter.y];
    //
    //    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
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
    if ([self.delegate respondsToSelector:@selector(touchMoveWithcenterX:WithcenterY:)]) {
        [self.delegate touchMoveWithcenterX:newcenter.x WithcenterY:newcenter.y];
        
    }
}
@end
