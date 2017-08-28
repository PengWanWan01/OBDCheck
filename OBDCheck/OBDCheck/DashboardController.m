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
@interface DashboardController ()<UIScrollViewDelegate,selectStyleDelegete>
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
     }
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

}
- (void)initWithData{
    _LabelNameArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery", nil];
    _numberArray = [[NSMutableArray alloc]init];
    
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
#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
    DashBoardTag = 0;
        for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        dashboardStyleAView  = [[DashboardView alloc] initWithFrame:CGRectMake(index * (baseViewWidth+15 )+15,  page  * (baseViewHeight + 40)+10, 150*KFontmultiple, 150*KFontmultiple +20)];

            dashboardStyleAView.infoLabel.text = _LabelNameArray[i];
            dashboardStyleAView.tag = ++DashBoardTag;

            [self initWithChangeStyleA:dashboardStyleAView :i] ;
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        dashboardStyleAView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+10, 220, 220+20)];
        dashboardStyleAView.tag = ++DashBoardTag;
        [self initWithChangeStyleA:dashboardStyleAView :i];
    }
    dashboardStyleAView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth*2+37, 88,300, 300+20)];
    dashboardStyleAView.tag = ++DashBoardTag;
    [self initWithChangeStyleA:dashboardStyleAView :dashboardStyleAView.tag] ;
    //保存添加的仪表盘数据
    if ([DashboardSetting sharedInstance].AddDashboardNumber >0) {
        for (NSInteger  i= 1; i<=[DashboardSetting sharedInstance].AddDashboardNumber; i++) {
            NSLog(@"==%ld",(long)i);
            
            NSString *diameterResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"adddiameterPercent%ld",i]];
            NSString *LeftResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addLeftPercent%ld",i]];
            NSString * TopResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTopPercent%ld",i]];
            dashboardStyleAView  = [[DashboardView alloc]initWithFrame: CGRectMake(([LeftResult floatValue]/100)*MSWidth, ([TopResult floatValue]/100)*MSHeight,([diameterResult floatValue]/100)*MSWidth,([diameterResult floatValue]/100)*MSWidth)];
            dashboardStyleAView.tag = [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTag%ld",i] ] integerValue];
            NSLog(@"dashboardStyleAView.tag) ==%@",[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTag%ld",i]]);
            
            DashBoardTag = dashboardStyleAView.tag ;
          [scrollView addSubview:dashboardStyleAView];
        [self initWithChangeStyleA:dashboardStyleAView :dashboardStyleAView.tag];
        }
     
    }
}
- (void)initWithChangeStyleA:(DashboardView *)view :(NSInteger)index{

    [scrollView addSubview:view];
    NSString *diameterResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"diameterPercent%ld",view.tag]];
    NSString *LeftResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"LeftPercent%ld",view.tag]];
    NSString * TopResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"TopPercent%ld",view.tag]];
    
    CGFloat  StartAngleResult  = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StartAngle%ld",view.tag]] ;
    CGFloat  endAngleResult  = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"endAngle%ld",view.tag]] ;
   
  CGFloat  ringWidthResult  =     [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"ringWidth%ld",view.tag]] ;
 CGFloat  maLengthResult    =    [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"maLength%ld",view.tag]] ;
  CGFloat  maWidthResult   =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"maWidth%ld",view.tag]];
   CGFloat  miLengthResult    =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"miLength%ld",view.tag]];
    CGFloat  miWidthResult    =       [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"miWidth%ld",view.tag]];
  NSString * maColorResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"maColor%ld",view.tag]] ;
  NSString * miColorResult   =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"miColor%ld",view.tag]] ;
    
    NSString * outerColorResult   =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"outerColor%ld",view.tag]] ;
     NSString * innerColorResult   =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"innerColor%ld",view.tag]] ;
    NSString *titleColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"titleColor%ld",view.tag]] ;
    CGFloat TitleFontScaleResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TitleFontScale%ld",view.tag]];
 CGFloat TitlePositionResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TitlePosition%ld",view.tag]];
    BOOL ValueVisbleResult =  [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"ValueVisble%ld",view.tag]];
     NSString *ValueColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"ValueColor%ld",view.tag]] ;
     CGFloat  ValueFontScaleResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"ValueFontScale%ld",view.tag]];
      CGFloat  ValuePositionResult =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"ValuePosition%ld",view.tag]];
    
    CGFloat LabelFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LabelFontScale%ld",view.tag]];
    CGFloat LabelOffestResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LabelOffest%ld",view.tag]];
  
    BOOL PointerVisbleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"PointerVisble%ld",view.tag]];
    CGFloat PointerWidthResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"PointerWidth%ld",view.tag]];
    CGFloat PointerLengthResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"PointerLength%ld",view.tag]];
     NSString *PointerColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"PointerColor%ld",view.tag]] ;
    CGFloat KNOBRadiusResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"KNOBRadius%ld",view.tag]];
     NSString *KNOBColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"KNOBColor%ld",view.tag]] ;
     BOOL FillenabledResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"Fillenabled%ld",view.tag]];
    CGFloat FillstartAngleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"FillstartAngle%ld",view.tag]];
     CGFloat FillEndAngleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"FillEndAngle%ld",view.tag]];
     NSString *FillColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"FillColor%ld",view.tag]] ;
    NSLog(@"FillColorVVv%@", FillColorResult );
    
    NSString *UnitColorResult  =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"UnitColor%ld",view.tag]] ;
    CGFloat UnitFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"UnitFontScale%ld",view.tag]];
       CGFloat UnitVerticalPositionResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"UnitVerticalPosition%ld",view.tag]];
       CGFloat UnitHorizontalPositionResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"UnitHorizontalPosition%ld",view.tag]];
    //画底盘渐变色
    [dashboardStyleAView addGradientView:@"#18191C" GradientViewWidth:view.frame.size.width];
    //画刻度
    [dashboardStyleAView drawCalibration:0 WithendAngle:2*M_PI WithRingWidth:10.f MAJORTICKSWidth:0 MAJORTICKSLength:15.f MAJORTICKSColor:@"FFFFFF" MINORTICKSWidth:0 MINORTICKSLength:5.f MINORTICKSColor:@"FFFFFF" LABELSVisible:YES Rotate:YES Font:1 OffestTickline:1 InnerColor:@"18191C" TitleColor:@"FE9002" TitleFontScale:1 TitlePosition:1 ValueVisble:YES ValueColor:@"FE9002" ValueFontScale:1 ValuePosition:1 UnitColor:@"FE9002" UnitFontScale:1 UnitVerticalPosition:1 UnitHorizontalPosition:1 PointerVisble:YES PointerWidth:10.f PointerLength: (view.frame.size.width/2) - 15 - 14 PointerColor:@"FE9002" KNOBRadius:10.f KNOBColor:@"FFFFFF" Fillenabled:YES FillstartAngle:0 FillEndAngle:0 FillColor:@"FE9002"];
    
   
    //加入是被点击过的 ；让被选中的仪表盘位置发生变化
    if ([[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"change%ld",dashboardStyleAView.tag]] isEqualToString:@"YES"]) {
        NSInteger TapIndex = view.tag;
        NSInteger PageNumber = view.frame.origin.x / MSWidth;
        
        [view removeFromSuperview];
        dashboardStyleAView  = [[DashboardView alloc]initWithFrame: CGRectMake(([LeftResult floatValue]/100)*MSWidth+PageNumber*MSWidth, ([TopResult floatValue]/100)*MSHeight,([diameterResult floatValue]/100)*MSWidth,([diameterResult floatValue]/100)*MSWidth)];
        //画底盘渐变色
        [dashboardStyleAView addGradientView:outerColorResult GradientViewWidth:([diameterResult floatValue]/100)*MSWidth];
        //画刻度
        [dashboardStyleAView drawCalibration:StartAngleResult WithendAngle:endAngleResult WithRingWidth:ringWidthResult MAJORTICKSWidth:maWidthResult MAJORTICKSLength:maLengthResult MAJORTICKSColor:maColorResult MINORTICKSWidth:miWidthResult MINORTICKSLength:miLengthResult MINORTICKSColor:miColorResult LABELSVisible:YES Rotate:YES Font:LabelFontScaleResult OffestTickline:LabelOffestResult InnerColor:innerColorResult TitleColor:titleColorResult TitleFontScale:TitleFontScaleResult TitlePosition:TitlePositionResult ValueVisble:ValueVisbleResult ValueColor:ValueColorResult ValueFontScale:ValueFontScaleResult ValuePosition:ValuePositionResult UnitColor:UnitColorResult   UnitFontScale:UnitFontScaleResult UnitVerticalPosition:UnitVerticalPositionResult UnitHorizontalPosition:UnitHorizontalPositionResult  PointerVisble:PointerVisbleResult PointerWidth:PointerWidthResult PointerLength:PointerLengthResult PointerColor:PointerColorResult KNOBRadius:KNOBRadiusResult KNOBColor:KNOBColorResult Fillenabled:FillenabledResult FillstartAngle:FillstartAngleResult   FillEndAngle:FillEndAngleResult FillColor:FillColorResult];
        dashboardStyleAView.tag = TapIndex;
       
        

    }

    [dashboardStyleAView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    [scrollView addSubview:dashboardStyleAView];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [dashboardStyleAView addGestureRecognizer:LongPress];
    //移除需要移除的仪表盘
        if ([DashboardSetting sharedInstance].RemoveDashboardNumber > 0) {
        for (NSInteger i = 1; i<=[DashboardSetting sharedInstance].RemoveDashboardNumber; i++) {
         NSInteger removeIndex =    [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"RemoveDashboard%ld",i] ] integerValue] ;
            if (view.tag == removeIndex) {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:removeIndex];
                [dashboardStyleAView removeFromSuperview];
            }
        }
    }
    
    
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"dddd%ld",(long)index);
      DashboardView  *view = (DashboardView *)[scrollView viewWithTag:index];
         [[view superview] bringSubviewToFront:view];

        [DashboardSetting sharedInstance].isDashboardFont = NO;
        
    }
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        NSLog(@"CCC");
        dashboardStyleAView.backgroundColor = [UIColor goldColor];
        scrollView.userInteractionEnabled = NO;
        [DashboardSetting sharedInstance].isDashboardMove = NO;
        
    }else{
        scrollView.userInteractionEnabled = YES;
    }

}

