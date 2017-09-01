//
//  DiagnosticsTableViewCell.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,ToubleCodeType)
{
    toubleCodeTypenormal=0,   //普通故障码
    toubleCodeTypeimportant,    //重要故障码
};

@interface DiagnosticsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;

@property (weak, nonatomic) IBOutlet UILabel *detialTitle;
@property (weak, nonatomic) IBOutlet UIImageView *TypeImage;
@property (nonatomic,assign) ToubleCodeType toubleCodeType;
@end
