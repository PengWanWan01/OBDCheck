//
//  DashboardController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardController.h"
#define baseViewWidth  (MSWidth)/2 - 30
#define baseViewHeight  baseViewWidth
static dispatch_source_t _timer;
@interface DashboardController ()<UIScrollViewDelegate,selectStyleDelegete,touchMoveDelegate,StyleBtouchMoveDelegate,StyleCtouchMoveDelegate>
{
    
    editDashboardsView *editview;
    UIScrollView *scrollView;
    UIPageControl *pageControl ;
    DashboardView *dashboardStyleAView;
    DashboardViewStyleB *dashboardStyleBView;
    DashboardViewStyleC *dashboardStyleCView;
    CGFloat diameterPercent;
    CGFloat  LeftPercent;
    CGFloat  TopPercent;
   NSInteger DashBoardTag; //仪表的Tag标志
    UIView *coverView;  //遮盖层
    UILabel *contentLabel; //提示当前是有Label
    
}
@property (nonatomic,strong) NSMutableArray *LabelNameArray;
@property (nonatomic,strong) NSMutableArray *numberArray;

@end

@implementation DashboardController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;//竖屏
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
    [self updateView];
    [self startAnimation];
  
    NSArray* pAll = [DashboardA bg_findAll];
    for (DashboardA *dash in pAll) {
        NSLog(@"煮建%@",dash.ID);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)isFristLoadDashboard{
    NSLog(@"isFristLoadDashboard");
    [self isFristLoadDashboardA];
    [self isFristLoadDashboardB];
    [self isFristLoadDashboardC];

    NSArray* pAlltest = [DashboardA bg_findAll];
    for (DashboardA *dash in pAlltest) {
        NSLog(@"煮建%@",dash.orignwidth);
    }
    [[DashboardSetting sharedInstance].defaults setInteger:0 forKey:@"AddDashboardNumber"];
    
}
- (void)isFristLoadDashboardC{
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
        dashboardStyleCView  = [[DashboardViewStyleC alloc] initWithFrame:CGRectMake(index * (space+ 150*KFontmultiple)+25,  page  * (baseViewHeight + 40)+10, 150*KFontmultiple, 150*KFontmultiple)];
          [ self updatemodel:3 OrignX:dashboardStyleCView.frame.origin.x OrignY:dashboardStyleCView.frame.origin.y Width:dashboardStyleCView.frame.size.width Height:dashboardStyleCView.frame.size.height ID:i+1];
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+30, 220, 220)];
          [ self updatemodel:3 OrignX:dashboardStyleCView.frame.origin.x OrignY:dashboardStyleCView.frame.origin.y Width:dashboardStyleCView.frame.size.width Height:dashboardStyleCView.frame.size.height ID:i+7];
    }
    dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth*2+(MSWidth- 300)/2,  88,300, 300)];
    [ self updatemodel:3 OrignX:dashboardStyleCView.frame.origin.x OrignY:dashboardStyleCView.frame.origin.y Width:dashboardStyleCView.frame.size.width Height:dashboardStyleCView.frame.size.height ID:9];
}
- (void)isFristLoadDashboardB{
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
        dashboardStyleBView  = [[DashboardViewStyleB alloc] initWithFrame:CGRectMake(index * (space+ 150*KFontmultiple)+25,  page  * (baseViewHeight + 40)+20, 150*KFontmultiple, 150*KFontmultiple )];
        [ self updatemodel:2 OrignX:dashboardStyleBView.frame.origin.x OrignY:dashboardStyleBView.frame.origin.y Width:dashboardStyleBView.frame.size.width Height:dashboardStyleBView.frame.size.height ID:i+1];
        
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+30, 220, 220)];
      [ self updatemodel:2 OrignX:dashboardStyleBView.frame.origin.x OrignY:dashboardStyleBView.frame.origin.y Width:dashboardStyleBView.frame.size.width Height:dashboardStyleBView.frame.size.height ID:7+i];
    }
    
    dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth*2+(MSWidth- 300)/2,  88,300, 300)];
    [ self updatemodel:2 OrignX:dashboardStyleBView.frame.origin.x OrignY:dashboardStyleBView.frame.origin.y Width:dashboardStyleBView.frame.size.width Height:dashboardStyleBView.frame.size.height ID:9];

}
- (void)isFristLoadDashboardA{
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
        dashboardStyleAView  = [[DashboardView alloc] initWithFrame:CGRectMake(index * (space+ 150*KFontmultiple)+25,  page  * (baseViewHeight + 40)+10, 150*KFontmultiple, 150*KFontmultiple +20)];
      [ self updatemodel:1 OrignX:dashboardStyleAView.frame.origin.x OrignY:dashboardStyleAView.frame.origin.y Width:dashboardStyleAView.frame.size.width Height:dashboardStyleAView.frame.size.height ID:i+1];
    }
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleAView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+30, 220, 220+20)];
       [ self updatemodel:1 OrignX:dashboardStyleAView.frame.origin.x OrignY:dashboardStyleAView.frame.origin.y Width:dashboardStyleAView.frame.size.width Height:dashboardStyleAView.frame.size.height ID:i+7];
        
    }
    dashboardStyleAView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth*2+(MSWidth- 300)/2, 88,300, 300+20)];
     [ self updatemodel:1 OrignX:dashboardStyleAView.frame.origin.x OrignY:dashboardStyleAView.frame.origin.y Width:dashboardStyleAView.frame.size.width Height:dashboardStyleAView.frame.size.height ID:9];
   }
