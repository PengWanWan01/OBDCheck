//
//  UIViewController+NavBar.h
//  SP2P
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (NavBar)



- (void)initNavBarTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemImageName:(NSString *)rightItemImageName;

- (void)initNavBarTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemName:(NSString *)rightItemName;


- (void)rightBarButtonClick;

- (void)back;
-(void)viewDidLayoutSubviews;

- (UIViewController *)getCurrentVC;

@end
