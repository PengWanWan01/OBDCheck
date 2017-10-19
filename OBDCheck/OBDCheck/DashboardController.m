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
@property (nonatomic,strong) NSMutableArray *CustomNumberArray;
@property (nonatomic,strong) NSMutableArray *CustomLabelArray;
@property (nonatomic,copy)  NSString *  PreNumberStr;
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
//    [self startAnimation];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)isFristLoadCustomDashboard{
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
        dashboardStyleAView  = [[DashboardView alloc] initWithFrame:CGRectMake(index * (space+ 150*KFontmultiple)+25,  page  * (baseViewHeight + 40)+10, 150*KFontmultiple, 150*KFontmultiple +20)];
        [self updateCustomType:1 OrignX:dashboardStyleAView.frame.origin.x OrignY:dashboardStyleAView.frame.origin.y Width:dashboardStyleAView.frame.size.width Height:dashboardStyleAView.frame.size.height ID:i+1];
        
    }
    //第二页的仪表盘
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30)+30, 220, 220)];
         [self updateCustomType:2 OrignX:dashboardStyleBView.frame.origin.x OrignY:dashboardStyleBView.frame.origin.y Width:dashboardStyleBView.frame.size.width Height:dashboardStyleBView.frame.size.height ID:i+7];
    }
    dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth*2+(MSWidth- 300)/2,  88,300, 300)];
    [self updateCustomType:3 OrignX:dashboardStyleCView.frame.origin.x OrignY:dashboardStyleCView.frame.origin.y Width:dashboardStyleCView.frame.size.width Height:dashboardStyleCView.frame.size.height ID:9];

}