- (void)initWithStyleB{
    DashBoardTag = 0;
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(index * (baseViewWidth+15 )+15, page  * (baseViewHeight + 40), baseViewWidth, baseViewHeight)];
        dashboardStyleBView.tag = ++DashBoardTag;
        [self initWithChangeStyleB:dashboardStyleBView :i ];

    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30), 220, 220)];
        dashboardStyleBView.tag = ++DashBoardTag;
        [self initWithChangeStyleB:dashboardStyleBView :i ];
    }
    
    dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth*2+37,  88,300, 300)];
    dashboardStyleBView.tag = ++DashBoardTag;
    [self initWithChangeStyleB:dashboardStyleBView :dashboardStyleBView.tag ];
    //保存添加的仪表盘数据
    if ([DashboardSetting sharedInstance].AddDashboardNumber >0) {
        for (NSInteger  i= 1; i<=[DashboardSetting sharedInstance].AddDashboardNumber; i++) {
            NSLog(@"==%ld",(long)i);
            
            NSString *diameterResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"adddiameterPercent%ld",i]];
            NSString *LeftResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addLeftPercent%ld",i]];
            NSString * TopResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTopPercent%ld",i]];
            dashboardStyleBView  = [[DashboardViewStyleB alloc]initWithFrame: CGRectMake(([LeftResult floatValue]/100)*MSWidth, ([TopResult floatValue]/100)*MSHeight,([diameterResult floatValue]/100)*MSWidth,([diameterResult floatValue]/100)*MSWidth)];
            dashboardStyleBView.tag = [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTag%ld",i] ] integerValue];
            NSLog(@"dashboardStyleAView.tag) ==%@",[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTag%ld",i]]);
            
            DashBoardTag = dashboardStyleBView.tag ;
            [scrollView addSubview:dashboardStyleBView];
            [self initWithChangeStyleB:dashboardStyleBView :dashboardStyleBView.tag];
        }
        
    }

}
- (void)initWithChangeStyleB:(DashboardViewStyleB *)view :(NSInteger)index{
    [scrollView addSubview:view];
    [view drawgradient:@"00a6ff" GradientRadius:1.f TitlteColor:@"#757476" TitlteFontScale:1 TitlePositon:1 ValueVisible:YES Valuecolor:@"#FFFFFF" ValueFontScale:1 ValuePositon:1 UnitColor:@"#757476" UnitFontScale:1 UnitPositon:1 PointColor:@"FFFFF" PointWidth:5 Fillenable:YES FillPosition:YES];
    
    NSString *diameterResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBdiameterPercent%ld",view.tag]];
    NSString *LeftResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",view.tag]];
    NSString * TopResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",view.tag]];

    
   NSString *  backColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBbackColor%ld",view.tag]] ;
    CGFloat GradientRaduisResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBGradientRaduis%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
   NSString *titleColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBtitleColor%ld",view.tag]] ;
    CGFloat  titleFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBtitleFontScale%ld",view.tag]] ;
    CGFloat titlePositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",view.tag]] ;
    BOOL ValueVisibleResult = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleBValueVisible%ld",view.tag]] ;
    NSString *ValueColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBValueColor%ld",view.tag]] ;
    CGFloat ValueFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBValueFontScale%ld",view.tag]] ;
     CGFloat ValuePositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBValuePositon%ld",view.tag]] ;

    
    NSString * UnitColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBUnitColor%ld",view.tag]] ;
    CGFloat UnitFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBUnitFontScale%ld",view.tag]] ;
    CGFloat UnitPositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBUnitPositon%ld",view.tag]] ;
    
    
    NSString *pointerColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBpointerColor%ld",view.tag]] ;
    CGFloat PointerwidthResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBPointerwidth%ld",view.tag]] ;
    BOOL FillEnableResult = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleBFillEnable%ld",view.tag]] ;
   CGFloat  FillPositionResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBFillPosition%ld",view.tag]] ;
    if ([[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBchange%ld",view.tag]] isEqualToString:@"YES"]) {
        NSInteger TapIndex = view.tag;
        NSInteger PageNumber = view.frame.origin.x / MSWidth;
        
        [view removeFromSuperview];
        dashboardStyleBView  = [[DashboardViewStyleB alloc]initWithFrame: CGRectMake(([LeftResult floatValue]/100)*MSWidth+PageNumber*MSWidth, ([TopResult floatValue]/100)*MSHeight,([diameterResult floatValue]/100)*MSWidth,([diameterResult floatValue]/100)*MSWidth)];
        [dashboardStyleBView drawgradient:backColorResult GradientRadius:GradientRaduisResult TitlteColor:titleColorResult TitlteFontScale:titleFontScaleResult TitlePositon:titlePositonResult ValueVisible:ValueVisibleResult Valuecolor:ValueColorResult ValueFontScale:ValueFontScaleResult ValuePositon:ValuePositonResult UnitColor:UnitColorResult UnitFontScale:UnitFontScaleResult UnitPositon:UnitPositonResult PointColor:pointerColorResult PointWidth:PointerwidthResult Fillenable:FillEnableResult FillPosition:FillPositionResult];
        
        dashboardStyleBView.tag = TapIndex;
    }
    [dashboardStyleBView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    [scrollView addSubview:dashboardStyleBView];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [dashboardStyleBView addGestureRecognizer:LongPress];
    //移除需要移除的仪表盘
    if ([DashboardSetting sharedInstance].RemoveDashboardNumber > 0) {
        for (NSInteger i = 1; i<=[DashboardSetting sharedInstance].RemoveDashboardNumber; i++) {
            NSInteger removeIndex =    [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"RemoveDashboard%ld",i] ] integerValue] ;
            if (view.tag == removeIndex) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:removeIndex];
                [dashboardStyleAView removeFromSuperview];
            }
        }
    }
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"dddd");
        [scrollView bringSubviewToFront:dashboardStyleBView];
        
        [DashboardSetting sharedInstance].isDashboardFont = NO;
        
    }
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == index &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        NSLog(@"CCC");
        dashboardStyleBView.backgroundColor = [UIColor goldColor];
        scrollView.userInteractionEnabled = NO;
        [DashboardSetting sharedInstance].isDashboardMove = NO;
        
    }else{
        scrollView.userInteractionEnabled = YES;
    }
    [scrollView addSubview:dashboardStyleBView];
    
}