- (void)updatemodel:(NSInteger )modeltype OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(CGFloat)id{
    NSString *orignxsql = [NSString stringWithFormat:@"SET orignx = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:orignx], [NSNumber numberWithFloat:id]];

    NSString *orignysql = [NSString stringWithFormat:@"SET origny = '%@' WHERE  ID = %@",[NSNumber numberWithFloat: origny ], [NSNumber numberWithFloat:id]];
    
    NSString *orignwidthsql = [NSString stringWithFormat:@"SET orignwidth = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:width], [NSNumber numberWithFloat:id]];
    
    NSString *orignheightsql = [NSString stringWithFormat:@"SET orignheight = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:height], [NSNumber numberWithFloat:id]];
    
    NSString *Customorignxsql = [NSString stringWithFormat:@"SET dashboardA->orignx = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:orignx], [NSNumber numberWithFloat:id]];
    
    NSString *Customorignysql = [NSString stringWithFormat:@"SET dashboardA->origny = '%@' WHERE  ID = %@",[NSNumber numberWithFloat: origny ], [NSNumber numberWithFloat:id]];
    
    NSString *Customorignwidthsql = [NSString stringWithFormat:@"SET dashboardA->orignwidth = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:width], [NSNumber numberWithFloat:id]];
    
    NSString *Customorignheightsql = [NSString stringWithFormat:@"SET dashboardA->orignheight = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:height], [NSNumber numberWithFloat:id]];
    
    bg_setDebug(YES);
    switch (modeltype) {
        case 1:
        {
            //设置自定义仪表盘
            [CustomDashboard bg_updateSet:Customorignxsql];
            [CustomDashboard bg_updateSet:Customorignysql];
            [CustomDashboard bg_updateSet:Customorignwidthsql];
            [CustomDashboard bg_updateSet:Customorignheightsql];

        }
            break;
        case 2:
        {
           
        }
            break;
        case 3:
        {
          
        }
            break;
        default:
            break;
    }
//
}
- (void)startAnimation{
    NSTimeInterval period = 1; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimationView];
        });
    });
    
    // 开启定时器
    dispatch_resume(_timer);
    
    
}
- (void)startAnimationView{
    //    NSInteger current = pageControl.currentPage;
    [self initWithData];
    //自定义模式
    for (int i = 0; i<_numberArray.count; i++) {
        if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
            dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:i+1];
            dashboardStyleAView.numberLabel.text = _numberArray[i];
            
            NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleAViewTag",_numberArray[i],@"StyleAViewnumber", nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
        }else{
        switch ([DashboardSetting sharedInstance].dashboardStyle) {
            case DashboardStyleOne:
            {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:i+1];
                dashboardStyleAView.numberLabel.text = _numberArray[i];
              
                 NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleAViewTag",_numberArray[i],@"StyleAViewnumber", nil];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];

            }
                break;
            case DashboardStyleTwo:
            {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:i+1];
                dashboardStyleBView.NumberLabel.text = _numberArray[i];
                NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleBViewTag",_numberArray[i],@"StyleBViewnumber", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"StyleBupdateNumber" object:nil userInfo:dict];
            }
                break;
            case DashboardStyleThree:
            {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:i+1];
                dashboardStyleCView.NumberLabel.text = _numberArray[i];
            }
                break;
            default:
                break;
        }
        
    }
    }
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

}
- (void)initWithData{
    _LabelNameArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];

    self.numberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
    
    if ([[DashboardSetting sharedInstance].defaults integerForKey:@"AddDashboardNumber"] > 0) {
        for (int i = 1; i<=[[DashboardSetting sharedInstance].defaults integerForKey:@"AddDashboardNumber"]; i++) {
            [_LabelNameArray addObject:@"add"];
            [self.numberArray  addObject:@"12"];
        }
    }
  
    for (int i = 0; i<_numberArray.count; i++) {
        [_numberArray  replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
    }
    
}
- (void)initWithUI{
    switch ([DashboardSetting sharedInstance].dashboardMode) {
        case DashboardClassicMode:
        {
            [DashboardSetting sharedInstance].KPageNumer = 3;
        }
            break;
        case DashboardCustomMode:
        {
            [DashboardSetting sharedInstance].KPageNumer = 4;
        }
            break;
    
        default:
            break;
    }
    //创建滚动视图
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight)];
    scrollView.contentSize = CGSizeMake(MSWidth*[DashboardSetting sharedInstance].KPageNumer,0);
     scrollView.pagingEnabled = YES;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewtap)] ];
    [self.view addSubview:scrollView];
    //  添加页数控制视图 new = alloc + init
    pageControl = [UIPageControl new
                                  ];
    //不要加到滚动视图中， 会随着滚动消失掉
    [self.view addSubview:pageControl];
    //    设置常用属性,距离屏幕下方60像素。
    pageControl.frame = CGRectMake(0, MSHeight- 100, MSWidth, 30);
    //    设置圆点的个数
    pageControl.numberOfPages = [DashboardSetting sharedInstance].KPageNumer;
    //    设置没有被选中时圆点的颜色
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    //    设置选中时圆点的颜色
    pageControl.currentPageIndicatorTintColor = [ColorTools colorWithHexString:@"#FE9002"];
    //    关闭分页控件的用户交互功能
    pageControl.userInteractionEnabled = NO;
    // 为了检测滚动视图的偏移量，引入代理
    scrollView.delegate = self;
    pageControl.tag = 1000;
