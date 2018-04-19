//
//  MonTabberController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/1/20.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "MonTabberController.h"

@interface MonTabberController ()<TBarViewDelegate>
{
    TBarView *tbarView;
    NSInteger selectVC;
    NSMutableDictionary *listDic;
}
@property (nonatomic,strong) MonController *oneVc;
@property (nonatomic,strong) Sensors2ViewController *twoVC;
@property (nonatomic,strong) Mode06ViewController *ThreeVc;
@property (nonatomic,strong) Mode09ViewController *FourVc;
@end

@implementation MonTabberController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Montiors" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
        DLog(@"yes");
  [self controllerForSegIndex:0];

        [self reloadControlleView:0];
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];

}
- (void)initWithUI{
//
//    listDic = [[NSMutableDictionary alloc]init];
//
//    [self reloadControlleView:0];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 0;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_normal",@"Sensor_normal",@"Mode06_normal",@"Mode09_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_highlight",@"Sensor_highlight",@"Mode06_highlight",@"Mode09_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Monitor Tests",@"O2 Sensors",@"Mode $06",@"Mode $09", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];

}
//根据字典中是否存在相关页面对应的key，没有的话存储
- (UIViewController *)controllerForSegIndex:(NSUInteger)segIndex {
    NSString *keyName = [NSString stringWithFormat:@"VC_%ld",(unsigned long)segIndex];
    
    UIViewController *controller = (UIViewController *)[listDic objectForKey:keyName];
    
    if (!controller) {
        if (segIndex == 0) {//申请
            controller = self.oneVc;
            
        }else if (segIndex == 1) {//待办
            controller = self.twoVC;
        }
        else if (segIndex == 2) {//待办
            controller = self.ThreeVc;
        }
        else if (segIndex == 3) {//待办
            controller = self.FourVc;
        }
        if(!(controller == nil)){
            [listDic setObject:controller forKey:keyName];
        }
    }
    
    return controller;
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    [self reloadControlleView:touchSelectNumber];
    switch (touchSelectNumber) {
        case 0:
        {
            tbarView.isSelectNumber = 0;
        }
            break;
        case 1:
        {
            tbarView.isSelectNumber = 1;
        }
            break;
        case 2:
        {
            tbarView.isSelectNumber = 2;
        }
            break;
        case 3:
        {
            tbarView.isSelectNumber = 3;
        }
            break;
        default:
            break;
    }
    selectVC =  tbarView.isSelectNumber;
}
- (void)reloadControlleView:(NSInteger)VCindex{
    DLog(@"%ld",(long)VCindex);
    [_oneVc.view   removeFromSuperview];
    [_twoVC.view removeFromSuperview];
    [_ThreeVc.view removeFromSuperview];
    [_FourVc.view removeFromSuperview];
    UIViewController *controller = [self controllerForSegIndex:VCindex];
    [self.view addSubview:controller.view];
    [tbarView removeFromSuperview];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = selectVC;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_normal",@"Sensor_normal",@"Mode06_normal",@"Mode09_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_highlight",@"Sensor_highlight",@"Mode06_highlight",@"Mode09_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Monitor Tests",@"O2 Sensors",@"Mode $06",@"Mode $09", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];
}
-(MonController *)oneVC{
    if (_oneVc == nil) {
        _oneVc = [[MonController alloc] init];
    }
    return _oneVc;
}


-(Sensors2ViewController *)twoVC{
    if (_twoVC == nil) {
        _twoVC = [[Sensors2ViewController alloc] init];
    }
    return _twoVC;
}
-(Mode06ViewController *)ThreeVc{
    if (_ThreeVc == nil) {
        _ThreeVc = [[Mode06ViewController alloc] init];
    }
    return _ThreeVc;
}
-(Mode09ViewController *)FourVc{
    if (_FourVc == nil) {
        _FourVc = [[Mode09ViewController alloc] init];
    }
    return _FourVc;
}
@end
