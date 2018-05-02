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
        self.NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ViewHeight/3, ViewWidth, ViewHeight/3)];
        self.NumberLabel.textColor = [ColorTools colorWithHexString:@"#44FF00"];
        self.NumberLabel.text = @"7.6";
        self.NumberLabel.textAlignment = NSTextAlignmentCenter;
        self.NumberLabel.font = [UIFont ToAdapFont:70.f];
        
        
        self.PIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, ViewWidth-26, ViewHeight/3 - 10)];
        self.PIDLabel.textColor = [ColorTools colorWithHexString:@"#44FF00"];
        self.PIDLabel.text = @"avergr fuel consumption";
        self.PIDLabel.font = [UIFont ToAdapFont:14.f];
        self.PIDLabel.textAlignment = NSTextAlignmentLeft;
        
     
        self.UnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(13,2*ViewHeight/3, ViewWidth-26, ViewHeight/3)];
        self.UnitLabel.textColor = [ColorTools colorWithHexString:@"#44FF00"];
        self.UnitLabel.text = @"/MIN";
        self.UnitLabel.font = [UIFont ToAdapFont:14.f];
        self.UnitLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:self.PIDLabel];
        [self addSubview:self.NumberLabel];
        [self addSubview:self.UnitLabel];

       self.RightLine = [[UIView alloc]initWithFrame:CGRectMake(ViewWidth - 2, 0, 1, ViewHeight)];
        self.RightLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.RightLine];
        
        self.buttomLine = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight -1, ViewWidth, 1)];
        self.buttomLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buttomLine];
        
    }
    return self;
}
@end
