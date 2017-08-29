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
@interface DashboardController ()<UIScrollViewDelegate,selectStyleDelegete,touchMoveDelegate,StyleBtouchMoveDelegate,StyleCtouchMoveDelegate>
{
    NSTimer *timer;
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self addTimer];
   
    
}
#pragma mark 增加定时器，数据发生改变
-(void)addTimer{
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestupdate) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark 解决定时器失效的问题
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [timer invalidate];
    timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestupdate) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

}
- (void)initWithData{
    _LabelNameArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];

    self.numberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
    
    if ([DashboardSetting sharedInstance].AddDashboardNumber > 0) {
        for (int i = 1; i<=[DashboardSetting sharedInstance].AddDashboardNumber; i++) {
            [_LabelNameArray addObject:@"add"];
            [self.numberArray  addObject:@"12"];
        }
    }
  
    
}
- (void)initWithUI{
    
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
   
        switch ([DashboardSetting sharedInstance].dashboardStyle) {
            case DashboardStyleOne:
            {
                [self initWithStyleA];
//                [self clearAllUserDefaultsData];
            }
                break;
            case DashboardStyleTwo:
            {
              [self initWithStyleB];
//                [self clearAllUserDefaultsData];
            }
                break;
            case DashboardStyleThree:
            {
                [self initWithStyleC];
//                [self clearAllUserDefaultsData];
                          }
                break;
            default:
                break;
}
    if ([DashboardSetting sharedInstance].isDashboardRemove == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Display" message:@"Are you sure you want to remove this item?" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self RemoveDisplay];
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
   

    

}
- (void)back{
    [editview hide];
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 更新数据
- (void)requestupdate{
    // 改变数组数据
    switch ([DashboardSetting sharedInstance].dashboardStyle) {
        case DashboardStyleOne:
        {
            for (int i = 0; i<_numberArray.count; i++) {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:i+1];
                [dashboardStyleAView removeFromSuperview];
                [_numberArray  replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
            }
            [self initWithStyleA];
        }
            break;
        case DashboardStyleTwo:
        {
            for (int i = 0; i<_numberArray.count; i++) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:i+1];
                [dashboardStyleBView removeFromSuperview];
                [_numberArray  replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
            }
            [self initWithStyleB];
        }
            break;
        case DashboardStyleThree:
        {
            for (int i = 0; i<_numberArray.count; i++) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:i+1];
                [dashboardStyleCView removeFromSuperview];
                [_numberArray  replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
            }
            [self initWithStyleC];
        }
            break;
        default:
            break;
    }
    

}
#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
    DashBoardTag = 0;
        for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
            CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
        dashboardStyleAView  = [[DashboardView alloc] initWithFrame:CGRectMake(index * (space+ 150*KFontmultiple)+25,  page  * (baseViewHeight + 40)+10, 150*KFontmultiple, 150*KFontmultiple +20)];

            dashboardStyleAView.infoLabel.text = _LabelNameArray[i];
            dashboardStyleAView.tag = ++DashBoardTag;

            [self initWithChangeStyleA:dashboardStyleAView : dashboardStyleAView.tag -1] ;
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
       
        dashboardStyleAView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+30, 220, 220+20)];
        dashboardStyleAView.tag = ++DashBoardTag;
        [self initWithChangeStyleA:dashboardStyleAView :dashboardStyleAView.tag -1];
    }
   
    dashboardStyleAView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth*2+(MSWidth- 300)/2, 88,300, 300+20)];
    dashboardStyleAView.tag = ++DashBoardTag;
    [self initWithChangeStyleA:dashboardStyleAView :dashboardStyleAView.tag -1] ;
    //保存添加的仪表盘数据
    if ([DashboardSetting sharedInstance].AddDashboardNumber >0) {
        for (NSInteger  i= 1; i<=[DashboardSetting sharedInstance].AddDashboardNumber; i++) {
            NSLog(@"==%ld",(long)i);
            
            CGFloat diameterResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"adddiameterPercent%ld",(long)i]];
            CGFloat LeftResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addLeftPercent%ld",(long)i]];
            CGFloat TopResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addTopPercent%ld",(long)i]];
            dashboardStyleAView  = [[DashboardView alloc]initWithFrame: CGRectMake((LeftResult /100)*MSWidth, (TopResult /100)*MSHeight,(diameterResult /100)*MSWidth,(diameterResult /100)*MSWidth)];
            dashboardStyleAView.tag = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addTag%ld",(long)i]] ;
          
            DashBoardTag = dashboardStyleAView.tag ;
          [scrollView addSubview:dashboardStyleAView];
        [self initWithChangeStyleA:dashboardStyleAView :DashBoardTag - 1];
        }
     
    }
}
- (void)initWithChangeStyleA:(DashboardView *)view :(NSInteger)index{

    [scrollView addSubview:view];
    
    CGFloat    diameterResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"diameterPercent%ld",(long)view.tag]];
    CGFloat  LeftResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LeftPercent%ld",(long)view.tag]];
    CGFloat  TopResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TopPercent%ld",(long)view.tag]];
    
    CGFloat   StartAngleResult  = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StartAngle%ld",(long)view.tag]] ;
    CGFloat   endAngleResult  = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"endAngle%ld",(long)view.tag]] ;
    
    CGFloat  ringWidthResult  =     [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"ringWidth%ld",(long)view.tag]] ;
    CGFloat    maLengthResult    =    [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"maLength%ld",(long)view.tag]] ;
    CGFloat    maWidthResult   =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"maWidth%ld",(long)view.tag]];
    CGFloat    miLengthResult    =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"miLength%ld",(long)view.tag]];
    CGFloat    miWidthResult    =       [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"miWidth%ld",(long)view.tag]];
    NSString*    maColorResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"maColor%ld",(long)view.tag]] ;
    NSString*  miColorResult   =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"miColor%ld",(long)view.tag]] ;
    
    NSString*   outerColorResult   =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"outerColor%ld",(long)view.tag]] ;
    NSString*     innerColorResult   =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"innerColor%ld",(long)view.tag]] ;
    NSString*   titleColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"titleColor%ld",(long)view.tag]] ;
    CGFloat  TitleFontScaleResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TitleFontScale%ld",(long)view.tag]];
    CGFloat   TitlePositionResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TitlePosition%ld",(long)view.tag]];
    BOOL   ValueVisbleResult =  [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"ValueVisble%ld",(long)view.tag]];
    NSString*  ValueColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"ValueColor%ld",(long)view.tag]] ;
    CGFloat   ValueFontScaleResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"ValueFontScale%ld",(long)view.tag]];
    CGFloat   ValuePositionResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"ValuePosition%ld",(long)view.tag]];
    
    CGFloat   LabelFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LabelFontScale%ld",(long)view.tag]];
    CGFloat  LabelOffestResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LabelOffest%ld",(long)view.tag]];
    
    CGFloat   PointerVisbleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"PointerVisble%ld",(long)view.tag]];
    CGFloat   PointerWidthResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"PointerWidth%ld",(long)view.tag]];
    CGFloat   PointerLengthResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"PointerLength%ld",(long)view.tag]];
    NSString*  PointerColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"PointerColor%ld",(long)view.tag]] ;
    CGFloat  KNOBRadiusResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"KNOBRadius%ld",(long)view.tag]];
    NSString*   KNOBColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"KNOBColor%ld",(long)view.tag]] ;
    CGFloat  FillenabledResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"Fillenabled%ld",(long)view.tag]];
    CGFloat  FillstartAngleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"FillstartAngle%ld",(long)view.tag]];
    CGFloat   FillEndAngleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"FillEndAngle%ld",(long)view.tag]];
    NSString*    FillColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"FillColor%ld",(long)view.tag]] ;
    NSString*   UnitColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"UnitColor%ld",(long)view.tag]] ;
    CGFloat   UnitFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"UnitFontScale%ld",(long)view.tag]];
    CGFloat  UnitVerticalPositionResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"UnitVerticalPosition%ld",(long)view.tag]];
    CGFloat   UnitHorizontalPositionResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"UnitHorizontalPosition%ld",(long)view.tag]];
    NSString* infoLabeltextResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"infoLabeltext%ld",(long)view.tag]];    //画底盘渐变色
    [dashboardStyleAView addGradientView:@"#18191C" GradientViewWidth:view.frame.size.width];
       //画刻度
    [dashboardStyleAView drawCalibration:0 WithendAngle:2*M_PI WithRingWidth:10.f MAJORTICKSWidth:0 MAJORTICKSLength:15.f MAJORTICKSColor:@"FFFFFF" MINORTICKSWidth:0 MINORTICKSLength:5.f MINORTICKSColor:@"FFFFFF" LABELSVisible:YES Rotate:YES Font:1 OffestTickline:1 InnerColor:@"18191C" TitleColor:@"FE9002" TitleFontScale:1 TitlePosition:1 ValueVisble:YES ValueColor:@"FE9002" ValueFontScale:1 ValuePosition:1 UnitColor:@"FE9002" UnitFontScale:1 UnitVerticalPosition:1 UnitHorizontalPosition:1 PointerVisble:YES PointerWidth:10.f PointerLength: (view.frame.size.width/2) - 15 - 14 PointerColor:@"FE9002" KNOBRadius:10.f KNOBColor:@"FFFFFF" Fillenabled:YES FillstartAngle:0 FillEndAngle:0 FillColor:@"FE9002"];
    NSLog(@"(long)view.tag11%ld",(long)index);
    dashboardStyleAView.delegate = self;
    dashboardStyleAView.infoLabel.text = _LabelNameArray[index];
    dashboardStyleAView.numberLabel.text = _numberArray[index];
   
    //加入是被点击过的 ；让被选中的仪表盘位置发生变化
    if ([[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"change%ld",(long)dashboardStyleAView.tag]] isEqualToString:@"YES"]) {
        NSInteger TapIndex = (long)view.tag;
        NSInteger PageNumber = view.frame.origin.x / MSWidth;
        
        [view removeFromSuperview];
        dashboardStyleAView  = [[DashboardView alloc]initWithFrame: CGRectMake((LeftResult /100)*MSWidth+PageNumber*MSWidth, (TopResult /100)*MSHeight,(diameterResult /100)*MSWidth,(diameterResult/100)*MSWidth)];
        //画底盘渐变色
        [dashboardStyleAView addGradientView:outerColorResult GradientViewWidth:(diameterResult /100)*MSWidth];
        dashboardStyleAView.delegate = self;
        //画刻度
        [dashboardStyleAView drawCalibration:StartAngleResult WithendAngle:endAngleResult WithRingWidth:ringWidthResult MAJORTICKSWidth:maWidthResult MAJORTICKSLength:maLengthResult MAJORTICKSColor:maColorResult MINORTICKSWidth:miWidthResult MINORTICKSLength:miLengthResult MINORTICKSColor:miColorResult LABELSVisible:YES Rotate:YES Font:LabelFontScaleResult OffestTickline:LabelOffestResult InnerColor:innerColorResult TitleColor:titleColorResult TitleFontScale:TitleFontScaleResult TitlePosition:TitlePositionResult ValueVisble:ValueVisbleResult ValueColor:ValueColorResult ValueFontScale:ValueFontScaleResult ValuePosition:ValuePositionResult UnitColor:UnitColorResult   UnitFontScale:UnitFontScaleResult UnitVerticalPosition:UnitVerticalPositionResult UnitHorizontalPosition:UnitHorizontalPositionResult  PointerVisble:PointerVisbleResult PointerWidth:PointerWidthResult PointerLength:PointerLengthResult PointerColor:PointerColorResult KNOBRadius:KNOBRadiusResult KNOBColor:KNOBColorResult Fillenabled:FillenabledResult FillstartAngle:FillstartAngleResult   FillEndAngle:FillEndAngleResult FillColor:FillColorResult];
        dashboardStyleAView.tag = TapIndex;
        dashboardStyleAView.infoLabel.text = infoLabeltextResult;
        dashboardStyleAView.numberLabel.text = _numberArray[TapIndex - 1];

    }

    [dashboardStyleAView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    [scrollView addSubview:dashboardStyleAView];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [dashboardStyleAView addGestureRecognizer:LongPress];
    [self ReMoveDashboard:(long)view.tag];
    
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"dddd%ld",(long)index);
//      DashboardView  *view = (DashboardView *)[scrollView viewWithTag:index];
//         [[view superview] bringSubviewToFront:view];
        //该view置于最前
        [[dashboardStyleAView superview] bringSubviewToFront:dashboardStyleAView];
        [DashboardSetting sharedInstance].isDashboardFont = NO;
        
    }
    
    [self MoveDashboard:(long)view.tag];
   

}

