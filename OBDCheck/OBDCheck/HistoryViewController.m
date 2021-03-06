//
//  HistoryViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *MYTableView;
}
@property (nonatomic,strong) NSMutableArray *sectiondatasource;
@end

@implementation HistoryViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"History Codes" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
   MYTableView.frame = CGRectMake(0, 0, MSWidth, MSHeight-TopHigh);
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
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initwithdata];
    [self initWithUI];
}
- (void)initwithdata{
   
    _sectiondatasource = [[NSMutableArray alloc]init];
    
    NSArray *array = [[OBDataModel sharedDataBase]findTable:@"troubleCodes" withConditionStr:@""] ;
    for (troubleCodeModel *model in array) {
        DLog(@"%@%@",model.currentTime,model.toubleCode);
    }
    DLog(@"array%@",array);
    [_sectiondatasource addObject:array];
    [self initWithtabUI];
}
- (void)initWithtabUI{
    
}


- (void)initWithUI{
    MYTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    MYTableView.backgroundColor = [ColorTools colorWithHexString:@"18191D"];
    MYTableView.delegate =self;
    MYTableView.dataSource =self;
    MYTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MYTableView];
    [MYTableView registerNib:[UINib nibWithNibName:@"DiagnosticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiagnosticsTableViewCell"];

}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectiondatasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *carlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, MSWidth, 24.f)];
//    troubleCodeModel *model = self.sectiondatasource[section];
//    carlabel.text = model.currentTime;
    carlabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    carlabel.font = [UIFont boldSystemFontOfSize:14.f];
    [headView addSubview:carlabel];
    
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(MSWidth-100, 20, 100, 24.f)];
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timedata = [dateformatter stringFromDate:senddate];
    timelabel.text = timedata;
    timelabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    timelabel.font = [UIFont boldSystemFontOfSize:14.f];
    timelabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:timelabel];

    [headView addSubview:carlabel];

    return headView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiagnosticsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"DiagnosticsTableViewCell"];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    return Cell;
}

@end
