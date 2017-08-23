//
//  DashboardViewA.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/23.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardViewA.h"

@implementation DashboardViewA

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
        self.userInteractionEnabled = YES;
        self.dashView = [[DashboardView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        self.infoLabel = self.dashView.infoLabel;
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dashView.frame)+ 5, self.frame.size.width, 20)];
        self.numberLabel.font = [UIFont boldSystemFontOfSize:17];
        self.numberLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.text = @"N/A";
        [self addSubview:self.numberLabel];
        [self addSubview:self.dashView];
    }
    return self;
}
@end