- (void)initWithStyleB{
    DashBoardTag = 0;
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
        dashboardStyleBView  = [[DashboardViewStyleB alloc] initWithFrame:CGRectMake(index * (space+ 150*KFontmultiple)+25,  page  * (baseViewHeight + 40)+20, 150*KFontmultiple, 150*KFontmultiple )];
      
       dashboardStyleBView.tag = ++DashBoardTag;
        [self initWithChangeStyleB:dashboardStyleBView :dashboardStyleBView.tag-1 ];

    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
       
       
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+30, 220, 220)];
       dashboardStyleBView.tag = ++DashBoardTag;
        [self initWithChangeStyleB:dashboardStyleBView :dashboardStyleBView.tag -1 ];
    }
   
    dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth*2+(MSWidth- 300)/2,  88,300, 300)];
    dashboardStyleBView.tag = ++DashBoardTag;
    [self initWithChangeStyleB:dashboardStyleBView :dashboardStyleBView.tag -1 ];
    //保存添加的仪表盘数据
    if ([DashboardSetting sharedInstance].AddDashboardNumber >0) {
        for (NSInteger  i= 1; i<=[DashboardSetting sharedInstance].AddDashboardNumber; i++) {
            NSLog(@"==%ld",(long)i);
            
           CGFloat diameterResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"adddiameterPercent%ld",(long)i]];
            CGFloat LeftResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addLeftPercent%ld",(long)i]];
            CGFloat TopResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addTopPercent%ld",(long)i]];
            dashboardStyleBView  = [[DashboardViewStyleB alloc]initWithFrame: CGRectMake((LeftResult /100)*MSWidth, (TopResult /100)*MSHeight,(diameterResult /100)*MSWidth,(diameterResult /100)*MSWidth)];
           dashboardStyleBView.tag = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addTag%ld",(long)i]];
            NSLog(@"dashboardStyleA(long)view.tag) ==%f",[[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addTag%ld",(long)i]]);
            
            DashBoardTag = dashboardStyleBView.tag ;
            [scrollView addSubview:dashboardStyleBView];
            [self initWithChangeStyleB:dashboardStyleBView :dashboardStyleBView.tag -1];
        }
        
    }

}
- (void)initWithChangeStyleB:(DashboardViewStyleB *)view :(NSInteger)index{
    [scrollView addSubview:view];
    [view drawgradient:@"00a6ff" GradientRadius:1.f TitlteColor:@"#757476" TitlteFontScale:1 TitlePositon:1 ValueVisible:YES Valuecolor:@"#FFFFFF" ValueFontScale:1 ValuePositon:1 UnitColor:@"#757476" UnitFontScale:1 UnitPositon:1 PointColor:@"FFFFFF" PointWidth:5 Fillenable:YES FillColor:@"00a6ff"];
    view.delegate = self;
    //StyleB
    CGFloat diameterResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBdiameterPercent%ld",(long)view.tag]];
    CGFloat LeftResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",(long)view.tag]];
    CGFloat TopResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",(long)view.tag]];

    
   NSString *  backColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBbackColor%ld",(long)view.tag]] ;
    CGFloat GradientRaduisResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBGradientRaduis%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]] ;
  NSString *StyleBtitleColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBtitleColor%ld",(long)view.tag]] ;
    CGFloat  titleFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBtitleFontScale%ld",(long)view.tag]] ;
    CGFloat titlePositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",(long)view.tag]] ;
    BOOL ValueVisibleResult = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleBValueVisible%ld",(long)view.tag]] ;
     NSString *StyleBValueColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBValueColor%ld",(long)view.tag]] ;
 CGFloat    StyleBValueFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBValueFontScale%ld",(long)view.tag]] ;
     CGFloat ValuePositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBValuePositon%ld",(long)view.tag]] ;

    
   NSString *StyleBUnitColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBUnitColor%ld",(long)view.tag]] ;
      CGFloat    StyleBUnitFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBUnitFontScale%ld",(long)view.tag]] ;
    CGFloat UnitPositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBUnitPositon%ld",(long)view.tag]] ;
    
    
    NSString *pointerColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBpointerColor%ld",(long)view.tag]] ;
    CGFloat PointerwidthResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBPointerwidth%ld",(long)view.tag]] ;
    BOOL FillEnableResult = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleBFillEnable%ld",(long)view.tag]] ;
     NSString *StyleBFillColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBFillColor%ld",(long)view.tag]] ;
    dashboardStyleBView.PIDLabel.text = _LabelNameArray[index];
    dashboardStyleBView.NumberLabel.text = _numberArray[index];

    //
    if ([[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBchange%ld",(long)view.tag]] isEqualToString:@"YES"]) {
        NSInteger TapIndex = view.tag;
        NSInteger PageNumber = view.frame.origin.x / MSWidth;
        
        [view removeFromSuperview];
        dashboardStyleBView  = [[DashboardViewStyleB alloc]initWithFrame: CGRectMake((LeftResult /100)*MSWidth+PageNumber*MSWidth, (TopResult /100)*MSHeight,(diameterResult /100)*MSWidth,(diameterResult /100)*MSWidth)];
        dashboardStyleBView.delegate = self;
        [dashboardStyleBView drawgradient:backColorResult GradientRadius:GradientRaduisResult TitlteColor:StyleBtitleColorResult TitlteFontScale:titleFontScaleResult TitlePositon:titlePositonResult ValueVisible:ValueVisibleResult Valuecolor:StyleBValueColorResult ValueFontScale:StyleBValueFontScaleResult ValuePositon:ValuePositonResult UnitColor:StyleBUnitColorResult UnitFontScale:StyleBUnitFontScaleResult UnitPositon:UnitPositonResult PointColor:pointerColorResult PointWidth:PointerwidthResult Fillenable:FillEnableResult FillColor:StyleBFillColorResult];
        dashboardStyleBView.PIDLabel.text = _LabelNameArray[TapIndex -1];
        dashboardStyleBView.NumberLabel.text = _numberArray[TapIndex -1];
        dashboardStyleBView.tag = TapIndex;
    }
    [dashboardStyleBView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    [scrollView addSubview:dashboardStyleBView];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [dashboardStyleBView addGestureRecognizer:LongPress];
    
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"dddd");
        [scrollView bringSubviewToFront:dashboardStyleBView];
        
        [DashboardSetting sharedInstance].isDashboardFont = NO;
        
    }
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == (long)view.tag &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        NSLog(@"CCC");
        
        coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleBView.frame.size.width, dashboardStyleBView.frame.size.width)];
        coverView.backgroundColor = [UIColor colorWithRed:254/255 green:144/255 blue:2/255 alpha:0.2];
        [dashboardStyleBView addSubview:coverView];
        scrollView.scrollEnabled = NO;
        [DashboardSetting sharedInstance].isDashboardMove = NO;
        
    }
     [self MoveDashboard:(long)view.tag];
    [self ReMoveDashboard:(long)view.tag];
}

