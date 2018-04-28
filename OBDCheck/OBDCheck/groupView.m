//
//  groupView.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/26.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "groupView.h"

@implementation groupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)initWithborderwidth:(CGFloat)width{
    BackGradient *View = [[BackGradient alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [View initWithUIWidth:width withStartAngle:0 withendAngle:2*M_PI withstartPoint:CGPointMake(0, 0.5) withendPoint:CGPointMake(1, 0.5) withStartColor:[ColorTools colorWithHexString:@"767676"] withendColor:[ColorTools colorWithHexString:@"9C9C9C"]];
    RudiusGradient *View2 = [[RudiusGradient alloc]initWithFrame:CGRectMake(width, width, View.frame.size.width-width*2, View.frame.size.height-width*2)];
    [View2 initWithViewStartColor:[ColorTools colorWithHexString:@"383737"] withendColor:[ColorTools colorWithHexString:@"0a0a0a"]];
    [View addSubview:View2];
    [self addSubview:View];
     
}
@end
