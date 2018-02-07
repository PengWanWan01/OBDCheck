//
//  bluetoothView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理
@protocol reconnectionDelegate <NSObject>
@optional
///重写连接蓝牙
-(void)reconnectionBlueTooth;
@end;

@interface bluetoothView : UIView
- (void)show;
- (void)hide;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic , weak) id<reconnectionDelegate> delegate;

@end
