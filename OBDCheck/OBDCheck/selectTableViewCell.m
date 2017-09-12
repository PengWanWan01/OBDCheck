//
//  selectTableViewCell.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/11.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "selectTableViewCell.h"

@implementation selectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.backgroundColor  = [ColorTools colorWithHexString:@"3B3F49"];
    self.accessoryView.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
