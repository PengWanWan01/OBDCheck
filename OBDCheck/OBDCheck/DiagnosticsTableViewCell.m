//
//  DiagnosticsTableViewCell.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DiagnosticsTableViewCell.h"

@implementation DiagnosticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    switch (self.toubleCodeType) {
        case toubleCodeTypenormal:
        {
            self.TypeImage.image  =[UIImage imageNamed:@"troubleCode_highLight"];
        }
            break;
        case toubleCodeTypeimportant:
        {
            self.TypeImage.image  =[UIImage imageNamed:@"troubleCode_important"];
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
