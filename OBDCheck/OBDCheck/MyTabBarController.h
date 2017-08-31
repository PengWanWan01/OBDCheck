//
//  MyTabBarController.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,AppDelegateTabBar)
{
    AppDelegateTabBarOne=0,   // 第一种风格
    AppDelegateTabBarTwo,    //第二种风格
    AppDelegateTabBarThree=2     //第三种风格
};
@interface MyTabBarController : UITabBarController
@property(nonatomic)   AppDelegateTabBar appDelegateTabBar;

@end
