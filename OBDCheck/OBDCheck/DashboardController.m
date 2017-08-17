//
//  DashboardController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardController.h"

@interface DashboardController ()<UIScrollViewDelegate,selectStyleDelegete>
{
    /*
     * 显示数字信息的label
     */
    UILabel *numberLabel;
    editDashboardsView *editview;
}
@property (nonatomic,strong) NSMutableArray *LabelNameArray;
@property (nonatomic,strong) NSMutableArray *numberArray;

@end

@implementation DashboardController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithUI];
}
- (void)initWithData{
    _LabelNameArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery", nil];
    _numberArray = [[NSMutableArray alloc]init];
    
}
- (void)initWithUI{
    //创建
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, MSWidth, MSHeight)];
    scrollView.contentSize = CGSizeMake(MSWidth*3,0);
     scrollView.pagingEnabled = YES;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    //  添加页数控制视图 new = alloc + init
    UIPageControl *pageControl = [UIPageControl new
                                  ];
    //不要加到滚动视图中， 会随着滚动消失掉
    [self.view addSubview:pageControl];
    //    设置常用属性,距离屏幕下方60像素。
    pageControl.frame = CGRectMake(0, MSHeight- 100, MSWidth, 30);
    //    设置圆点的个数
    pageControl.numberOfPages = 3;
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
    CGFloat baseViewWidth = (MSWidth)/2 - 30;
    CGFloat baseViewHeight = baseViewWidth;
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
         NSInteger page = i / 2;
        DashboardView *dashboardView = [[DashboardView alloc] initWithFrame:CGRectMake(index * (baseViewWidth+15 )+15,  page  * (baseViewHeight + 40), baseViewWidth, baseViewHeight )];
         dashboardView.infoLabel.text = _LabelNameArray[i];
        [dashboardView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        
        numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(index * (baseViewWidth ), CGRectGetMaxY(dashboardView.frame) + 8, baseViewWidth, 20)];
        numberLabel.font = [UIFont boldSystemFontOfSize:17];
        numberLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = @"N/A";
        [scrollView addSubview:dashboardView];
        [scrollView addSubview:numberLabel];
    }
//第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
      
        DashboardView *dashboardView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth,  i  * (baseViewHeight *4/3+ 30), baseViewWidth*4/3, baseViewHeight*4/3)];
        numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(MSWidth, CGRectGetMaxY(dashboardView.frame) + 8, baseViewWidth*4/3, 20)];
        numberLabel.font = [UIFont boldSystemFontOfSize:17];
        numberLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = @"N/A";
        [scrollView addSubview:dashboardView];
        [scrollView addSubview:numberLabel];    }
//第三页的仪表盘
    DashboardViewStyleB *view = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(MSWidth*2, 30, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [scrollView addSubview:view];
    
    DashboardViewStyleC *viewB = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(MSWidth*2,self.view.frame.size.width/2+40 , self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [scrollView addSubview:viewB];
    
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
#pragma mark 点击啊弹框
-(void)AlertBetouched:(NSInteger)index{
   
    switch (index) {
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
  
        default:
            break;
    }
}
#pragma mark 长按仪表盘的手势
- (void)tap:(UILongPressGestureRecognizer *)sender{
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


}
#pragma mark 全部恢复默认仪表盘
- (void)LoadDefaultDashboards{


}
@end