- (void)initWithStyleC{
    DashBoardTag = 0;
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(index * (baseViewWidth+15 )+15, page  * (baseViewHeight + 40), baseViewWidth, baseViewHeight)];
        dashboardStyleCView.tag = ++DashBoardTag;
        [self initWithChangeStyleC:dashboardStyleCView :i];
  
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30), 220, 220)];
        dashboardStyleCView.tag = ++DashBoardTag;
        [self initWithChangeStyleC:dashboardStyleCView :i];

    }
    
    dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth*2+37,  88,300, 300)];
    dashboardStyleCView.tag = ++DashBoardTag;
    [self initWithChangeStyleC:dashboardStyleCView :dashboardStyleCView.tag];
    //保存添加的仪表盘数据
    if ([DashboardSetting sharedInstance].AddDashboardNumber >0) {
        for (NSInteger  i= 1; i<=[DashboardSetting sharedInstance].AddDashboardNumber; i++) {
            NSLog(@"==%ld",(long)i);
            
            NSString *diameterResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"adddiameterPercent%ld",i]];
            NSString *LeftResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addLeftPercent%ld",i]];
            NSString * TopResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTopPercent%ld",i]];
            dashboardStyleCView  = [[DashboardViewStyleC alloc]initWithFrame: CGRectMake(([LeftResult floatValue]/100)*MSWidth, ([TopResult floatValue]/100)*MSHeight,([diameterResult floatValue]/100)*MSWidth,([diameterResult floatValue]/100)*MSWidth)];
            dashboardStyleCView.tag = [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTag%ld",i] ] integerValue];
            NSLog(@"dashboardStyleAView.tag) ==%@",[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"addTag%ld",i]]);
            
            DashBoardTag = dashboardStyleCView.tag ;
            [scrollView addSubview:dashboardStyleCView];
            [self initWithChangeStyleC:dashboardStyleCView :dashboardStyleBView.tag];
        }
        
    }

}
- (void)initWithChangeStyleC:(DashboardViewStyleC *)view :(NSInteger)index{
    //ColorTools colorWithHexString:@"202226"
    //黑色
    //[ColorTools colorWithHexString:@"#FFFFFF"]
    [view drawinnerColor:@"000000" OuterColor:@"202226"  Gradientradius:1.f TitleColor:@"FFFFFF" TiltefontScale:1 TitlePosition:1 ValueVisible:YES Valuecolor:@"FFFFFF" ValueFontScale:1 ValuePositon:1 UnitColor:@"FFFFFF" UnitFontScale:1 UnitPositon:1 FrameColor:@"FFFFFF" FrameScale:1];
    
    NSString *diameterResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCdiameterPercent%ld",view.tag]];
    NSString *LeftResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCLeftPercent%ld",view.tag]];
    NSString * TopResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCTopPercent%ld",view.tag]];
 
    NSString *innerColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCinnerColor%ld",view.tag]] ;
    NSString *outerColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCouterColor%ld",view.tag]] ;

    CGFloat GradientradiusResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCGradientradius%ld",view.tag]] ;
    
    NSString * titleColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCtitleColor%ld",view.tag]] ;
    CGFloat titleFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCtitleFontScale%ld",view.tag]] ;
    
  CGFloat titlePositonResult =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCtitlePositon%ld",view.tag]] ;
    CGFloat ValueVisibleResult = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleCValueVisible%ld",view.tag]] ;
    NSString * ValueColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCValueColor%ld",view.tag]] ;
    
    CGFloat ValueFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValueFontScale%ld",view.tag]] ;
    CGFloat ValuePositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValuePositon%ld",view.tag]] ;
     NSString *UnitColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCUnitColor%ld",view.tag]] ;
    CGFloat UnitFontScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitFontScale%ld",view.tag]] ;
    
    CGFloat UnitPositonResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitPositon%ld",view.tag]] ;
    NSString * FrameColorResult = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",view.tag]] ;
    CGFloat FrameScaleResult = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCFrameScale%ld",view.tag]] ;
    
    
    if ([[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCchange%ld",view.tag]] isEqualToString:@"YES"]) {
        NSInteger TapIndex = view.tag;
        NSInteger PageNumber = view.frame.origin.x / MSWidth;
        
        [view removeFromSuperview];
        dashboardStyleCView  = [[DashboardViewStyleC alloc]initWithFrame: CGRectMake(([LeftResult floatValue]/100)*MSWidth+PageNumber*MSWidth, ([TopResult floatValue]/100)*MSHeight,([diameterResult floatValue]/100)*MSWidth,([diameterResult floatValue]/100)*MSWidth)];
        [dashboardStyleCView drawinnerColor:innerColorResult OuterColor:outerColorResult Gradientradius:GradientradiusResult TitleColor:titleColorResult TiltefontScale:titleFontScaleResult TitlePosition:titlePositonResult ValueVisible:ValueVisibleResult Valuecolor:ValueColorResult ValueFontScale:ValueFontScaleResult ValuePositon:ValuePositonResult UnitColor:UnitColorResult UnitFontScale:UnitFontScaleResult UnitPositon:UnitPositonResult FrameColor:FrameColorResult FrameScale:FrameScaleResult];
        
        dashboardStyleCView.tag = TapIndex;
    }
    [scrollView addSubview:dashboardStyleCView];

    [dashboardStyleCView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    [scrollView addSubview:dashboardStyleCView];
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [dashboardStyleCView addGestureRecognizer:LongPress];
    //移除需要移除的仪表盘
    if ([DashboardSetting sharedInstance].RemoveDashboardNumber > 0) {
        for (NSInteger i = 1; i<=[DashboardSetting sharedInstance].RemoveDashboardNumber; i++) {
            NSInteger removeIndex =    [[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"RemoveDashboard%ld",i] ] integerValue] ;
            if (view.tag == removeIndex) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:removeIndex];
                [dashboardStyleCView removeFromSuperview];
            }
        }
    }
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
#pragma mark 长按仪表盘的手势
- (void)tap:(UILongPressGestureRecognizer *)sender{
  
    NSLog(@" [sender view].tag %ld", sender.view.tag);
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
    
    NSLog(@"123==%f,%f,%f",senderview.frame.size.width,senderview.frame.origin.x ,senderview.frame.origin.y+10);
    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:senderview.tag];
    
    [[DashboardSetting sharedInstance].defaults setFloat:diameterPercent  forKey:[NSString stringWithFormat:@"diameterPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"LeftPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"TopPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:@"YES" forKey:[NSString stringWithFormat:@"change%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.StartAngle forKey:[NSString stringWithFormat:@"StartAngle%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.endAngle forKey:[NSString stringWithFormat:@"endAngle%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.ringWidth forKey:[NSString stringWithFormat:@"ringWidth%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.maLength forKey:[NSString stringWithFormat:@"maLength%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.maLength forKey:[NSString stringWithFormat:@"maWidth%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.miLength forKey:[NSString stringWithFormat:@"miLength%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.miWidth forKey:[NSString stringWithFormat:@"miWidth%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.maColor  forKey:[NSString stringWithFormat:@"maColor%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.miColor forKey:[NSString stringWithFormat:@"miColor%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.outerColor  forKey:[NSString stringWithFormat:@"outerColor%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.innerColor forKey:[NSString stringWithFormat:@"innerColor%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.titleColor forKey:[NSString stringWithFormat:@"titleColor%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"TitleFontScale%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"TitlePosition%ld",senderview.tag]];
    
    
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.ValueVisble forKey:[NSString stringWithFormat:@"ValueVisble%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.ValueColor forKey:[NSString stringWithFormat:@"ValueColor%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"ValueFontScale%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.titleFontScale forKey:[NSString stringWithFormat:@"ValuePosition%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.LabelVisble forKey:[NSString stringWithFormat:@"LabelVisble%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.LabelRotate forKey:[NSString stringWithFormat:@"LabelRotate%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.LabelFontScale forKey:[NSString stringWithFormat:@"LabelFontScale%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.LabelOffest forKey:[NSString stringWithFormat:@"LabelOffest%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.PointerVisble forKey:[NSString stringWithFormat:@"PointerVisble%ld",senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.PointerWidth forKey:[NSString stringWithFormat:@"PointerWidth%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.PointerLength forKey:[NSString stringWithFormat:@"PointerLength%ld",senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.PointerColor forKey:[NSString stringWithFormat:@"PointerColor%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.KNOBRadius forKey:[NSString stringWithFormat:@"KNOBRadius%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.KNOBColor forKey:[NSString stringWithFormat:@"KNOBColor%ld",senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleAView.Fillenabled forKey:[NSString stringWithFormat:@"Fillenabled%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.FillstartAngle forKey:[NSString stringWithFormat:@"FillstartAngle%ld",senderview.tag]];
   [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.FillEndAngle forKey:[NSString stringWithFormat:@"FillEndAngle%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.FillColor forKey:[NSString stringWithFormat:@"FillColor%ld",senderview.tag]] ;
    NSLog(@"FillColorv%@", [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"FillColor%ld",senderview.tag]] );
    
 [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleAView.UnitColor forKey:[NSString stringWithFormat:@"UnitColor%ld",senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.UnitFontScale forKey:[NSString stringWithFormat:@"UnitFontScale%ld",senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.UnitVerticalPosition forKey:[NSString stringWithFormat:@"UnitVerticalPosition%ld",senderview.tag]];
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleAView.UnitHorizontalPosition forKey:[NSString stringWithFormat:@"UnitHorizontalPosition%ld",senderview.tag]];

}
- (void)initWithDefaultStyleB :(UIView *)senderview{
    NSInteger PageNumber = senderview.frame.origin.x / MSWidth;
    

    diameterPercent = (senderview.frame.size.width/MSWidth)*100;
    
    LeftPercent =((senderview.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
    
    TopPercent  = ((senderview.frame.origin.y +10)/MSHeight)*100;
    
    NSLog(@"123==%f,%f,%f",senderview.frame.size.width,senderview.frame.origin.x ,senderview.frame.origin.y+10);
    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:senderview.tag];
    
    [[DashboardSetting sharedInstance].defaults setFloat:diameterPercent forKey:[NSString stringWithFormat:@"StyleBdiameterPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:@"YES" forKey:[NSString stringWithFormat:@"StyleBchange%ld",senderview.tag]];
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.backColor forKey:[NSString stringWithFormat:@"StyleBbackColor%ld",senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.GradientRadius forKey:[NSString stringWithFormat:@"StyleBGradientRaduis%ld",senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.titleColor forKey:[NSString stringWithFormat:@"StyleBtitleColor%ld",senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.titleFontScale forKey:[NSString stringWithFormat:@"StyleBtitleFontScale%ld",senderview.tag]] ;
    
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.titlePositon forKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleBView.ValueVisible forKey:[NSString stringWithFormat:@"StyleBValueVisible%ld",senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.ValueColor forKey:[NSString stringWithFormat:@"StyleBValueColor%ld",senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.ValueFontScale forKey:[NSString stringWithFormat:@"StyleBValueFontScale%ld",senderview.tag]] ;
  [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.ValuePositon forKey:[NSString stringWithFormat:@"StyleBValuePositon%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.titlePositon forKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.UnitColor forKey:[NSString stringWithFormat:@"StyleBUnitColor%ld",senderview.tag]] ;
 [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.UnitFontScale forKey:[NSString stringWithFormat:@"StyleBUnitFontScale%ld",senderview.tag]] ;
 [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.UnitPositon forKey:[NSString stringWithFormat:@"StyleBUnitPositon%ld",senderview.tag]] ;
    
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleBView.pointerColor forKey:[NSString stringWithFormat:@"StyleBpointerColor%ld",senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.Pointerwidth forKey:[NSString stringWithFormat:@"StyleBPointerwidth%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleBView.FillEnable forKey:[NSString stringWithFormat:@"StyleBFillEnable%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleBView.FillPosition forKey:[NSString stringWithFormat:@"StyleBFillPosition%ld",senderview.tag]] ;
    

}
- (void)initWithDefaultStyleC :(UIView *)senderview{
    NSInteger PageNumber = senderview.frame.origin.x / MSWidth;

    diameterPercent = (senderview.frame.size.width/MSWidth)*100;
    
    LeftPercent =((senderview.frame.origin.x  - PageNumber*MSWidth)/MSWidth)*100 ;
    
    TopPercent  = ((senderview.frame.origin.y )/MSHeight)*100;
    
   
    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:senderview.tag];
    
    [[DashboardSetting sharedInstance].defaults setFloat:diameterPercent forKey:[NSString stringWithFormat:@"StyleCdiameterPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:LeftPercent forKey:[NSString stringWithFormat:@"StyleCLeftPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setFloat:TopPercent forKey:[NSString stringWithFormat:@"StyleCTopPercent%ld",senderview.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:@"YES" forKey:[NSString stringWithFormat:@"StyleCchange%ld",senderview.tag]];
    
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.innerColor forKey:[NSString stringWithFormat:@"StyleCinnerColor%ld",senderview.tag]] ;
      [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.outerColor forKey:[NSString stringWithFormat:@"StyleCouterColor%ld",senderview.tag]] ;
    

      [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.Gradientradius forKey:[NSString stringWithFormat:@"StyleCGradientradius%ld",senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.titleColor forKey :[NSString stringWithFormat:@"StyleCtitleColor%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.titleFontScale forKey:[NSString stringWithFormat:@"StyleCtitleFontScale%ld",senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.titlePositon forKey:[NSString stringWithFormat:@"StyleCtitlePositon%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setBool:dashboardStyleCView.ValueVisible forKey:[NSString stringWithFormat:@"StyleCValueVisible%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.ValueColor forKey:[NSString stringWithFormat:@"StyleCValueColor%ld",senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.ValueFontScale forKey:[NSString stringWithFormat:@"StyleCValueFontScale%ld",senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.ValuePositon forKey:[NSString stringWithFormat:@"StyleCValuePositon%ld",senderview.tag]] ;
   [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.UnitColor forKey:[NSString stringWithFormat:@"StyleCUnitColor%ld",senderview.tag]] ;
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.UnitFontScale forKey:[NSString stringWithFormat:@"StyleCUnitFontScale%ld",senderview.tag]] ;
    
    [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.UnitPositon forKey:[NSString stringWithFormat:@"StyleCUnitPositon%ld",senderview.tag]] ;
     [[DashboardSetting sharedInstance].defaults setObject:dashboardStyleCView.FrameColor forKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",senderview.tag]] ;
      [[DashboardSetting sharedInstance].defaults setFloat:dashboardStyleCView.FrameScale forKey:[NSString stringWithFormat:@"StyleCFrameScale%ld",senderview.tag]] ;
    

}

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

    switch ([DashboardSetting sharedInstance].dashboardStyle) {
        case DashboardStyleOne:
        {
        dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            ++[DashboardSetting sharedInstance].RemoveDashboardNumber;
        [[DashboardSetting sharedInstance].defaults setObject:[NSString stringWithFormat:@"%ld",(long)[DashboardSetting sharedInstance].Dashboardindex] forKey:[NSString stringWithFormat:@"RemoveDashboard%ld",[DashboardSetting sharedInstance].RemoveDashboardNumber]];
        [dashboardStyleAView removeFromSuperview];
        }
            break;
        case DashboardStyleTwo:
        {
            dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            ++[DashboardSetting sharedInstance].RemoveDashboardNumber;
            [[DashboardSetting sharedInstance].defaults setObject:[NSString stringWithFormat:@"%ld",(long)[DashboardSetting sharedInstance].Dashboardindex] forKey:[NSString stringWithFormat:@"StyleBRemoveDashboard%ld",[DashboardSetting sharedInstance].RemoveDashboardNumber]];
            [dashboardStyleBView removeFromSuperview];
        }
            break;
        case DashboardStyleThree:
        {
            dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            ++[DashboardSetting sharedInstance].RemoveDashboardNumber;
            [[DashboardSetting sharedInstance].defaults setObject:[NSString stringWithFormat:@"%ld",(long)[DashboardSetting sharedInstance].Dashboardindex] forKey:[NSString stringWithFormat:@"StyleCRemoveDashboard%ld",[DashboardSetting sharedInstance].RemoveDashboardNumber]];
            [dashboardStyleCView removeFromSuperview];
        }
            break;
        default:
            break;
    }
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
}
#pragma mark 全部恢复默认仪表盘
- (void)LoadDefaultDashboards{
    [DashboardSetting sharedInstance].KPageNumer = 3;
    [self clearAllUserDefaultsData];
    [self  updateView];
        
}
#pragma mark 添加A类仪表盘
-(void)addStyleAView{
    dashboardStyleAView = [[DashboardView alloc ]initWithFrame:CGRectMake( pageControl.currentPage*MSWidth, 100, 150*KFontmultiple, 150*KFontmultiple)];
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
    [[DashboardSetting sharedInstance].defaults setObject:[NSString stringWithFormat:@"%ld",dashboardStyleAView.tag] forKey:[NSString stringWithFormat:@"addTag%ld",(long)[DashboardSetting sharedInstance].AddDashboardNumber]];
    
    [self updateView];
    

}
#pragma mark 更新最新的仪表盘
- (void)updateView{
    NSInteger current = pageControl.currentPage;
    [pageControl removeFromSuperview];
    [scrollView removeFromSuperview];
    [self initWithUI];
     scrollView.contentOffset = CGPointMake(current*MSWidth, 0);
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
