//
//  DashboardViewStyleB.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewStyleB : UIImageView
{
    CGPoint startPoint;
}
@property (nonatomic,strong)UILabel *PIDLabel;
@property (nonatomic,strong)UILabel *NumberLabel;
@property (nonatomic,strong)UILabel *UnitLabel;
@end