#pragma mark 对自定义不同风格进行更新
- (void)updateCustomType:(NSInteger )Customtype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(NSInteger)id{
    NSLog(@"更新");
    NSArray *he = [CustomDashboard findAll];
    for (int i = 0; i<he.count; i++) {
        CustomDashboard *dash =he[i];
        
        if (dash.pk == id ) {
    switch (Customtype) {
        case 1:
        {
            NSLog(@"orignx%f",orignx);
            dash.dashboardA.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardA.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardA.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardA.orignheight = [NSNumber numberWithFloat:height];

        }
            break;
        case 2:
        {
            dash.dashboardB.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardB.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardB.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardB.orignheight = [NSNumber numberWithFloat:height];
            dash.dashboardB.GradientRadius = [NSNumber numberWithFloat:width/2];

        }
            break;
        case 3:
        {
            dash.dashboardC.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardC.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardC.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardC.orignheight = [NSNumber numberWithFloat:height];
            dash.dashboardC.Gradientradius = [NSNumber numberWithFloat:width/2];
        }
            break;
        default:
            break;
    }

    [dash update];
        }
    }

}
#pragma mark 对经典三个表格进行更新
- (void)updatemodel:(NSInteger )tabletype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(CGFloat)id{
   
    switch (tabletype) {
        case 1:
        {
            DashboardA *model = [DashboardA new];
            NSString *SQL  = [NSString stringWithFormat:@"where pk = %@",[NSNumber numberWithFloat:id]];
            NSArray *pAll = [DashboardA findByCriteria:SQL];
            for(DashboardA* dash in pAll){
                model = dash;
            }
            model.orignx = [NSNumber numberWithFloat:orignx];
            model.origny = [NSNumber numberWithFloat:origny];
            model.orignwidth = [NSNumber numberWithFloat:width];
            model.orignheight = [NSNumber numberWithFloat:height];

            [model update];
           
        }
            break;
        case 2:
        {
            DashboardB *model = [DashboardB new];
            NSString *SQL  = [NSString stringWithFormat:@"where pk = %@",[NSNumber numberWithFloat:id]];
            NSArray *pAll = [DashboardB findByCriteria:SQL];
            for(DashboardB* dash in pAll){
                model = dash;
            }
            model.orignx = [NSNumber numberWithFloat:orignx];
            model.origny = [NSNumber numberWithFloat:origny];
            model.orignwidth = [NSNumber numberWithFloat:width];
            model.orignheight = [NSNumber numberWithFloat:height];
            [model update];
        }
            break;
        case 3:
        {
            DashboardC *model = [DashboardC new];
            NSString *SQL  = [NSString stringWithFormat:@"where pk = %@",[NSNumber numberWithFloat:id]];
            NSArray *pAll = [DashboardC findByCriteria:SQL];
            for(DashboardC* dash in pAll){
                model = dash;
            }
            model.orignx = [NSNumber numberWithFloat:orignx];
            model.origny = [NSNumber numberWithFloat:origny];
            model.orignwidth = [NSNumber numberWithFloat:width];
            model.orignheight = [NSNumber numberWithFloat:height];
            [model update];

        }
            break;
        default:
            break;
    }
//
}
- (void)startAnimation{
//    NSTimeInterval period = 1; //设置时间间隔
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
//    // 事件回调
//    dispatch_source_set_event_handler(_timer, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimationView];
//        });
//    });
//    
//    // 开启定时器
//    dispatch_resume(_timer);
    
    
}
- (void)startAnimationView{
    
    //自定义模式
    for (int i = 0; i<_CustomNumberArray.count; i++) {
        _PreNumberStr = _CustomNumberArray[i];
        [self initWithData];
        if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
            NSString *findsql = [NSString stringWithFormat:@"WHERE  pk = %@",[NSNumber numberWithInteger:i+1]];
            NSArray* pAll = [CustomDashboard findByCriteria:findsql];
            for(CustomDashboard *dashboard in pAll){
                switch (dashboard.dashboardType) {
                    case 1:
                    {
                        
                        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleAViewTag",_CustomNumberArray[i],@"StyleAViewnumber",_PreNumberStr,@"PreStyleAViewnumber", nil];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
                    }
                        break;
                    case 2:
                    {
                        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleBViewTag",_CustomNumberArray[i],@"StyleBViewnumber",_PreNumberStr,@"PreStyleBViewnumber", nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"StyleBupdateNumber" object:nil userInfo:dict];
                    }
                        break;
                    case 3:
                    {
                        dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:i+1];
                        dashboardStyleCView.NumberLabel.text = _CustomNumberArray[i];
                    }
                        break;
                    default:
                        break;
                }
                
            }
            

        }else{
       //经典模式
        switch ([DashboardSetting sharedInstance].dashboardStyle) {
            case DashboardStyleOne:
            {

                
                NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleAViewTag",_numberArray[i],@"StyleAViewnumber",_PreNumberStr,@"PreStyleAViewnumber", nil];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];

            }
                break;
            case DashboardStyleTwo:
            {
                NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleBViewTag",_numberArray[i],@"StyleBViewnumber",_PreNumberStr,@"PreStyleBViewnumber", nil];
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
    _CustomLabelArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];
    
    self.CustomNumberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];

   
    NSArray *pAllCount = [CustomDashboard findAll];
    CustomDashboard *modle = pAllCount.lastObject;
    NSInteger space =   modle.pk  - _CustomLabelArray.count;
    if (space > 0) {
        for (int i = 1; i<=space; i++) {
            [_CustomLabelArray addObject:@"add"];
            [self.CustomNumberArray  addObject:@"12"];
        }
    }
    for (int i = 0; i<_numberArray.count; i++) {
        [_numberArray  replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
    }
    for (int i = 0; i<_CustomLabelArray.count; i++) {
        [self.CustomNumberArray    replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
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
    pageControl = [UIPageControl new];
    //不要加到滚动视图中， 会随着滚动消失掉
    [self.view addSubview:pageControl];
    //    设置常用属性,距离屏幕下方60像素。
    pageControl.frame = CGRectMake(0, MSHeight- self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -40, MSWidth, 30);
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
    [self LoadUI];


}
- (void)LoadUI{
    //判断仪表盘模式：
    if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
            [self initWithcustomMode];
        if ([DashboardSetting sharedInstance].isAddDashboard == YES) {
            [self addDashboard];
            [DashboardSetting sharedInstance].isAddDashboard = NO;
        }
        [self moveFoneView];

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
//    dispatch_source_cancel(_timer);
       [editview hide];
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    
}
- (void)initWithcustomMode{
    NSArray* pAllCount = [CustomDashboard findAll];
    for (NSInteger i = 0;i<pAllCount.count;i++) {
        CustomDashboard *dash = pAllCount[i];
        NSLog(@"orignx%@",dash);
        if (dash.dashboardType == 1) {
            NSLog(@"dash%@",dash);
            dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.dashboardA.orignx doubleValue], [dash.dashboardA.origny doubleValue], [dash.dashboardA.orignwidth doubleValue], [dash.dashboardA.orignheight doubleValue])];
            dashboardStyleAView.tag = dash.pk ;
            DashBoardTag = dashboardStyleAView.tag ;
            [dashboardStyleAView addGradientView:dash.dashboardA.outerColor  GradientViewWidth:dashboardStyleAView.frame.size.width];
            NSLog(@"dashboardA%@",dash.dashboardA);
            dashboardStyleAView.delegate = self;
            [dashboardStyleAView initWithModel:dash.dashboardA];
            [scrollView addSubview:dashboardStyleAView];
        }
        if (dash.dashboardType == 2){
            dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.dashboardB.orignx doubleValue], [dash.dashboardB.origny doubleValue], [dash.dashboardB.orignwidth doubleValue], [dash.dashboardB.orignheight doubleValue])];
            dashboardStyleBView.tag =dash.pk ;
            [dashboardStyleBView initWithModel:dash.dashboardB];
            DashBoardTag = dashboardStyleBView.tag ;
            dashboardStyleBView.delegate =self;
            [scrollView addSubview:dashboardStyleBView];
        }
        if (dash.dashboardType == 3){
            dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.dashboardC.orignx doubleValue], [dash.dashboardC.origny doubleValue], [dash.dashboardC.orignwidth doubleValue], [dash.dashboardC.orignheight doubleValue])];
            dashboardStyleCView.tag = dash.pk ;
            [dashboardStyleCView initWithModel:dash.dashboardC];
            DashBoardTag = dashboardStyleCView.tag ;
            dashboardStyleCView.delegate = self;
            [scrollView addSubview:dashboardStyleCView];
        }
    }
}
- (void)initWithChangeCustomType:(NSInteger)type withTag:(NSInteger)tag{
    [self initWithData];
    NSString *findsql = [NSString stringWithFormat:@"WHERE  pk = %@",[NSNumber numberWithInteger:tag]];
    NSArray* pAll = [CustomDashboard findByCriteria:findsql];
    for(CustomDashboard *dashboard in pAll){
      
        switch (dashboard.dashboardType) {
            case 1:
            {
                NSLog(@"outerColor%@",dashboard.dashboardA.outerColor);
                //画底盘渐变色
                [dashboardStyleAView addGradientView:@"18181C" GradientViewWidth:dashboardStyleAView.frame.size.width];
                [dashboardStyleAView initWithModel:dashboard.dashboardA];
                dashboardStyleAView.infoLabel.text = _CustomLabelArray[dashboard.pk  - 1];
                dashboardStyleAView.numberLabel.text = _CustomNumberArray[dashboard.pk  - 1];
                dashboard.dashboardA.infoLabeltext = dashboardStyleAView.infoLabel.text;
                [dashboard update];
                dashboardStyleAView.delegate = self;
            }
                break;
            case 2:
            {
                [dashboardStyleBView initWithModel:dashboard.dashboardB];
                dashboardStyleBView.PIDLabel.text = _CustomLabelArray[tag-1];                
                dashboardStyleBView.NumberLabel.text = _CustomNumberArray[tag-1];
                dashboardStyleBView.delegate = self;
                dashboard.dashboardB.infoLabeltext = dashboardStyleBView.PIDLabel.text;
                [dashboard update];
                
            }
                break;
            case 3:
            {
                [dashboardStyleCView initWithModel:dashboard.dashboardC];
                dashboardStyleCView.delegate = self;
                dashboardStyleCView.PIDLabel.text = _CustomLabelArray[tag-1];
                dashboardStyleCView.NumberLabel.text = _CustomNumberArray[tag-1];
                dashboard.dashboardC.infoLabeltext = dashboardStyleCView.PIDLabel.text;
                [dashboard update];

            }
                break;
            default:
                break;
        }
       
        
        
    }

    
    [self MoveDashboard:tag];
}
#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
    DashBoardTag = 0;
   
    NSArray* pAllCount = [DashboardA findAll];
            for (DashboardA *dash in pAllCount) {
                NSLog(@"总共%d,orignx=%f",dash.pk, [dash.orignx doubleValue]);
                dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue], [dash.orignheight doubleValue])];
                dashboardStyleAView.tag = dash.pk ;
                //画底盘渐变色
                [dashboardStyleAView addGradientView:dash.outerColor  GradientViewWidth:dashboardStyleAView.frame.size.width];
                [dashboardStyleAView initWithModel:dash];
                DashBoardTag = dashboardStyleAView.tag ;
                [scrollView addSubview:dashboardStyleAView];
