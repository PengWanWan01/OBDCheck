//
//  FileInfoView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/28.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FileInfoView.h"

@implementation FileInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.FileInfoView = [[[NSBundle mainBundle]loadNibNamed:@"FileInfoView" owner:self options:nil]lastObject];
    self.FileInfoView.frame = self.bounds;
    [self addSubview:self.FileInfoView];
}


@end