- (void)initWithStyleC{
    DashBoardTag = 0;
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
        dashboardStyleCView  = [[DashboardViewStyleC alloc] initWithFrame:CGRectMake(index * (space+ 150*KFontmultiple)+25,  page  * (baseViewHeight + 40)+10, 150*KFontmultiple, 150*KFontmultiple)];
       
        dashboardStyleCView.tag = ++DashBoardTag;
        [self initWithChangeStyleC:dashboardStyleCView :dashboardStyleCView.tag -1];
  
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+30, 220, 220)];
        dashboardStyleCView.tag = ++DashBoardTag;
        [self initWithChangeStyleC:dashboardStyleCView :dashboardStyleCView.tag -1];

    }
    dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth*2+(MSWidth- 300)/2,  88,300, 300)];
    dashboardStyleCView.tag = ++DashBoardTag;
    [self initWithChangeStyleC:dashboardStyleCView :dashboardStyleCView.tag-1];
    //保存添加的仪表盘数据
    if ([DashboardSetting sharedInstance].AddDashboardNumber >0) {
        for (NSInteger  i= 1; i<=[DashboardSetting sharedInstance].AddDashboardNumber; i++) {
            NSLog(@"==%ld",(long)i);
            
            CGFloat diameterResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"adddiameterPercent%ld",(long)i]];
           CGFloat LeftResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addLeftPercent%ld",(long)i]];
            CGFloat TopResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addTopPercent%ld",(long)i]];
            dashboardStyleCView  = [[DashboardViewStyleC alloc]initWithFrame: CGRectMake((LeftResult /100)*MSWidth, (TopResult /100)*MSHeight,(diameterResult /100)*MSWidth,(diameterResult /100)*MSWidth)];
            dashboardStyleCView.tag = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"addTag%ld",(long)i] ];
         
            
            DashBoardTag = dashboardStyleCView.tag ;
            [scrollView addSubview:dashboardStyleCView];
            [self initWithChangeStyleC:dashboardStyleCView :dashboardStyleCView.tag -1];
        }
        
    }

}
- (void)initWithChangeStyleC:(DashboardViewStyleC *)view :(NSInteger)index{
    //ColorTools colorWithHexString:@"202226"
    //黑色
    //[ColorTools colorWithHexString:@"#FFFFFF"]
    [view drawinnerColor:@"000000" OuterColor:@"202226"  Gradientradius:((view.frame.size.width)/320.f)*16.f TitleColor:@"FFFFFF" TiltefontScale:1 TitlePosition:1 ValueVisible:YES Valuecolor:@"FFFFFF" ValueFontScale:1 ValuePositon:1 UnitColor:@"FFFFFF" UnitFontScale:1 UnitPositon:1 FrameColor:@"FFFFFF" FrameScale:1];
    view.delegate = self;
   CGFloat  diameterResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCdiameterPercent%ld",(long)view.tag]];
   CGFloat  LeftResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCLeftPercent%ld",(long)view.tag]];
   CGFloat  TopResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCTopPercent%ld",(long)view.tag]];
 
NSString*   innerColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCinnerColor%ld",(long)view.tag]] ;
 NSString*    outerColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCouterColor%ld",(long)view.tag]] ;

    CGFloat GradientradiusResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCGradientradius%ld",(long)view.tag]] ;
    
 NSString*   titleColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCtitleColor%ld",(long)view.tag]] ;
    CGFloat titleFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCtitleFontScale%ld",(long)view.tag]] ;
    
  CGFloat titlePositonResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCtitlePositon%ld",(long)view.tag]] ;
    CGFloat ValueVisibleResult = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleCValueVisible%ld",(long)view.tag]] ;
 NSString*    ValueColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCValueColor%ld",(long)view.tag]] ;
    
 CGFloat    ValueFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValueFontScale%ld",(long)view.tag]] ;
    CGFloat ValuePositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValuePositon%ld",(long)view.tag]] ;
   NSString*   UnitColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCUnitColor%ld",(long)view.tag]] ;
   CGFloat  UnitFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitFontScale%ld",(long)view.tag]] ;
    
    CGFloat UnitPositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitPositon%ld",(long)view.tag]] ;
    NSString * FrameColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",(long)view.tag]] ;
    CGFloat FrameScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCFrameScale%ld",(long)view.tag]] ;
    dashboardStyleCView.PIDLabel.text = _LabelNameArray[index];
    dashboardStyleCView.NumberLabel.text = _numberArray[index];

    if ([[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCchange%ld",(long)view.tag]] isEqualToString:@"YES"]) {
        NSInteger TapIndex = (long)view.tag;
        NSInteger PageNumber = view.frame.origin.x / MSWidth;
        
        [view removeFromSuperview];
        dashboardStyleCView  = [[DashboardViewStyleC alloc]initWithFrame: CGRectMake((LeftResult /100)*MSWidth+PageNumber*MSWidth, (TopResult /100)*MSHeight,(diameterResult /100)*MSWidth,(diameterResult /100)*MSWidth)];
        dashboardStyleCView.delegate = self;
        [dashboardStyleCView drawinnerColor:innerColorResult OuterColor:outerColorResult Gradientradius:GradientradiusResult TitleColor:titleColorResult TiltefontScale:titleFontScaleResult TitlePosition:titlePositonResult ValueVisible:ValueVisibleResult Valuecolor:ValueColorResult ValueFontScale:ValueFontScaleResult ValuePositon:ValuePositonResult UnitColor:UnitColorResult UnitFontScale:UnitFontScaleResult UnitPositon:UnitPositonResult FrameColor:FrameColorResult FrameScale:FrameScaleResult];
        
        dashboardStyleCView.tag = TapIndex;
        dashboardStyleCView.PIDLabel.text = _LabelNameArray[TapIndex-1];
        dashboardStyleCView.NumberLabel.text = _numberArray[TapIndex-1];
    }
    [scrollView addSubview:dashboardStyleCView];

    [dashboardStyleCView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    [scrollView addSubview:dashboardStyleCView];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [dashboardStyleCView addGestureRecognizer:LongPress];
  
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"dddd");
        [scrollView bringSubviewToFront:dashboardStyleCView];
        
        [DashboardSetting sharedInstance].isDashboardFont = NO;
        
    }
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        NSLog(@"CCC");
        dashboardStyleCView.backgroundColor = [UIColor goldColor];
        scrollView.userInteractionEnabled = NO;
        [DashboardSetting sharedInstance].isDashboardMove = NO;
        
    }else{
        scrollView.userInteractionEnabled = YES;
    }
     [self MoveDashboard:(long)view.tag];
    [self ReMoveDashboard:(long)view.tag];

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
  
    switch ([DashboardSetting sharedInstance].dashboardMode) {
        case DashboardClassicMode:
        {
         editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(85*MSWidth/375, 50, MSWidth -85*MSWidth/375 , 376+44 - 3*44)];
        }
            break;
        case DashboardCustomMode:
        {
             editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(85*MSWidth/375, 50, MSWidth -85*MSWidth/375 , 376+44)];
        }
            break;
        default:
            break;
    }
    editview.delegate = self;
    [editview show];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击屏幕任意位置");
    [editview hide];
   
}