//                [self initWithChangeStyleA:dashboardStyleAView : dashboardStyleAView.tag -1] ;
            
            }

  
}
- (void)initWithChangeStyleA:(DashboardView *)view :(NSInteger)index{
    [self initWithData];
    
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: view.tag]];
    NSArray* pAll = [DashboardA findByCriteria:findsql];
    for(DashboardA* dashboard in pAll){
        
        if (dashboard.pk == view.tag) {
            NSLog(@"%ld -- %ld",(long)dashboard.pk ,(long)view.tag);
            NSLog(@"orignwidth%f",[dashboard.orignwidth doubleValue]);
            //画底盘渐变色
            [dashboardStyleAView addGradientView:dashboard.outerColor  GradientViewWidth:view.frame.size.width];
            [dashboardStyleAView initWithModel:dashboard];
            dashboardStyleAView.infoLabel.text = _LabelNameArray[dashboard.pk  - 1];
            dashboardStyleAView.numberLabel.text = _numberArray[dashboard.pk  - 1];
            dashboard.infoLabeltext = dashboardStyleAView.infoLabel.text;
            [dashboard update];
        }
    }
    dashboardStyleAView.delegate = self;
 
    
   

}

- (void)initWithStyleB{
    DashBoardTag = 0;
    NSArray* pAllCount = [DashboardB findAll];
    for (DashboardB *dash in pAllCount) {
        NSLog(@"总共%d",dash.pk);
        NSLog(@"_LabelNameArray%@",_LabelNameArray);
        
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue], [dash.orignheight doubleValue])];
        [dashboardStyleBView initWithModel:dash];
        dashboardStyleBView.tag = dash.pk ;
        DashBoardTag = dashboardStyleBView.tag ;
        [scrollView addSubview:dashboardStyleBView];
