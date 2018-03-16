//
//  LogsViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/3/16.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "LogsViewController.h"

@interface LogsViewController ()<TBarViewDelegate>
{
    TBarView *tbarView;
}
@property (nonatomic,strong) LogsController *oneVC;
@property (nonatomic,strong) TripsViewController *twoVC;
@property (nonatomic,strong) FilesViewController *ThreeVc;
@property (nonatomic ,strong) UIViewController *currentVC;
@end

@implementation LogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBarTitle:@"Logs" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 3;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_normal",@"trips_normal",@"file_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_highlight",@"trips_highlight",@"file_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Graphs",@"Trips",@"Files", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];
    
    self.oneVC = [[LogsController alloc] init];
    [self.oneVC.view setFrame:CGRectMake(0, 0, MSWidth, MSHeight-tbarView.frame.size.height)];
    [self addChildViewController:_oneVC];
    
    self.twoVC = [[TripsViewController alloc] init];
    [self.twoVC.view setFrame:CGRectMake(0, 0, MSWidth, MSHeight-tbarView.frame.size.height-TopHigh)];
    
    self.ThreeVc = [[FilesViewController alloc] init];
    [self.ThreeVc.view setFrame:CGRectMake(0, 0, MSWidth, MSHeight-tbarView.frame.size.height-TopHigh)];
    
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
    if ((self.currentVC == self.oneVC &&touchSelectNumber == 100)||(self.currentVC == self.twoVC && touchSelectNumber == 101)||(self.currentVC == self.ThreeVc && touchSelectNumber == 102)) {
        return;
    }else{
        switch (touchSelectNumber-100) {
            case 0:
            {
                [self replaceController:self.currentVC newController:self.oneVC];
                return;
            }
                break;
            case 1:
            {
                [self replaceController:self.currentVC newController:self.twoVC];
            }
                break;
            case 2:
            {
                [self replaceController:self.currentVC newController:self.ThreeVc];
                
            }
                break;
            default:
                break;
        }
    }
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
