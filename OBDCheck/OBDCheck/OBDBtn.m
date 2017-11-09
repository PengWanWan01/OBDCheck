//
//  OBDBtn.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/3.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "OBDBtn.h"

@implementation OBDBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*MSWidth/375, 100*MSWidth/375)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat space = IS_IPHONE_4_OR_LESS?0:10*MSHeight/667;
        self.Label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+space, 100*MSWidth/375, 20*MSHeight/667)];
        [self.Label setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
        self.Label.textAlignment = NSTextAlignmentCenter;
        if (IS_IPHONE_5) {
            self.Label.font = [UIFont systemFontOfSize:14.f];
        }else{
        self.Label.font = [UIFont systemFontOfSize:15.f];
        }
        [self addSubview:self.imageView];
        [self addSubview:self.Label];
    }
    return self;
}

@end