//第一页的仪表盘
    NSUserDefaults *test = [NSUserDefaults standardUserDefaults];
    if ((![test valueForKey:@"test"])) {
        [test setValue:@"sd" forKey:@"test"];
        [self isFristLoadDashboard];
    }
    [self LoadUI];


}
- (void)LoadUI{
    //判断仪表盘模式：
    if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
        NSArray* pAll = [CustomDashboard bg_findAll];
        for (CustomDashboard *dash in pAll) {
            NSLog(@"总共%@,自定义orignx=%f",dash.ID, [dash.dashboardA.orignx floatValue] );
            dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.dashboardA.orignx floatValue], [dash.dashboardA.origny floatValue], [dash.dashboardA.orignwidth floatValue], [dash.dashboardA.orignheight floatValue])];
            dashboardStyleAView.tag = [dash.ID integerValue];
            DashBoardTag = dashboardStyleAView.tag ;
            [scrollView addSubview:dashboardStyleAView];
            [self initWithChangeStyleA:dashboardStyleAView : dashboardStyleAView.tag -1] ;
        }
    }else{
        switch ([DashboardSetting sharedInstance].dashboardStyle) {
            case DashboardStyleOne:
            {
                [self initWithStyleA];
            }
                break;
            case DashboardStyleTwo:
            {
                [self initWithStyleB];
            }
                break;
            case DashboardStyleThree:
            {
                [self initWithStyleC];
            }
                break;
            default:
                break;
        }
    }
    
    if ([DashboardSetting sharedInstance].isDashboardRemove == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Display" message:@"Are you sure you want to remove this item?" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            [DashboardSetting sharedInstance].isDashboardRemove = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self RemoveDisplay];
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
}
- (void)back{
    // 关闭定时器
    dispatch_source_cancel(_timer);
       [editview hide];
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
    DashBoardTag = 0;
   

            NSArray* pAll = [DashboardA bg_findAll];
            for (DashboardA *dash in pAll) {
                NSLog(@"总共%@,orignx=%f",dash.ID, [dash.orignx floatValue]);
                dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.orignx floatValue], [dash.origny floatValue], [dash.orignwidth floatValue], [dash.orignheight floatValue])];
                dashboardStyleAView.tag = [dash.ID integerValue];
                DashBoardTag = dashboardStyleAView.tag ;
                [scrollView addSubview:dashboardStyleAView];
                [self initWithChangeStyleA:dashboardStyleAView : dashboardStyleAView.tag -1] ;
            
            }

  
}
- (void)initWithChangeStyleA:(DashboardView *)view :(NSInteger)index{
    [self initWithData];
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: view.tag]];
    NSArray* pAll = [DashboardA bg_findWhere:findsql];
    for(DashboardA* dashboard in pAll){
        
        if ([dashboard.ID integerValue] == view.tag) {
            NSLog(@"%ld -- %ld",(long)[dashboard.ID integerValue],(long)view.tag);
            NSLog(@"orignwidth%f",[dashboard.orignwidth floatValue]);
            //画底盘渐变色
            [dashboardStyleAView addGradientView:dashboard.outerColor  GradientViewWidth:view.frame.size.width];
            [dashboardStyleAView initWithModel:dashboard];
            dashboardStyleAView.infoLabel.text = _LabelNameArray[[dashboard.ID integerValue] - 1];
            dashboardStyleAView.numberLabel.text = _numberArray[[dashboard.ID integerValue] - 1];
        }
    }
    dashboardStyleAView.delegate = self;
 
    
