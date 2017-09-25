//
//  ColorTableViewCell.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/25.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imageColor;
@property (weak, nonatomic) IBOutlet UILabel *titleColor;
@property (weak, nonatomic) IBOutlet UIImageView *SelcetColor;

@end
