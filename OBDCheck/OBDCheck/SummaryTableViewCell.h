//
//  SummaryTableViewCell.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,summarytype ){
    errorType,
    warnType
};

@interface SummaryTableViewCell : UITableViewCell
@property (nonatomic,copy) NSString *titleLabel;//  名称
@property (nonatomic,copy) NSString *detailLabel;//  详细名称
@property (nonatomic,assign) summarytype sumtype;
@end