//    //让仪表盘到最前面
//    if ([DashboardSetting sharedInstance].Dashboardindex == view.tag &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
//        NSLog(@"dddd%ld",view.tag);
//      dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:view.tag];
//        [scrollView bringSubviewToFront:dashboardStyleAView];
//        [DashboardSetting sharedInstance].isDashboardFont = NO;
//        
//    }
    
    [self MoveDashboard:(long)view.tag];
   

}

- (void)initWithStyleB{
    DashBoardTag = 0;
    NSArray* pAll = [DashboardB bg_findAll];
    for (DashboardB *dash in pAll) {
        NSLog(@"总共%@",dash.ID);
        NSLog(@"_LabelNameArray%@",_LabelNameArray);
        
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.orignx floatValue], [dash.origny floatValue], [dash.orignwidth floatValue], [dash.orignheight floatValue])];
        dashboardStyleBView.tag = [dash.ID integerValue];
        DashBoardTag = dashboardStyleBView.tag ;
        [scrollView addSubview:dashboardStyleBView];
        [self initWithChangeStyleB:dashboardStyleBView : dashboardStyleBView.tag -1] ;
    }
   
}
- (void)initWithChangeStyleB:(DashboardViewStyleB *)view :(NSInteger)index{
    [self initWithData];
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: view.tag]];
    NSArray* pAll = [DashboardB bg_findWhere:findsql];
    for(DashboardB* dashboard in pAll){
        NSLog(@"dashboard.StartAngle %@",dashboard.backColor  );//            NSLog(@"StartAnglev%f",[dashboard.testStartAngle floatValue]);
      [view initWithModel:dashboard];
        
    }
    view.delegate = self;
    //StyleB
  
    dashboardStyleBView.PIDLabel.text = _LabelNameArray[index];
    dashboardStyleBView.NumberLabel.text = _numberArray[index];
    dashboardStyleBView.delegate = self;
    //
       [scrollView addSubview:dashboardStyleBView];
    dashboardStyleBView.delegate = self;
    
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"dddd");
        [scrollView bringSubviewToFront:dashboardStyleBView];
        
        [DashboardSetting sharedInstance].isDashboardFont = NO;
        
    }
    
    [self MoveDashboard:(long)view.tag];
}

