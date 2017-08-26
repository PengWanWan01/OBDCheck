//
//  StyleThreeTableViewCell.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/21.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleThreeTableViewCell.h"

@implementation StyleThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.SwitchBtn addTarget:self action:@selector(selctSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)selctSwitchBtn{

    if ([self.delegate respondsToSelector:@selector(selectSwtichBetouched:)]) {
        [self.delegate selectSwtichBetouched:self.SwitchBtn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
