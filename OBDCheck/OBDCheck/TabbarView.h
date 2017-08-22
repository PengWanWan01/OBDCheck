//
//  TabbarView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/22.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabbarSelectDelegate <NSObject>

@optional
- (void)OBDBtnBeTouch;
- (void)SpeacialBtnBeTouch;
- (void)PersonBtnBeTouch;

@end
@interface TabbarView : UIView
@property (nonatomic,strong) NSMutableArray  *dataSoureNormal;
@property (nonatomic,strong) NSMutableArray  *dataSoureSelect;

@end