- (void)initWithStyleC{
    DashBoardTag = 0;
    NSArray* pAll = [DashboardC bg_findAll];
    for (DashboardC *dash in pAll) {
        NSLog(@"总共%@",dash.ID);
        NSLog(@"_LabelNameArray%@",_LabelNameArray);
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.orignx floatValue], [dash.origny floatValue], [dash.orignwidth floatValue], [dash.orignheight floatValue])];
        dashboardStyleCView.tag = [dash.ID integerValue];
        DashBoardTag = dashboardStyleCView.tag ;
        [scrollView addSubview:dashboardStyleCView];
        [self initWithChangeStyleC:dashboardStyleCView : dashboardStyleCView.tag -1] ;
    }

}

- (void)initWithChangeStyleC:(DashboardViewStyleC *)view :(NSInteger)index{
    [self initWithData];
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: view.tag]];
    NSArray* pAll = [DashboardC bg_findWhere:findsql];
    for(DashboardC* dashboard in pAll){
        NSLog(@"dashboard.StartAngle %@",dashboard.innerColor  );
        [view initWithModel:dashboard];
    view.delegate = self;
        
    }
    dashboardStyleCView.PIDLabel.text = _LabelNameArray[index];
    dashboardStyleCView.NumberLabel.text = _numberArray[index];
    
    [scrollView addSubview:dashboardStyleCView];
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"dddd");
        [scrollView bringSubviewToFront:dashboardStyleCView];
        
        [DashboardSetting sharedInstance].isDashboardFont = NO;
        
    }
   
    [self MoveDashboard:(long)view.tag];


}

//当滚动视图发生位移，就会进入下方代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
      UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:1000];
    //取得偏移量
    CGPoint point = scrollView.contentOffset;
    //根据滚动的位置来决定当前是第几页
    //可以用 round()  C语言方法进行 四舍五入操作
    NSInteger index = round(point.x/scrollView.frame.size.width);
    //设置分页控制器的当前页面
    pageControl.currentPage = index;
}

- (void)rightBarButtonClick{
    editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(85*MSWidth/375, 50, MSWidth -85*MSWidth/375 , 240)];
    editview.delegate = self;
    [editview show];
}

