//
//  HUDView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/18.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "HUDView.h"

@implementation HUDView

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
        self.PIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        self.PIDLabel.textColor = [UIColor greenColor];
        self.PIDLabel.text = @"avergr fuel consumption";
        self.PIDLabel.font = [UIFont systemFontOfSize:15.f];
        
        self.NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ViewHeight/2 - 20, ViewWidth, 40)];
        self.NumberLabel.textColor = [UIColor greenColor];
        self.NumberLabel.text = @"7.6";
        self.NumberLabel.font = [UIFont systemFontOfSize:25.f];
        
        self.UnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth - 100, ViewHeight - 20, 100, 20)];
        self.UnitLabel.textColor = [UIColor greenColor];
        self.UnitLabel.text = @"/MIN";
        self.UnitLabel.font = [UIFont systemFontOfSize:15.f];
        
        [self addSubview:self.PIDLabel];
        [self addSubview:self.NumberLabel];
        [self addSubview:self.UnitLabel];

        
    }
    return self;
}
@end
