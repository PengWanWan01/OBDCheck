//
//  PIDViewCell.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/25.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIDViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *AVRLabel;
@property (weak, nonatomic) IBOutlet UILabel *MaxLabel;

@end
