//
//  UIViewController+NavBar.m
//  SP2P
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "UIViewController+NavBar.h"
#import "UIViewController+NavBar.h"


@implementation UIViewController (NavBar)

- (void)initNavBarTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemImageName:(NSString *)rightItemImageName
{
    [self backGesture];
    self.navigationItem.hidesBackButton = NO;
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
      [self backGesture];
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
    UILabel *topViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, self.navigationController.navigationBar.frame.size.height)];
    topViewLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    topViewLabel.textAlignment = NSTextAlignmentCenter;
    
    topViewLabel.text = titleName;
    self.navigationItem.titleView= topViewLabel;
    self.navigationController.navigationBar.translucent = NO; //导航栏颜色不会发生变化
    [self.navigationController.navigationBar setBarTintColor:[ColorTools colorWithHexString:@"#212329"]];
 
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTools colorWithHexString:@"#FE9002"],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18.0f],NSFontAttributeName, nil]];
}
- (void)initNavBarDefineTitle:(NSString *)titleName andLeftItemImageName:(NSString *)leftItemImageName andRightItemImageName:(NSString *)rightItemImageName
{
    [self backGesture];
    self.navigationItem.hidesBackButton = NO;
    [self backGesture];
    if (![leftItemImageName isEqualToString:@""]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:leftItemImageName] forState:UIControlStateNormal  ];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0 , 42, 42);
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
   
    self.navigationController.navigationBar.translucent = NO; //导航栏颜色不会发生变化
    [self.navigationController.navigationBar setBarTintColor:[ColorTools colorWithHexString:@"#212329"]];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTools colorWithHexString:@"#FE9002"],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18.0f],NSFontAttributeName, nil]];
    
    if (![rightItemImageName isEqualToString:@""]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:rightItemImageName] forState:UIControlStateNormal  ];
        [btn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0 , 42, 42);
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    UIButton  *titleBtn= [[RLBtn alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    if ([DashboardSetting sharedInstance].blueState == 1) {
       [titleBtn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
    }else{
       [titleBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
    }
    [titleBtn setTitle:@"Connect" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [titleBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(LinkBlueTooth) forControlEvents:UIControlEventTouchUpInside];
   
    self.navigationItem.titleView = titleBtn;
}
- (void)LinkBlueTooth{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"linkConnect" object:nil userInfo:nil];
    
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
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
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
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


@end