//        [self initWithChangeStyleB:dashboardStyleBView : dashboardStyleBView.tag -1] ;
    }
   
}
- (void)initWithChangeStyleB:(DashboardViewStyleB *)view :(NSInteger)index{
    [self initWithData];
    NSString *findsql = [NSString stringWithFormat:@"WHERE  pk = %@",[NSNumber numberWithInteger: view.tag]];
    NSArray* pAll = [DashboardB findByCriteria:findsql];
    for(DashboardB* dashboard in pAll){
      [view initWithModel:dashboard];
    
   
    view.delegate = self;
    //StyleB
  
    dashboardStyleBView.PIDLabel.text = _LabelNameArray[index];
    dashboardStyleBView.NumberLabel.text = _numberArray[index];
    dashboardStyleBView.delegate = self;
 
       [scrollView addSubview:dashboardStyleBView];
        dashboard.infoLabeltext= dashboardStyleBView.PIDLabel.text;
        [dashboard update];
    dashboardStyleBView.delegate = self;
     }
}

- (void)initWithStyleC{
    DashBoardTag = 0;
    NSArray* pAllCount = [DashboardC findAll];
    for (DashboardC *dash in pAllCount) {
        NSLog(@"总共%d",dash.pk);
        NSLog(@"_LabelNameArray%@",_LabelNameArray);
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue], [dash.orignheight doubleValue])];
        dashboardStyleCView.tag = dash.pk ;
        [dashboardStyleCView initWithModel:dash];
        DashBoardTag = dashboardStyleCView.tag ;
        [scrollView addSubview:dashboardStyleCView];
