//
//  CusTabBar.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/1/3.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,tabbartype){
    type1=0,
    type2,
    type3
};
@interface CusTabBar : UITabBarController
@property (assign,nonatomic)tabbartype  tabbarType;
-(void)initWithView;
@end
