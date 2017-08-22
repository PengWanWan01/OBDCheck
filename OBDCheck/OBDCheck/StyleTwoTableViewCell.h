//
//  StyleTwoTableViewCell.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/21.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectColorDelegete <NSObject>

@optional
- (void)selectColorBetouched:(UIColor *)color;

@end

@interface StyleTwoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *ColorView;
@property (weak, nonatomic) IBOutlet UILabel *ColorLabel;

@property (nonatomic,weak) id<selectColorDelegete> delegate;
@end