//        [self initWithChangeStyleC:dashboardStyleCView : dashboardStyleCView.tag -1] ;
    }

}

- (void)initWithChangeStyleC:(DashboardViewStyleC *)view :(NSInteger)index{
    [self initWithData];
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: view.tag]];
    NSArray* pAll = [DashboardC findByCriteria:findsql];
    for(DashboardC* dashboard in pAll){
        [view initWithModel:dashboard];
    view.delegate = self;
    dashboardStyleCView.PIDLabel.text = _LabelNameArray[index];
    dashboardStyleCView.NumberLabel.text = _numberArray[index];
    
    [scrollView addSubview:dashboardStyleCView];
        dashboard.infoLabeltext = dashboardStyleCView.PIDLabel.text;
        [dashboard update];
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
//    dispatch_source_cancel(_timer);
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
           [DashboardSetting sharedInstance].isAddDashboard = YES;
           [DashboardSetting sharedInstance].CurrentPage = pageControl.currentPage;
           SelectStyleViewController *vc =   [[SelectStyleViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
                     
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
//            dispatch_source_cancel(_timer);
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
    
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger:sender.view.tag]];
    NSArray* pAll = [CustomDashboard findByCriteria:findsql];
    for(CustomDashboard *dashboard in pAll){
        switch (dashboard.dashboardType) {
            case 1:
            {
                [self updateCustomType:1 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
                break;
            case 2:
            {
                [self updateCustomType:2 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
                break;
            case 3:
            {
                [self updateCustomType:3 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
                break;
            default:
                break;
        }
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
//                    dispatch_source_cancel(_timer);
                    PIDSelectViewController *vc = [[PIDSelectViewController alloc]init ];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case DashboardCustomMode:{
                    // 关闭定时器
//                    dispatch_source_cancel(_timer);
                    
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
    [DashboardA clearTable];
    [DashboardB clearTable];
    [DashboardC clearTable];
    [CustomDashboard clearTable];
    [[DashboardSetting sharedInstance] initWithdashboardA];
    [[DashboardSetting sharedInstance] initWithdashboardB];
    [[DashboardSetting sharedInstance] initWithdashboardC];
    [[DashboardSetting sharedInstance] initwithCustomDashboard];

    [DashboardSetting sharedInstance].KPageNumer = 4;
    [self clearAllUserDefaultsData];
    [self  updateView];
   
    
}
#pragma mark 使仪表盘移动到最前面
- (void)moveFoneView{
   
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].isDashboardFont == YES ) {
        NSLog(@"CCqianm");
        NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
        NSArray* pAll = [CustomDashboard findByCriteria:findsql];
        for(CustomDashboard *dashboard in pAll){
            
            switch (dashboard.dashboardType) {
                case 1:
                {
                    DashboardView *view = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                    [[view superview] bringSubviewToFront:view];
                }
                    break;
                case 2:
                {
                    DashboardViewStyleB *view = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                    [[view superview] bringSubviewToFront:view];
                }
                    break;
                case 3:
                {
                    DashboardViewStyleC *view = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                    [[view superview] bringSubviewToFront:view];
                }
                    break;
                default:
                    break;
            }
            [DashboardSetting sharedInstance].isDashboardFont = NO;
    }
    }
}
#pragma mark 点击移动仪表盘，让它变颜色；
- (void)MoveDashboard:(NSInteger)indexTag{
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == indexTag &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        NSLog(@"CCC");
        scrollView.scrollEnabled = NO;

        NSString *findsql = [NSString stringWithFormat:@"WHERE  pk = %@",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
        NSArray* pAll = [CustomDashboard findByCriteria:findsql];
        for(CustomDashboard *dashboard in pAll){
            
            switch (dashboard.dashboardType) {
                case 1:
                {
                    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleAView.frame.size.width, dashboardStyleAView.frame.size.width)];
                    coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                    dashboardStyleAView.userInteractionEnabled = YES;
                    coverView.alpha = 0.2;
                    [dashboardStyleAView addSubview:coverView];

                }
                    break;
                case 2:
                {
                    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleBView.frame.size.width, dashboardStyleBView.frame.size.width)];
                    dashboardStyleBView.userInteractionEnabled = YES;
                    coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                    coverView.alpha = 0.2;
                    [dashboardStyleBView addSubview:coverView];
                }
                    break;
                case 3:
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

}

#pragma mark 点击添加
- (void)addDashboard{
    NSLog(@"点击添加one,%ld",(long)[DashboardSetting sharedInstance].CurrentPage );
    NSLog(@"点击,%ld",(long)[DashboardSetting sharedInstance].addStyle );

    
    switch ([DashboardSetting sharedInstance].addStyle) {
        case AddStyleOne:
        {
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleOne with:0];
            dashboardStyleAView = [[DashboardView alloc ]initWithFrame:CGRectMake([DashboardSetting sharedInstance].CurrentPage *MSWidth +(arc4random() % (int)200), (arc4random() % (int)300), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleAView.tag = ++ DashBoardTag;
            dashboardStyleAView.delegate =self;
            NSLog(@"插入插入%ld",(long)dashboardStyleAView.tag);
         NSArray* pAll = [CustomDashboard findAll];
             for(CustomDashboard *dashboard in pAll){
                 NSLog(@"插入dashboarddashboard%@",dashboard);
                if (dashboard.pk == dashboardStyleAView.tag) {
                    NSLog(@"插入插入");
                    [dashboardStyleAView addGradientView:dashboard.dashboardA.outerColor GradientViewWidth:dashboardStyleAView.frame.size.width];
                    [dashboardStyleAView initWithModel:dashboard.dashboardA];
                    [scrollView addSubview:dashboardStyleAView];
                }
             }
            
            [self updateCustomType:1 OrignX:dashboardStyleAView.frame.origin.x OrignY:dashboardStyleAView.frame.origin.y Width:dashboardStyleAView.frame.size.width Height:dashboardStyleAView.frame.size.height ID:dashboardStyleAView.tag];
            
            
         }
            break;
        case AddStyleTwo:
        {
            
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleTwo with:0];
         
            dashboardStyleBView = [[DashboardViewStyleB alloc ]initWithFrame:CGRectMake([DashboardSetting sharedInstance].CurrentPage*MSWidth+(arc4random() % (int)200), (arc4random() % (int)300 ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleBView.tag = ++ DashBoardTag;
            dashboardStyleBView.delegate =self;
             NSArray* pAll = [CustomDashboard findAll];
             for(CustomDashboard *dashboard in pAll){
            if (dashboard.pk == dashboardStyleBView.tag) {
                [dashboardStyleBView initWithModel:dashboard.dashboardB];
                [scrollView addSubview:dashboardStyleBView];
            }
             }
            [self updateCustomType:2 OrignX:dashboardStyleBView.frame.origin.x OrignY:dashboardStyleBView.frame.origin.y Width:dashboardStyleBView.frame.size.width Height:dashboardStyleBView.frame.size.height ID:dashboardStyleBView.tag];
        }
            break;
        case AddStyleThree:
        {
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleThree with:0];

            dashboardStyleCView = [[DashboardViewStyleC alloc ]initWithFrame:CGRectMake( [DashboardSetting sharedInstance].CurrentPage*MSWidth +(arc4random() % (int)200), (arc4random() % (int)300 ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleCView.tag = ++ DashBoardTag;
            dashboardStyleCView.delegate = self;
             NSArray* pAll = [CustomDashboard findAll];
             for(CustomDashboard *dashboard in pAll){
            if (dashboard.pk == dashboardStyleCView.tag) {
                [dashboardStyleCView initWithModel:dashboard.dashboardC];
                [scrollView addSubview:dashboardStyleCView];
            [scrollView addSubview:dashboardStyleCView];
            }
             }
             [self updateCustomType:3 OrignX:dashboardStyleCView.frame.origin.x OrignY:dashboardStyleCView.frame.origin.y Width:dashboardStyleCView.frame.size.width Height:dashboardStyleCView.frame.size.height ID:dashboardStyleCView.tag];
        }
            break;
            
        default:
            break;
    }
    
    NSArray *dash = [CustomDashboard findAll];
    for (CustomDashboard *model in dash) {
        NSLog(@"主键逐渐%d",model.pk);
    }
    
}
#pragma mark 点击移除
- (void)RemoveDisplay{
     [[DashboardSetting sharedInstance].defaults setInteger:[[DashboardSetting sharedInstance].defaults integerForKey:@"AddDashboardNumber"]-1 forKey:@"AddDashboardNumber"];
    
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
    NSArray* pAll = [CustomDashboard findByCriteria:findsql];
    for(CustomDashboard *dashboard in pAll){
        
        switch (dashboard.dashboardType) {
            case 1:
            {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [CustomDashboard deleteObjectsByCriteria:findsql];
                [dashboardStyleAView removeFromSuperview];
            }
                break;
            case 2:
            {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [CustomDashboard deleteObjectsByCriteria:findsql];
                [dashboardStyleBView removeFromSuperview];

            }
                break;
            case 3:
            {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [CustomDashboard deleteObjectsByCriteria:findsql];
                [dashboardStyleCView removeFromSuperview];
            }
                break;
            default:
                break;
        }    }
    
    NSArray *dash = [CustomDashboard findAll];
    for (CustomDashboard *model in dash) {
        NSLog(@"主键逐渐%d",model.pk);
    }
  
}
#pragma mark 更新最新的仪表盘
- (void)updateView{
     NSInteger current = pageControl.currentPage;
    [pageControl removeFromSuperview];
    [scrollView removeFromSuperview];
     [self initWithUI];
    [self initWithData];

     scrollView.contentOffset = CGPointMake(current*MSWidth, 0);
}
#pragma mark 移动代理
- (void)touchMoveWithcenterX:(CGFloat)centerX WithcenterY:(CGFloat)WithcenterY{
       scrollView.scrollEnabled = YES;
        [DashboardSetting sharedInstance].isDashboardMove = NO;
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
    NSArray* pAll = [CustomDashboard findByCriteria:findsql];
    for(CustomDashboard *dashboard in pAll){

        switch (dashboard.dashboardType) {
            case 1:
            {
                dashboard.dashboardA.orignx = [NSNumber numberWithFloat:centerX];
                dashboard.dashboardA.origny = [NSNumber numberWithFloat:WithcenterY];
                    }
                break;
            case 2:
            {
                dashboard.dashboardB.orignx = [NSNumber numberWithFloat:centerX];
                dashboard.dashboardB.origny = [NSNumber numberWithFloat:WithcenterY];
            }
                break;
            case 3:
            {
                dashboard.dashboardC.orignx = [NSNumber numberWithFloat:centerX];
                dashboard.dashboardC.origny = [NSNumber numberWithFloat:WithcenterY];
            }
                break;
            default:
                break;
        }
        [dashboard update];
        
    }
    
            [coverView removeFromSuperview];
            scrollView.scrollEnabled = YES;



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
    [self LoadUI];
}
@end
