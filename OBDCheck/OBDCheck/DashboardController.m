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
    /*
     * 显示数字信息的label
     */
    UILabel *numberLabel;
    editDashboardsView *editview;
    UIScrollView *scrollView;
    UIPageControl *pageControl ;
    DashboardViewA *dashboardStyleAView;
    DashboardViewStyleB *dashboardStyleBView;
    DashboardViewStyleC *dashboardStyleCView;
    NSString *diameterPercent;
    NSString * LeftPercent;
    NSString * TopPercent;
    DashboardSetting *dashboardSet;
    
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
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, MSWidth, MSHeight)];
    scrollView.contentSize = CGSizeMake(MSWidth*[DashboardSetting sharedInstance].KPageNumer,0);
     scrollView.pagingEnabled = YES;
    [scrollView setShowsHorizontalScrollIndicator:NO];
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

#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
        for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
            
        dashboardStyleAView  = [[DashboardViewA alloc] initWithFrame:CGRectMake(index * (baseViewWidth+15 )+15,  page  * (baseViewHeight + 40), 150*KFontmultiple, 150*KFontmultiple )];
            dashboardStyleAView.tag = i;
            dashboardStyleAView.infoLabel.text = _LabelNameArray[i];
            
            NSString *diameterResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"diameterPercent%ld",dashboardStyleAView.tag]];
            
            NSString *LeftResult =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"LeftPercent%ld",dashboardStyleAView.tag]];
       
             NSString * TopResult =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"TopPercent%ld",dashboardStyleAView.tag]];
            
                NSLog(@"result1==%@ %@ %@",diameterResult,LeftResult,TopResult);
            
      
            NSLog(@"Move == %@",[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"test%ld",dashboardStyleAView.tag]]);
            
            if ([[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"test%ld",dashboardStyleAView.tag]] isEqualToString:@"YES"]) {
                
                NSLog(@"noonon");
                [dashboardStyleAView removeFromSuperview];
                dashboardStyleAView  = [[DashboardViewA alloc]initWithFrame: CGRectMake(([LeftResult floatValue]/100)*MSWidth, ([TopResult floatValue]/100)*MSHeight,([diameterResult floatValue]/100)*MSWidth,([diameterResult floatValue]/100)*MSWidth)];
                
//            }
//            if ([DashboardSetting sharedInstance].Dashboardindex == i &&  [DashboardSetting sharedInstance].isDashboardFont == YES ) {
//                NSLog(@"dddd");
//                [[dashboardStyleAView superview] bringSubviewToFront:dashboardStyleAView];
//                [DashboardSetting sharedInstance].isDashboardFont = NO;
//            }
//            if ([DashboardSetting sharedInstance].Dashboardindex == i &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
//                NSLog(@"CCC");
//
//                dashboardStyleAView.backgroundColor = [UIColor goldColor];
//                [DashboardSetting sharedInstance].isDashboardMove = NO;
//
            }
              [scrollView addSubview:dashboardStyleAView];
            UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            
         

        [dashboardStyleAView addGestureRecognizer:LongPress];
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleAView = [[DashboardViewA alloc] initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30), 220, 220)];
        [dashboardStyleAView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [scrollView addSubview:dashboardStyleAView];
        [scrollView addSubview:numberLabel];
    }
    
    dashboardStyleAView = [[DashboardViewA alloc] initWithFrame:CGRectMake(MSWidth*2+37, 88,300, 300)];
    [scrollView addSubview:dashboardStyleAView];
    [scrollView addSubview:numberLabel];
    [dashboardStyleAView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
}

