//
//  UIViewController+NavBar.h
//  SP2P
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (NavBar)

//typedef void(^ButtonClick)();// 这里的index是参数，我传递的是button的tag值，当然你可以自己决定传递什么参数
////下一步就是声明属性了，注意block的声明属性修饰要用copy
//@property (nonatomic,copy) ButtonClick buttonAction;

- (void)initNavBarTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemImageName:(NSString *)rightItemImageName;

- (void)initNavBarTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemName:(NSString *)rightItemName;

- (void)initNavBarDefineTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemImageName:(NSString *)rightItemImageName;

- (void)rightBarButtonClick;

- (void)back;
- (UIViewController *)getCurrentVC;
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view ;
@end
