//
//  bluetoothView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bluetoothView : UIView

- (void)show;
- (void)hide;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
