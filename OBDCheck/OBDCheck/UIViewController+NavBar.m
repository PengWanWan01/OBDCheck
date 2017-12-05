//
//  UIViewController+NavBar.m
//  SP2P
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "UIViewController+NavBar.h"

@implementation UIViewController (NavBar)

- (void)initNavBarTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemImageName:(NSString *)rightItemImageName
{
  
    [self initNavBarTitle:titleName andLeftItemImageName:leftItemImageName andRightItemName:@""];
    
    if (![rightItemImageName isEqualToString:@""]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:rightItemImageName] forState:UIControlStateNormal  ];
        [btn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0 , 42, 42);
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
               self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

- (void)initNavBarTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemName:(NSString *)rightItemName
{
    if (![leftItemImageName isEqualToString:@""]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        [btn setImage:[UIImage imageNamed:leftItemImageName] forState:UIControlStateNormal  ];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0 , 42, 42);
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    if (![rightItemName isEqualToString:@""]) {
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightItemName style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
        [rightButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    self.navigationItem.title=titleName;
    self.navigationController.navigationBar.translucent = NO; //导航栏颜色不会发生变化
    [self.navigationController.navigationBar setBarTintColor:[ColorTools colorWithHexString:@"#212329"]];
 
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTools colorWithHexString:@"#FE9002"],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18.0f],NSFontAttributeName, nil]];
    
}

- (void)orientChange:(NSNotification *)notification{
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat  index = 0 ;
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    if (orient == UIDeviceOrientationPortrait) {
        NSLog(@"竖屏2");
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-1, self.navigationController.navigationBar.frame.size.width, 1)];
        line.backgroundColor = [ColorTools colorWithHexString:@"#36373d"];
        [self.navigationController.navigationBar addSubview:line];
        [self.navigationController.navigationBar bringSubviewToFront:line];
    }else  if (orient == UIDeviceOrientationLandscapeLeft){
        NSLog(@"横屏2");
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-1, self.navigationController.navigationBar.frame.size.width, 1)];
        line.backgroundColor = [ColorTools colorWithHexString:@"#36373d"];
        [self.navigationController.navigationBar addSubview:line];
        [self.navigationController.navigationBar bringSubviewToFront:line];
        
        
    }
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick
{
    
}

/**
 *  解决右滑返回手势不可用
 */
- (void)backGesture {
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
