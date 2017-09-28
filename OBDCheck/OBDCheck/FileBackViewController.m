//
//  FileBackViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/28.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FileBackViewController.h"

@interface FileBackViewController (){
    UIView *LineView;
    UIScrollView *contentScrollView;
}
@property(nonatomic,strong)NSMutableArray *btnDatasource;
@end

@implementation FileBackViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initNavBarTitle:@"Files" andLeftItemImageName:@"back" andRightItemName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self initWithData];
    [self initWithTitleView];
}
- (void)initWithData{
    self.btnDatasource = [[NSMutableArray alloc]initWithObjects:@"Chart",@"Data", nil];
    
    
}
- (void)initWithTitleView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 40)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"101010"];
    [self.view addSubview:headView];
    for (NSInteger i = 0; i< 2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*MSWidth/2, 0, MSWidth/2, 40)];
        [btn setTitle:self.btnDatasource[i] forState:UIControlStateNormal];
        [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    LineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, MSWidth/2, 2)];
      LineView.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
    [headView addSubview:LineView];
//
    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, MSWidth, MSHeight)];
    contentScrollView.contentSize = CGSizeMake(MSWidth*2,0);
    contentScrollView.pagingEnabled = YES;
    [contentScrollView setShowsHorizontalScrollIndicator:NO];
//    contentScrollView.backgroundColor  = [UIColor redColor];
    [self.view addSubview:contentScrollView];
//设置Time/Mileage的内容；
    FileInfoView *TimeView = [[FileInfoView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 100)];
    TimeView.titileLabel.text = @"Time/Mileage";
    TimeView.leftNumberLabel.text = @"0:00:16";
    TimeView.leftNameLabel.text = @"Time";
    TimeView.rightNameLabel.text = @"Mileage";
    TimeView.rightNumberLabel.text = @"310km";    
    [contentScrollView addSubview:TimeView];
    

}
- (void)btn:(UIButton *)btn{
    contentScrollView.contentOffset = CGPointMake(btn.tag*MSWidth, 0);
    switch (btn.tag) {
        case 0:
            {
            LineView.frame = CGRectMake(0, 38, MSWidth/2, 2);
            }
            break;
        case 1:
        {
           LineView.frame = CGRectMake(MSWidth/2, 38, MSWidth/2, 2);
            
        }
            break;
        default:
            break;
    }
    
}

@end