- (void)initWithStyleB{
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
    dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(index * (baseViewWidth+15 )+15, page  * (baseViewHeight + 40), baseViewWidth, baseViewHeight)];
        [scrollView addSubview:dashboardStyleBView];
    [dashboardStyleBView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];

    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30), 220, 220)];
       [dashboardStyleBView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [scrollView addSubview:dashboardStyleBView];
    }
    
    dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth*2+37,  88,300, 300)];
    [scrollView addSubview:dashboardStyleBView];
   [dashboardStyleBView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
}
- (void)initWithStyleC{
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(index * (baseViewWidth+15 )+15, page  * (baseViewHeight + 40), baseViewWidth, baseViewHeight)];
        [dashboardStyleCView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];        [scrollView addSubview:dashboardStyleCView];
        
    }
    //第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth+ MSWidth/2 - 100,  i  * (220+ 30), 220, 220)];
        [dashboardStyleCView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];        [scrollView addSubview:dashboardStyleCView];
    }
    
    dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth*2+37,  88,300, 300)];
    [scrollView addSubview:dashboardStyleCView];
    [dashboardStyleCView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
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
   editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(85*MSWidth/375, 50, MSWidth -85*MSWidth/375 , 376+44)];
    editview.delegate = self;
    [editview show];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [editview hide];
   
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
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
        case 4:{
            NSLog(@"添加一页");
            [DashboardSetting sharedInstance].KPageNumer = [DashboardSetting sharedInstance].KPageNumer +1;
            [DashboardSetting sharedInstance].KPageNumer = [DashboardSetting sharedInstance].KPageNumer +1;
            scrollView.contentSize = CGSizeMake([DashboardSetting sharedInstance].KPageNumer ,0);
            pageControl.numberOfPages = [DashboardSetting sharedInstance].KPageNumer ;
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
    NSLog(@" [sender view].tag %f", [[NSString stringWithFormat:@"%.2f",(CGFloat)sender.view.frame.size.width/MSWidth] floatValue] );
    NSLog(@" [sender view].tag %@", sender.view);
    [DashboardSetting sharedInstance].Dashboardindex = sender.view.tag;
    
    diameterPercent = [NSString stringWithFormat:@"%.f",((CGFloat)sender.view.frame.size.width/MSWidth)*100];
    
    LeftPercent =[NSString stringWithFormat:@"%.f",(CGFloat)(sender.view.frame.origin.x /MSWidth)*100 ];
    
    TopPercent  = [NSString stringWithFormat:@"%.f",(CGFloat)((sender.view.frame.origin.y +10)/MSHeight)*100];

    NSLog(@"123==%f,%f,%f",sender.view.frame.size.width,sender.view.frame.origin.x ,sender.view.frame.origin.y+10);
    NSLog(@"124 = %@,%@,%@",diameterPercent,LeftPercent,TopPercent);
    
    [[DashboardSetting sharedInstance].defaults setObject:diameterPercent forKey:[NSString stringWithFormat:@"diameterPercent%ld",sender.view.tag]];
     [[DashboardSetting sharedInstance].defaults setObject:LeftPercent forKey:[NSString stringWithFormat:@"LeftPercent%ld",sender.view.tag]];
      [[DashboardSetting sharedInstance].defaults setObject:TopPercent forKey:[NSString stringWithFormat:@"TopPercent%ld",sender.view.tag]];
    [[DashboardSetting sharedInstance].defaults setObject:@"YES" forKey:[NSString stringWithFormat:@"test%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    
    NSLog(@"%f",[[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TopPercent%ld",sender.view.tag]]);
    
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

#pragma mark 移除仪表盘
- (void)removeDashboard{
    NSLog(@"1212移除");
//    [[[scrollView subviews]objectAtIndex:0]removeFromSuperview];
    [scrollView removeFromSuperview];
    [self initWithUI];
}
#pragma mark 全部恢复默认仪表盘
- (void)LoadDefaultDashboards{
    [DashboardSetting sharedInstance].KPageNumer = 3;
    [self clearAllUserDefaultsData];
    [self  updateView];
        
}

#pragma mark 更新最新的仪表盘
- (void)updateView{
    [pageControl removeFromSuperview];
    [scrollView removeFromSuperview];
    [self initWithUI];
}
- (void)clearAllUserDefaultsData
{
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end
