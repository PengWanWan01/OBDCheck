//
//  StyleThreeTableViewCell.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/21.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selectSwtichDelegete <NSObject>

@optional
- (void)selectSwtichBetouched:(UISwitch  *)switchBtn;

@end

@interface StyleThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchBtn;
@property (nonatomic,weak) id<selectSwtichDelegete> delegate;
@end
