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
- (void)selectColorBetouched:(NSInteger )indexTag;

@end

@interface StyleTwoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *ColorView;
@property (weak, nonatomic) IBOutlet UILabel *ColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (nonatomic,weak) id<selectColorDelegete> delegate;

@property (nonatomic,strong) void(^colorClick)(NSString *Color) ;
@end
