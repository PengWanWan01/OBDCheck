//
//  DashboardController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardController.h"

@interface DashboardController ()<UIScrollViewDelegate>

@end

@implementation DashboardController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}
- (void)initWithUI{
    //创建
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 74, MSWidth, MSHeight - 74)];
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
    pageControl.frame = CGRectMake(0, self.view.frame.size.height - 40, MSWidth, 30);
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
    CGFloat baseViewWidth = (MSWidth)/2;
    CGFloat baseViewHeight = baseViewWidth;
    for (NSInteger i = 0; i< 6; i++) {
        NSInteger index = i % 2;
         NSInteger page = i / 2;
        DashboardView *dashboardView = [[DashboardView alloc] initWithFrame:CGRectMake(index * (baseViewWidth ),  page  * (baseViewHeight + 10), baseViewWidth, baseViewHeight)];
        [scrollView addSubview:dashboardView];
    }
//第二页的仪表盘
    for (NSInteger i = 0; i< 2; i++) {
      
        DashboardView *dashboardView = [[DashboardView alloc] initWithFrame:CGRectMake(MSWidth,  i  * (baseViewHeight *4/3), baseViewWidth*4/3, baseViewHeight*4/3)];
        [scrollView addSubview:dashboardView];
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
@end