- (void)scrollViewtap{
    [editview hide];
}
#pragma mark 点击选择仪表盘模式和风格按钮
- (void)selectStyleBtnBetouched:(NSInteger)index{
    NSLog(@"tettet==%ld",(long)index);
    
    [editview hide];
    switch (index) {
        case 1:
        {
            SelectModeViewController *vc = [[SelectModeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            SelectStyleViewController *vc = [[SelectStyleViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
   }
#pragma mark 点击设置列表的某一行3、4、5、6、7、8弹框
-(void)AlertBetouched:(NSInteger)index{
    switch ([DashboardSetting sharedInstance].dashboardMode) {
        case DashboardCustomMode:
        {
            switch (index) {
                case 3:{
                    NSLog(@"12345");
                    switch ([DashboardSetting sharedInstance].dashboardStyle) {
                        case DashboardStyleOne:
                        {
                            [self addStyleAView];
                        }
                            break;
                        case DashboardStyleTwo:
                        {
                            [self addStyleBView];
                            
                        }
                            break;
                        case DashboardStyleThree:
                        {
                            [self addStyleCView];
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 4:{
                    //添加一页
                    [DashboardSetting sharedInstance].KPageNumer = [DashboardSetting sharedInstance].KPageNumer +1;
                    [scrollView removeFromSuperview];
                    [self updateView];
                    scrollView.contentOffset = CGPointMake(([DashboardSetting sharedInstance].KPageNumer  - 1)*MSWidth, 0);
                    
                }
                    break;
                case 5:{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Dashboard" message:@"Are you sure you want to remove this item?" preferredStyle:  UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击按钮的响应事件；
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self removeDashboard];
                    }]];
                    
                    //弹出提示框；
                    [self presentViewController:alert animated:true completion:nil];
                    
                }
                    break;
                case 6:{
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
                case 7:{
                    HUDViewController *vc = [[HUDViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                default:
                    break;
            }

        
        }
            break;
        case DashboardClassicMode:
        {
            switch (index) {
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
                case 4:{
                    HUDViewController *vc = [[HUDViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
}
#pragma mark 长按仪表盘的手势
- (void)tap:(UILongPressGestureRecognizer *)sender{
  
    NSLog(@" [sender view].tag %ld", (long)sender.view.tag);
    switch ([DashboardSetting sharedInstance].dashboardStyle) {
        case DashboardStyleOne:
        {
            [self initWithDefault:sender.view];

        }
            break;
        case DashboardStyleTwo:
        {
            [self initWithDefaultStyleB:sender.view];
            
        }
            break;
        case DashboardStyleThree:
        {
            [self initWithDefaultStyleC:sender.view];
            
        }
            break;
        default:
            break;
    }
    [DashboardSetting sharedInstance].Dashboardindex = sender.view.tag;
    
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            switch ([DashboardSetting sharedInstance].dashboardMode) {
                case DashboardClassicMode:{
                    DisplaySetViewController *vc = [[DisplaySetViewController alloc]init ];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case DashboardCustomMode:{
                    EditDisplayViewController *vc = [[EditDisplayViewController alloc]init];
                    [DashboardSetting sharedInstance].Dashboardindex =   sender.view.tag;
                    NSLog(@" [DashboardSetting sharedInstance].Dashboardindex %ld", (long)[DashboardSetting sharedInstance].Dashboardindex);
                    
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
#pragma mark 进行默认设置
- (void)initWithDefault:(UIView *)senderview{
    NSInteger PageNumber = senderview.frame.origin.x / MSWidth;
    
    diameterPercent = (senderview.frame.size.width/MSWidth)*100;
    
    LeftPercent =((senderview.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
    
    TopPercent  = ((senderview.frame.origin.y )/MSHeight)*100;
    
    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:(long)senderview.tag];
    
    [[DashboardSetting sharedInstance].defaults setFloat:diameterPercent  forKey:[NSString stringWithFormat:@"diameterPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"LeftPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"TopPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:@"YES" forKey:[NSString stringWithFormat:@"change%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];

    
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.StartAngle forKey:[NSString stringWithFormat:@"StartAngle%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.endAngle forKey:[NSString stringWithFormat:@"endAngle%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.ringWidth forKey:[NSString stringWithFormat:@"ringWidth%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.maLength forKey:[NSString stringWithFormat:@"maLength%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.maLength forKey:[NSString stringWithFormat:@"maWidth%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.miLength forKey:[NSString stringWithFormat:@"miLength%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.miWidth forKey:[NSString stringWithFormat:@"miWidth%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.maColor  forKey:[NSString stringWithFormat:@"maColor%ld",(long)senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.miColor forKey:[NSString stringWithFormat:@"miColor%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.outerColor  forKey:[NSString stringWithFormat:@"outerColor%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.innerColor forKey:[NSString stringWithFormat:@"innerColor%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.titleColor forKey:[NSString stringWithFormat:@"titleColor%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"TitleFontScale%ld",(long)senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"TitlePosition%ld",(long)senderview.tag]];
    
    
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.ValueVisble forKey:[NSString stringWithFormat:@"ValueVisble%ld",(long)senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.ValueColor forKey:[NSString stringWithFormat:@"ValueColor%ld",(long)senderview.tag]];
    
   
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"ValueFontScale%ld",(long)senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"ValuePosition%ld",(long)senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.LabelVisble forKey:[NSString stringWithFormat:@"LabelVisble%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.LabelRotate forKey:[NSString stringWithFormat:@"LabelRotate%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.LabelFontScale forKey:[NSString stringWithFormat:@"LabelFontScale%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.LabelOffest forKey:[NSString stringWithFormat:@"LabelOffest%ld",(long)senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.PointerVisble forKey:[NSString stringWithFormat:@"PointerVisble%ld",(long)senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.PointerWidth forKey:[NSString stringWithFormat:@"PointerWidth%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.PointerLength forKey:[NSString stringWithFormat:@"PointerLength%ld",(long)senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.PointerColor forKey:[NSString stringWithFormat:@"PointerColor%ld",(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.KNOBRadius forKey:[NSString stringWithFormat:@"KNOBRadius%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.KNOBColor forKey:[NSString stringWithFormat:@"KNOBColor%ld",(long)senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.Fillenabled forKey:[NSString stringWithFormat:@"Fillenabled%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.FillstartAngle forKey:[NSString stringWithFormat:@"FillstartAngle%ld",(long)senderview.tag]];
   [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.FillEndAngle forKey:[NSString stringWithFormat:@"FillEndAngle%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.FillColor forKey:[NSString stringWithFormat:@"FillColor%ld",(long)senderview.tag]] ;
      [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.infoLabel.text forKey:[NSString stringWithFormat:@"infoLabeltext%ld",(long)senderview.tag]] ;
    
    NSLog(@"FillColorv%@", [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"FillColor%ld",(long)senderview.tag]] );
    
 [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.UnitColor forKey:[NSString stringWithFormat:@"UnitColor%ld",(long)senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.UnitFontScale forKey:[NSString stringWithFormat:@"UnitFontScale%ld",(long)senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.UnitVerticalPosition forKey:[NSString stringWithFormat:@"UnitVerticalPosition%ld",(long)senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.UnitHorizontalPosition forKey:[NSString stringWithFormat:@"UnitHorizontalPosition%ld",(long)senderview.tag]];

}
- (void)initWithDefaultStyleB :(UIView *)senderview{
    NSInteger PageNumber = senderview.frame.origin.x / MSWidth;
    
    diameterPercent = (senderview.frame.size.width/MSWidth)*100;
    
    LeftPercent =((senderview.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
    
    TopPercent  = ((senderview.frame.origin.y )/MSHeight)*100;

    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:(long)senderview.tag];
    
    [[DashboardSetting sharedInstance].defaults setFloat:diameterPercent forKey:[NSString stringWithFormat:@"StyleBdiameterPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:@"YES" forKey:[NSString stringWithFormat:@"StyleBchange%ld",(long)senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.backColor forKey:[NSString stringWithFormat:@"StyleBbackColor%ld",(long)senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.GradientRadius forKey:[NSString stringWithFormat:@"StyleBGradientRaduis%ld",(long)senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.titleColor forKey:[NSString stringWithFormat:@"StyleBtitleColor%ld",(long)senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.titleFontScale forKey:[NSString stringWithFormat:@"StyleBtitleFontScale%ld",(long)senderview.tag]] ;
    
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.titlePositon forKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleBView.ValueVisible forKey:[NSString stringWithFormat:@"StyleBValueVisible%ld",(long)senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.ValueColor forKey:[NSString stringWithFormat:@"StyleBValueColor%ld",(long)senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.ValueFontScale forKey:[NSString stringWithFormat:@"StyleBValueFontScale%ld",(long)senderview.tag]] ;
  [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.ValuePositon forKey:[NSString stringWithFormat:@"StyleBValuePositon%ld",(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.titlePositon forKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",(long)senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.UnitColor forKey:[NSString stringWithFormat:@"StyleBUnitColor%ld",(long)senderview.tag]] ;
 [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.UnitFontScale forKey:[NSString stringWithFormat:@"StyleBUnitFontScale%ld",(long)senderview.tag]] ;
 [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.UnitPositon forKey:[NSString stringWithFormat:@"StyleBUnitPositon%ld",(long)senderview.tag]] ;
    
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.pointerColor forKey:[NSString stringWithFormat:@"StyleBpointerColor%ld",(long)senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.Pointerwidth forKey:[NSString stringWithFormat:@"StyleBPointerwidth%ld",(long)(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleBView.FillEnable forKey:[NSString stringWithFormat:@"StyleBFillEnable%ld",(long)(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.FillColor forKey:[NSString stringWithFormat:@"StyleBFillColor%ld",(long)(long)senderview.tag]] ;
    

}
- (void)initWithDefaultStyleC :(UIView *)senderview{
    NSInteger PageNumber = senderview.frame.origin.x / MSWidth;

    diameterPercent = (senderview.frame.size.width/MSWidth)*100;
    
    LeftPercent =((senderview.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
    
    TopPercent  = ((senderview.frame.origin.y )/MSHeight)*100;
    
   
    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:senderview.tag];
    
    [[DashboardSetting sharedInstance].defaults setFloat:diameterPercent forKey:[NSString stringWithFormat:@"StyleCdiameterPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"StyleCLeftPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"StyleCTopPercent%ld",(long)senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:@"YES" forKey:[NSString stringWithFormat:@"StyleCchange%ld",(long)senderview.tag]];
    
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.innerColor forKey:[NSString stringWithFormat:@"StyleCinnerColor%ld",(long)senderview.tag]] ;
      [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.outerColor forKey:[NSString stringWithFormat:@"StyleCouterColor%ld",(long)senderview.tag]] ;
    

      [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.Gradientradius forKey:[NSString stringWithFormat:@"StyleCGradientradius%ld",(long)senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.titleColor forKey :[NSString stringWithFormat:@"StyleCtitleColor%ld",(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.titleFontScale forKey:[NSString stringWithFormat:@"StyleCtitleFontScale%ld",(long)senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.titlePositon forKey:[NSString stringWithFormat:@"StyleCtitlePositon%ld",(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleCView.ValueVisible forKey:[NSString stringWithFormat:@"StyleCValueVisible%ld",(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.ValueColor forKey:[NSString stringWithFormat:@"StyleCValueColor%ld",(long)senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.ValueFontScale forKey:[NSString stringWithFormat:@"StyleCValueFontScale%ld",(long)senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.ValuePositon forKey:[NSString stringWithFormat:@"StyleCValuePositon%ld",(long)senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.UnitColor forKey:[NSString stringWithFormat:@"StyleCUnitColor%ld",(long)senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.UnitFontScale forKey:[NSString stringWithFormat:@"StyleCUnitFontScale%ld",(long)senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.UnitPositon forKey:[NSString stringWithFormat:@"StyleCUnitPositon%ld",(long)senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.FrameColor forKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",(long)senderview.tag]] ;
      [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.FrameScale forKey:[NSString stringWithFormat:@"StyleCFrameScale%ld",(long)senderview.tag]] ;
    

}
#pragma mark //得到最终设置

#pragma mark 移除一整页仪表盘
- (void)removeDashboard{
    NSLog(@"1212移除");
//    [[[scrollView subviews]objectAtIndex:0]removeFromSuperview];
    [scrollView removeFromSuperview];
    [self initWithUI];
}
#pragma mark 移除单个仪表盘
- (void)RemoveDisplay{
    NSLog(@"1yichuyichuaa");
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
    switch ([DashboardSetting sharedInstance].dashboardStyle) {
        case DashboardStyleOne:
        {
        dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            ++[DashboardSetting sharedInstance].RemoveDashboardNumber;
        [[DashboardSetting sharedInstance].defaults setObject:[NSString stringWithFormat:@"%ld",(long)[DashboardSetting sharedInstance].Dashboardindex] forKey:[NSString stringWithFormat:@"RemoveDashboard%ld",(long)[DashboardSetting sharedInstance].RemoveDashboardNumber]];
        [dashboardStyleAView removeFromSuperview];
        }
            break;
        case DashboardStyleTwo:
        {
            dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            ++[DashboardSetting sharedInstance].RemoveDashboardNumber;
            [[DashboardSetting sharedInstance].defaults setObject:[NSString stringWithFormat:@"%ld",(long)[DashboardSetting sharedInstance].Dashboardindex] forKey:[NSString stringWithFormat:@"StyleBRemoveDashboard%ld",(long)[DashboardSetting sharedInstance].RemoveDashboardNumber]];
            [dashboardStyleBView removeFromSuperview];
        }
            break;
        case DashboardStyleThree:
        {
            dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            ++[DashboardSetting sharedInstance].RemoveDashboardNumber;
            [[DashboardSetting sharedInstance].defaults setObject:[NSString stringWithFormat:@"%ld",(long)[DashboardSetting sharedInstance].Dashboardindex] forKey:[NSString stringWithFormat:@"StyleCRemoveDashboard%ld",(long)[DashboardSetting sharedInstance].RemoveDashboardNumber]];
            [dashboardStyleCView removeFromSuperview];
        }
            break;
        default:
            break;
    }
}
#pragma mark 全部恢复默认仪表盘
- (void)LoadDefaultDashboards{
    [DashboardSetting sharedInstance].KPageNumer = 3;
    [self clearAllUserDefaultsData];
    [self  updateView];
        
}
#pragma mark 移动仪表盘
- (void)MoveDashboard:(NSInteger)indexTag{
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == indexTag &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        NSLog(@"CCC");
        scrollView.scrollEnabled = NO;
        [DashboardSetting sharedInstance].isDashboardMove = NO;

        switch ([DashboardSetting sharedInstance ].dashboardStyle) {
            case DashboardStyleOne:
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleAView.frame.size.width, dashboardStyleAView.frame.size.width)];
                coverView.backgroundColor = [UIColor colorWithRed:254/255 green:144/255 blue:2/255 alpha:0.2];
                [dashboardStyleAView addSubview:coverView];
            }
                break;
            case DashboardStyleTwo :
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleBView.frame.size.width, dashboardStyleBView.frame.size.width)];
                coverView.backgroundColor = [UIColor colorWithRed:254/255 green:144/255 blue:2/255 alpha:0.2];
                [dashboardStyleBView addSubview:coverView];
            }
                break;
            case DashboardStyleThree:
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleCView.frame.size.width, dashboardStyleCView.frame.size.width)];
                coverView.backgroundColor = [UIColor colorWithRed:254/255 green:144/255 blue:2/255 alpha:0.2];
                [dashboardStyleCView addSubview:coverView];
            }
                break;
            default:
                break;
        }
      
        
    }

}
#pragma mark 移除要清除的仪表盘
- (void)ReMoveDashboard:(NSInteger)indexTag{
    //移除需要移除的仪表盘
   
   
    
            
            if ([DashboardSetting sharedInstance].RemoveDashboardNumber > 0) {
                for (NSInteger i = 1; i<=[DashboardSetting sharedInstance].RemoveDashboardNumber; i++) {
                    switch ([DashboardSetting sharedInstance].dashboardStyle) {
                        case DashboardStyleOne:
                        {
                            
                            //StyleBRemoveDashboard
                      NSInteger removeIndex =    [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"RemoveDashboard%ld",(long)i] ] integerValue] ;
                            if (indexTag == removeIndex) {

                            dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:removeIndex];
                            [dashboardStyleAView removeFromSuperview];
                            }
                        }
                            break;
                        case DashboardStyleTwo:
                        {
                            NSInteger removeIndex =    [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBRemoveDashboard%ld",(long)i] ] integerValue] ;
                            if (indexTag == removeIndex) {
                              dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:removeIndex];
                            [dashboardStyleBView removeFromSuperview];
                            }
                        }
                            break;
                        case DashboardStyleThree:
                        {
                NSInteger removeIndex =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCRemoveDashboard%ld",(long)i] ] ;
                            if (indexTag == removeIndex) {
                              
                            dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:removeIndex];
                            [dashboardStyleCView removeFromSuperview];
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
   }
#pragma mark 添加A类仪表盘
-(void)addStyleAView{
    dashboardStyleAView = [[DashboardView alloc ]initWithFrame:CGRectMake( pageControl.currentPage*MSWidth +(arc4random() % (int)MSWidth), (arc4random() % (int)MSHeight ), 150*KFontmultiple, 150*KFontmultiple)];
    dashboardStyleAView.tag = ++ DashBoardTag;
    diameterPercent = (dashboardStyleAView.frame.size.width/MSWidth)*100;
    
    LeftPercent =((dashboardStyleAView.frame.origin.x )/MSWidth)*100 ;
    
    TopPercent  = ((dashboardStyleAView.frame.origin.y )/MSHeight)*100;
    [self addDashboard];
    
   }
#pragma mark 添加B类仪表盘
-(void)addStyleBView{
    dashboardStyleBView = [[DashboardViewStyleB alloc ]initWithFrame:CGRectMake( pageControl.currentPage*MSWidth, 100, 150*KFontmultiple, 150*KFontmultiple)];
    dashboardStyleBView.tag = ++ DashBoardTag;
    diameterPercent = (dashboardStyleBView.frame.size.width/MSWidth)*100;
    
    LeftPercent =((dashboardStyleBView.frame.origin.x )/MSWidth)*100 ;
    
    TopPercent  = ((dashboardStyleBView.frame.origin.y )/MSHeight)*100;
    [self addDashboard];
}
#pragma mark 添加C类仪表盘
-(void)addStyleCView{
    dashboardStyleCView = [[DashboardViewStyleC alloc ]initWithFrame:CGRectMake( pageControl.currentPage*MSWidth, 100, 150*KFontmultiple, 150*KFontmultiple)];
    dashboardStyleCView.tag = ++ DashBoardTag;
    diameterPercent = (dashboardStyleCView.frame.size.width/MSWidth)*100;
    
    LeftPercent =((dashboardStyleCView.frame.origin.x )/MSWidth)*100 ;
    
    TopPercent  = ((dashboardStyleCView.frame.origin.y )/MSHeight)*100;
    [self addDashboard];

}
- (void)addDashboard{
    ++ [DashboardSetting sharedInstance].AddDashboardNumber;
    
    
    [[DashboardSetting sharedInstance].defaults setFloat:diameterPercent forKey:[NSString stringWithFormat:@"adddiameterPercent%ld",(long)[DashboardSetting sharedInstance].AddDashboardNumber]];
    
    [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:  [NSString stringWithFormat:@"addLeftPercent%ld",(long)[DashboardSetting sharedInstance].AddDashboardNumber]];
    
    [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"addTopPercent%ld",(long)[DashboardSetting sharedInstance].AddDashboardNumber]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.tag forKey:[NSString stringWithFormat:@"addTag%ld",(long)[DashboardSetting sharedInstance].AddDashboardNumber]];
    
    [self updateView];
    

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

    switch ([DashboardSetting sharedInstance].dashboardStyle ) {
        case DashboardStyleOne:
        {
            DashboardView  *view = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            scrollView.scrollEnabled = YES;
            NSInteger PageNumber = view.frame.origin.x / MSWidth;
            
            LeftPercent =((view.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
            TopPercent  = ((view.frame.origin.y )/MSHeight)*100;
            
            [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"LeftPercent%ld",(long)view.tag]];
            [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"TopPercent%ld",(long)view.tag]];
            [coverView removeFromSuperview];
        }
            break;
        case DashboardStyleTwo:
        {
            DashboardViewStyleB  *view = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            scrollView.scrollEnabled = YES;
            NSInteger PageNumber = view.frame.origin.x / MSWidth;
            
            LeftPercent =((view.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
            TopPercent  = ((view.frame.origin.y )/MSHeight)*100;
            
            [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",(long)view.tag]];
            [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",(long)view.tag]];
            [coverView removeFromSuperview];
        }
            break;
        case DashboardStyleThree:
        {
            DashboardViewStyleC  *view = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            scrollView.scrollEnabled = YES;
            NSInteger PageNumber = view.frame.origin.x / MSWidth;
            
            LeftPercent =((view.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
            TopPercent  = ((view.frame.origin.y )/MSHeight)*100;
            
            [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"StyleCLeftPercent%ld",(long)view.tag]];
            [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"StyleCTopPercent%ld",(long)view.tag]];
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
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end
