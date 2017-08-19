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
        self.PIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 200, 20)];
        self.PIDLabel.textColor = [ColorTools colorWithHexString:@"#44FF00"];
        self.PIDLabel.text = @"avergr fuel consumption";
        self.PIDLabel.font = [UIFont ToAdapFont:14.f];
        
        self.PIDLabel.textAlignment = NSTextAlignmentLeft;
        
        self.NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ViewHeight/2 - 30, ViewWidth, 60)];
        self.NumberLabel.textColor = [ColorTools colorWithHexString:@"#44FF00"];
        self.NumberLabel.text = @"7.6";
        self.NumberLabel.textAlignment = NSTextAlignmentCenter;
        self.NumberLabel.font = [UIFont ToAdapFont:70.f];
        
        self.UnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth - 105, ViewHeight - 20, 100, 20)];
        self.UnitLabel.textColor = [ColorTools colorWithHexString:@"#44FF00"];
        self.UnitLabel.text = @"/MIN";
        self.UnitLabel.font = [UIFont ToAdapFont:14.f];
        self.UnitLabel.textAlignment = NSTextAlignmentRight;

        [self addSubview:self.PIDLabel];
        [self addSubview:self.NumberLabel];
        [self addSubview:self.UnitLabel];

        
    }
    return self;
}
@end
