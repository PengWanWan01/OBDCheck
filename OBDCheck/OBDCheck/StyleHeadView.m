
//
//  StyleHeadView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleHeadView.h"

@implementation StyleHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        switch ([DashboardSetting sharedInstance].dashboardStyle ) {
            case DashboardStyleOne:{
              self.DashboardView = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            }
                break;
            case DashboardStyleTwo:{
                self.DashboardView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            }
                break;
            case DashboardStyleThree:{
                   self.DashboardView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
                }
                break;
            default:
                break;
        }
        self.NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.DashboardView.frame) + 5, 150, 20)];
        self.NumberLabel.textAlignment = NSTextAlignmentCenter;
        self.NumberLabel.font = [UIFont ToAdapFont:12];
        self.NumberLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        self.NumberLabel.text = @"60";

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
        label.text = @"Value";
        label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        label.font = [UIFont ToAdapFont:14.f];
        
        self.slider = [[UISlider alloc]initWithFrame:CGRectMake(260, CGRectGetMaxY(label.frame )+10, 150, 20)];
        
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(29, CGRectGetMaxY(self.NumberLabel.frame) + 10, MSWidth - 58, 24)];
        btnView.backgroundColor = [UIColor redColor];
        for (int i = 0; i< 4; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(btnView.frame.size.width/4), 0, btnView.frame.size.width/4, 24)];
            [btn setTitle:@"12" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont ToAdapFont:13];
            [btn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
            
            [btnView addSubview:btn];
        }
        [self addSubview:self.DashboardView];
        [self addSubview:label];
        [self addSubview:self.slider];
        [self addSubview:self.NumberLabel];
        [self addSubview:btnView];
        
        
    }
    return self;
}
@end
