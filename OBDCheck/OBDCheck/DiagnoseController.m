//
//  DiagnoseController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/3/15.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "DiagnoseController.h"

@interface DiagnoseController ()<TBarViewDelegate>
{
    TBarView *tbarView;

}
@property (nonatomic,strong) DiagController *oneVC;
@property (nonatomic,strong) FreezeViewController *twoVC;
@property (nonatomic,strong) ReadinessViewController *ThreeVc;
@property (nonatomic,strong) ReportViewController *FourVc;
@property (nonatomic ,strong) UIViewController *currentVC;
@end

@implementation DiagnoseController

- (void)viewDidLoad {
    [super viewDidLoad];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth , 49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_normal",@"freeze_normal",@"readiness_normal",@"report_normal", nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_highLight",@"Freeze_highlight",@"readiness_highLight",@"report_highLight", nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"trouble Codes",@"Freeze Frame",@"Readiness Test",@"Report", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    
    [self.view addSubview:tbarView];
    
    [self initNavBarTitle:@"Diagnostics" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];

    self.oneVC = [[DiagController alloc] init];
    [self.oneVC.view setFrame:CGRectMake(0, 0, MSWidth, MSHeight-tbarView.frame.size.height)];
    [self addChildViewController:_oneVC];
    
    self.twoVC = [[FreezeViewController alloc] init];
    [self.twoVC.view setFrame:CGRectMake(0, 0, MSWidth, MSHeight-tbarView.frame.size.height-TopHigh)];
    
    self.ThreeVc = [[ReadinessViewController alloc] init];
    [self.ThreeVc.view setFrame:CGRectMake(0, 0, MSWidth, MSHeight-tbarView.frame.size.height-TopHigh)];
    
    self.FourVc = [[ReportViewController alloc] init];
    [self.FourVc.view setFrame:CGRectMake(0, 0, MSWidth, MSHeight-tbarView.frame.size.height-TopHigh)];
    
    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.oneVC.view];
    self.currentVC = self.oneVC;
}

#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (isLandscape) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
    }else{
        DLog(@"竖屏");
        [self setVerticalFrame];
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth , 49);
    }
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth , 49);
    }
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
//    [self save];
    DLog(@"按钮%ld",touchSelectNumber);
    switch (touchSelectNumber) {
        case 0:
        {
            //            tbarView.isSelectNumber = 0;
            return;
        }
            break;
        case 1:
        {
            //            tbarView.isSelectNumber = 1;
            [self replaceController:self.currentVC newController:self.twoVC];
        }
            break;
        case 2:
        {
            //            tbarView.isSelectNumber = 2;
            [self replaceController:self.currentVC newController:self.ThreeVc];
            
        }
            break;
        case 3:
        {
            //            tbarView.isSelectNumber = 3;
            [self replaceController:self.currentVC newController:self.FourVc];
            
        }
            break;
        default:
            break;
    }
    //    selectVC =  tbarView.isSelectNumber;
}
//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}

@end