- (void)scrollViewtap{
    [editview hide];
}
#pragma mark 点击选择仪表盘模式和风格按钮
- (void)selectStyleBtnBetouched:(NSInteger)index{
    NSLog(@"tettet==%ld",(long)index);
    
    [editview hide];
    // 关闭定时器
    dispatch_source_cancel(_timer);
    switch (index) {
        case 1:
        {
            
            SelectModeViewController *vc = [[SelectModeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if ([DashboardSetting sharedInstance].dashboardMode == DashboardClassicMode) {
            SelectStyleViewController *vc = [[SelectStyleViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
   }
#pragma mark 点击设置列表的某一行2\3\4弹框
-(void)AlertBetouched:(NSInteger)index{
   
    switch (index) {
        case 2:
        {
           //自定义模式
              //添加一个仪表盘
                  if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
                    [self addDashboard];
                     }
        }
            break;
        case 3:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Load Default Dashboards" message:@"This will delete all of the existing dashboards and load the default set of dashboards. Do you want to continue?" preferredStyle:  UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self LoadDefaultDashboards];
            }]];
            
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
            break;
        case 4:
        {
            // 关闭定时器
            dispatch_source_cancel(_timer);
            HUDViewController *vc = [[HUDViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    
        default:
            break;
    }
  
    }
#pragma mark 捏合手势代理
- (void)pinchtap:(UIPinchGestureRecognizer *)sender OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height{

    switch ([DashboardSetting sharedInstance].dashboardStyle) {
        case DashboardStyleOne:
        {
            [self updatemodel:1 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
        }
            break;
        case DashboardStyleTwo:
        {
             [self updatemodel:2 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
        }
            break;
        case DashboardStyleThree:
        {
             [self updatemodel:3 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
        }
            break;
        default:
            break;
    }
   
}
#pragma mark 长按仪表盘的手势
- (void)tap:(UILongPressGestureRecognizer *)sender{
    NSLog(@" [sender view].tag %ld", (long)sender.view.tag);
      [DashboardSetting sharedInstance].Dashboardindex = sender.view.tag;
    NSLog(@"aaa%ld",(long)[DashboardSetting sharedInstance].Dashboardindex);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            switch ([DashboardSetting sharedInstance].dashboardMode) {
                case DashboardClassicMode:{
                    // 关闭定时器
                    dispatch_source_cancel(_timer);
                    PIDSelectViewController *vc = [[PIDSelectViewController alloc]init ];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case DashboardCustomMode:{
                    // 关闭定时器
                    dispatch_source_cancel(_timer);
                    EditDisplayViewController *vc = [[EditDisplayViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
           
        }
            break;
        case UIGestureRecognizerStateEnded:{
                 }
            break;
        default:
            break;
    }
}



#pragma mark 全部恢复默认仪表盘
- (void)LoadDefaultDashboards{
    NSLog(@"LoadLoad");
    [DashboardA bg_drop];
    [DashboardB bg_drop];
    [DashboardC bg_drop];

    [[DashboardSetting sharedInstance] initWithdashboardA];
    [[DashboardSetting sharedInstance] initWithdashboardB];
    [[DashboardSetting sharedInstance] initWithdashboardC];
    [DashboardSetting sharedInstance].KPageNumer = 3;
    [self clearAllUserDefaultsData];
    _LabelNameArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];
    
    self.numberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
    [self  updateView];
   
    
}
#pragma mark 点击移动仪表盘，让它变颜色；
- (void)MoveDashboard:(NSInteger)indexTag{
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == indexTag &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        NSLog(@"CCC");
        scrollView.scrollEnabled = NO;

        switch ([DashboardSetting sharedInstance ].dashboardStyle) {
            case DashboardStyleOne:
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleAView.frame.size.width, dashboardStyleAView.frame.size.width)];
                coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                dashboardStyleAView.userInteractionEnabled = YES;
                coverView.alpha = 0.2;
                [dashboardStyleAView addSubview:coverView];
            }
                break;
            case DashboardStyleTwo :
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleBView.frame.size.width, dashboardStyleBView.frame.size.width)];
                 dashboardStyleBView.userInteractionEnabled = YES;
                coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                 coverView.alpha = 0.2;
                [dashboardStyleBView addSubview:coverView];
            }
                break;
            case DashboardStyleThree:
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleCView.frame.size.width, dashboardStyleCView.frame.size.width)];
                dashboardStyleCView.userInteractionEnabled = YES;

                coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                coverView.alpha = 0.2;
                [dashboardStyleCView addSubview:coverView];
            }
                break;
            default:
                break;
        }
      
        
    }

}

#pragma mark 点击添加
- (void)addDashboard{
    NSLog(@"点击添加");
      [[DashboardSetting sharedInstance].defaults setInteger:[[DashboardSetting sharedInstance].defaults integerForKey:@"AddDashboardNumber"]+1 forKey:@"AddDashboardNumber"];
    switch ([DashboardSetting sharedInstance].dashboardStyle) {
        case DashboardStyleOne:
        {
             NSLog(@"点击添加one");
            dashboardStyleAView = [[DashboardView alloc ]initWithFrame:CGRectMake( pageControl.currentPage*MSWidth +(arc4random() % (int)MSWidth), (arc4random() % (int)MSHeight ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleAView.tag = ++ DashBoardTag;
            [scrollView addSubview:dashboardStyleAView];
            [self initWithChangeStyleA:dashboardStyleAView :dashboardStyleAView.tag -1];
            
//            CustomDashboard *model = [CustomDashboard new];
//            [[DashboardSetting sharedInstance]:model];
//            [self updatemodel:1 OrignX:dashboardStyleAView.frame.origin.x OrignY:dashboardStyleAView.frame.origin.y Width:dashboardStyleAView.frame.size.width Height:dashboardStyleAView.frame.size.height ID:dashboardStyleAView.tag];
//            
           
         
        }
            break;
        case DashboardStyleTwo:
        {
            dashboardStyleBView = [[DashboardViewStyleB alloc ]initWithFrame:CGRectMake( pageControl.currentPage*MSWidth+(arc4random() % (int)MSWidth), (arc4random() % (int)MSHeight ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleBView.tag = ++ DashBoardTag;
            DashboardB *model = [DashboardB new];
            [[DashboardSetting sharedInstance]initADDdashboardB:model];
            [self updatemodel:2 OrignX:dashboardStyleBView.frame.origin.x OrignY:dashboardStyleBView.frame.origin.y Width:dashboardStyleBView.frame.size.width Height:dashboardStyleBView.frame.size.height ID:dashboardStyleAView.tag];
            [scrollView addSubview:dashboardStyleBView];
            [self initWithChangeStyleB:dashboardStyleBView :dashboardStyleBView.tag-1 ];
           
        }
            break;
        case DashboardStyleThree:
        {
            dashboardStyleCView = [[DashboardViewStyleC alloc ]initWithFrame:CGRectMake( pageControl.currentPage*MSWidth +(arc4random() % (int)MSWidth), (arc4random() % (int)MSHeight ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleCView.tag = ++ DashBoardTag;
            DashboardC *model = [DashboardC new];
            [[DashboardSetting sharedInstance]initADDdashboardC:model];
             [self updatemodel:3 OrignX:dashboardStyleCView.frame.origin.x OrignY:dashboardStyleCView.frame.origin.y Width:dashboardStyleCView.frame.size.width Height:dashboardStyleCView.frame.size.height ID:dashboardStyleCView.tag];
            [scrollView addSubview:dashboardStyleCView];
            [self initWithChangeStyleC:dashboardStyleCView :dashboardStyleCView.tag -1];
        }
            break;
            
        default:
            break;
    }

}
#pragma mark 点击移除
- (void)RemoveDisplay{

//    
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
    switch ([DashboardSetting sharedInstance].dashboardStyle) {
        case DashboardStyleOne:
        {
            dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            NSString *SQL = [NSString stringWithFormat:@"where ID=%@",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardA bg_deleteWhere:SQL];
            [dashboardStyleAView removeFromSuperview];
        }
            break;
        case DashboardStyleTwo:
        {
            dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            NSString *SQL = [NSString stringWithFormat:@"where ID=%@",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardB bg_deleteWhere:SQL];
            [dashboardStyleBView removeFromSuperview];
        }
            break;
        case DashboardStyleThree:
        {
            dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            NSString *SQL = [NSString stringWithFormat:@"where ID=%@",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardC bg_deleteWhere:SQL];
            [dashboardStyleCView removeFromSuperview];
        }
            break;
        default:
            break;
    }
}
#pragma mark 更新最新的仪表盘
- (void)updateView{
     NSInteger current = pageControl.currentPage;
    [pageControl removeFromSuperview];
    [scrollView removeFromSuperview];
      [self initWithData];
    [self initWithUI];
     scrollView.contentOffset = CGPointMake(current*MSWidth, 0);
}
#pragma mark 移动代理
- (void)touchMoveWithcenterX:(CGFloat)centerX WithcenterY:(CGFloat)WithcenterY{
       scrollView.scrollEnabled = YES;
        [DashboardSetting sharedInstance].isDashboardMove = NO;
      switch ([DashboardSetting sharedInstance].dashboardStyle ) {
        case DashboardStyleOne:
        {
            bg_setDebug(YES);
            NSString *orignxsql = [NSString stringWithFormat:@"SET orignx = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:centerX] , [NSNumber numberWithFloat:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardA bg_updateSet:orignxsql];
            NSString *orignysql = [NSString stringWithFormat:@"SET origny = '%@' WHERE  ID = %@",[NSNumber numberWithFloat: WithcenterY] , [NSNumber numberWithFloat:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardA bg_updateSet:orignysql];
            
           
            
            [coverView removeFromSuperview];
        }
            break;
        case DashboardStyleTwo:
        {
            DashboardViewStyleB  *view = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            scrollView.scrollEnabled = YES;
            NSInteger PageNumber = view.frame.origin.x / MSWidth;
            NSString *orignxsql = [NSString stringWithFormat:@"SET orignx = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:view.frame.origin.x  - PageNumber*MSWidth] , [NSNumber numberWithFloat:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardA bg_updateSet:orignxsql];
            NSString *orignysql = [NSString stringWithFormat:@"SET origny = '%@' WHERE  ID = %@",[NSNumber numberWithFloat: view.frame.origin.y] , [NSNumber numberWithFloat:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardA bg_updateSet:orignysql];
            [coverView removeFromSuperview];
        }
            break;
        case DashboardStyleThree:
        {
            DashboardViewStyleC  *view = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            scrollView.scrollEnabled = YES;
            NSInteger PageNumber = view.frame.origin.x / MSWidth;
            NSString *orignxsql = [NSString stringWithFormat:@"SET orignx = '%@' WHERE  ID = %@",[NSNumber numberWithFloat:view.frame.origin.x  - PageNumber*MSWidth] , [NSNumber numberWithFloat:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardC bg_updateSet:orignxsql];
            NSString *orignysql = [NSString stringWithFormat:@"SET origny = '%@' WHERE  ID = %@",[NSNumber numberWithFloat: view.frame.origin.y] , [NSNumber numberWithFloat:[DashboardSetting sharedInstance].Dashboardindex]];
            [DashboardC bg_updateSet:orignysql];
            

            [coverView removeFromSuperview];
        }
            break;
        default:
            break;
    }
    

}
#pragma mark 颜色转化
- (NSString *)hexFromUIColor:(UIColor *)color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

- (void)clearAllUserDefaultsData
{
    [DashboardSetting sharedInstance].dashboardMode = DashboardCustomMode;
     [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleOne;
     [DashboardSetting sharedInstance].numberDecimals = NumberDecimalZero;
     [DashboardSetting sharedInstance].multiplierType = MultiplierType1;
     [DashboardSetting sharedInstance].hudModeType = HUDModeTypeToNormal;
     [DashboardSetting sharedInstance].KPageNumer = 3;
     [DashboardSetting sharedInstance].isDashboardRemove = NO;
    [self isFristLoadDashboard];
}
#pragma mark 指针旋转角度
- (void)rotationWithStartAngle:(CGFloat)StartAngle{
    CGPoint oldOrigin = dashboardStyleAView.triangleView.frame.origin;
    dashboardStyleAView.triangleView.layer.anchorPoint = CGPointMake(0.5, 0);
    CGPoint newOrigin = dashboardStyleAView.triangleView.layer.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    dashboardStyleAView.triangleView.center = CGPointMake (dashboardStyleAView.triangleView.center.x - transition.x, dashboardStyleAView.triangleView.center.y - transition.y);
    //    aaView.transform = CGAffineTransformMakeRotation(M_PI * 0.15 );
    CABasicAnimation *animation = [CABasicAnimation new];
    // 设置动画要改变的属性
    animation.keyPath = @"transform.rotation.z";
    //animation.fromValue = @(_bgImgV.layer.transform.m11);
    // 动画的最终属性的值（）
    animation.toValue = @(StartAngle);
    // 动画的播放时间
    animation.duration = 1;
    // 动画效果慢进慢出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 解决动画结束后回到原始状态的问题
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 将动画添加到视图bgImgV的layer上
    [dashboardStyleAView.triangleView.layer addAnimation:animation forKey:@"rotation"];
    
    
}
@end
