//
//  FileBackViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/28.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FileBackViewController.h"
static dispatch_source_t _timer;

@interface FileBackViewController ()<UITableViewDelegate,UITableViewDataSource,ChartViewDelegate>{
    UIView *LineView;
    UIScrollView *contentScrollView;
    NSInteger PIDNumber;
    FileInfoView *InfoView ;
    LineChartView *chartViewone ;
    LineChartView *chartViewTwo ;
    LogsModel *model;
    LineChartDataSet *set1;
    LineChartData *PartOnedata;
    LineChartData *PartTwodata;
    NSMutableArray *XdataSource;
    NSInteger indextag;
    UITableView *mytableView;
    UILabel *PlaybackLabel;
}
@property(nonatomic,strong)NSMutableArray *btnDatasource;
@property(nonatomic,strong)NSMutableArray *Datasource;
@property(nonatomic,strong)NSMutableArray *detailDatasource;


@end

@implementation FileBackViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initNavBarTitle:@"Files" andLeftItemImageName:@"back" andRightItemName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    PIDNumber = 3;
     [self initWithData];
    [self initWithTitleView];
}
- (void)initWithData{
    self.btnDatasource = [[NSMutableArray alloc]initWithObjects:@"Chart",@"Data", nil];
    self.Datasource = [[NSMutableArray alloc]initWithObjects:@"Beginning Time",@"End Time",@"Drive Time",@"Mileage",@"Fuel Cost",@"Charge",@"Max Speed",@"Average Speed",@"Overspeed Times",@"Overspeed Time",@"Idle Time",@"Score", nil];
    self.detailDatasource = [[NSMutableArray alloc]initWithObjects:@"2017-07-27 15:21:48",@"2017-07-27 15:21:48", @"00:00:00",@"0 Mile", @"0 G",@"0 USD", @"0 MPH",@"0 MPH",@"0",@"00:00:00", @"00:00:00",@"100",nil];
    set1 = nil;
    PartOnedata = [[LineChartData alloc] initWithDataSet:set1];
    PartTwodata = [[LineChartData alloc] initWithDataSet:set1];
    XdataSource = [[NSMutableArray alloc]init];
    indextag = 0;
    for (NSInteger i = 11; i < 3600; i++) {
        [XdataSource addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
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
//添加UIScrollView内容
    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, MSWidth*2, MSHeight)];
    contentScrollView.contentSize = CGSizeMake(MSWidth,MSHeight+100);
    contentScrollView.pagingEnabled = NO;
    [contentScrollView setShowsHorizontalScrollIndicator:NO];
//    [contentScrollView setShowsVerticalScrollIndicator:NO];
//    contentScrollView.backgroundColor  = [UIColor redColor];
    [self.view addSubview:contentScrollView];
    [self initWithChartUI];
    [self initWithDataUI];
    
}
#pragma mark 绘制左边Chart界面
- (void)initWithChartUI{
    //设置Time/Mileage的内容；
    FileInfoView *TimeView = [[FileInfoView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 100)];
    TimeView.titileLabel.text = @"Time/Mileage";
    TimeView.leftNumberLabel.text = @"0:00:16";
    TimeView.leftNameLabel.text = @"Time";
    TimeView.rightNameLabel.text = @"Mileage";
    TimeView.rightNumberLabel.text = @"310km";
    [contentScrollView addSubview:TimeView];
    
    //设置Playback的内容
    PlaybackLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(TimeView.frame)+30, MSWidth-15, 20)];
    PlaybackLabel.textColor = [ColorTools colorWithHexString:@"918E8E"];
    PlaybackLabel.text = @"Playback";
    [contentScrollView addSubview:PlaybackLabel];
    
    NSString *SQL  = [NSString stringWithFormat:@"LIMIT 0, 1"];
    NSArray *pAll = [LogsModel findByCriteria:SQL];
    for(LogsModel* logsmodel in pAll){
        NSLog(@"logsmodel.item1PID %@",logsmodel.item1PID  );
        model = logsmodel;
        if (model.item3Enabled == YES || model.item4Enabled == YES ) {
            [self initWithLogViewTwoPart];
           InfoView = [[FileInfoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewTwo.frame), MSWidth, 100)];

        }else{
            [self initWithLogView];
            InfoView = [[FileInfoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, 100)];
        }
    }
    [self startBtn];
    InfoView.titileLabel.text = @"Info";
    InfoView.leftNumberLabel.text = @"7.6 L/100km";
    InfoView.leftNameLabel.text = @"Average economy";
    InfoView.rightNumberLabel.text = @"78.6km/h";
    InfoView.rightNameLabel.text = @"Average Speed";
    [contentScrollView addSubview:InfoView];
}

- (void)initWithLogView{
    NSLog(@"弹出一个图");
    [chartViewone removeFromSuperview];
    [chartViewTwo removeFromSuperview];
    chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(PlaybackLabel.frame)+10, MSWidth,170)];
    [contentScrollView addSubview:chartViewone];
    [self initWithchartView:chartViewone Type:1];
    
    [self setDataCount:10 range:110 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item1PID withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:(model.item1Smoothing)];
    [self setDataCount:10 range:550 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item2PID withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:(model.item2Smoothing)];
    NSLog(@"getDataSetByIndex%@",[PartOnedata getDataSetByIndex:10]);
    [chartViewone animateWithXAxisDuration:5];
    //设置当前可以看到的个数
    [chartViewone setVisibleXRangeMaximum:10];
    //设置当前开始的位置
    [chartViewone moveViewToX:0];
    
}
- (void)initWithLogViewTwoPart{
    NSLog(@"弹出两个图%@", model.item1PID);
   
    [chartViewone removeFromSuperview];
    [chartViewTwo removeFromSuperview];
    chartViewone =[[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(PlaybackLabel.frame)+10, MSWidth,170)];
   
    chartViewTwo = [[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth,170)];
    if (IS_IPHONE_X) {
        chartViewTwo.frame = CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, (MSHeight - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34)/2);
    }
    [contentScrollView addSubview:chartViewone];
    [contentScrollView addSubview:chartViewTwo];
    [self initWithchartView:chartViewone Type:1];
    [self initWithchartView:chartViewTwo Type:2];
    [self setDataCount:100 range:110 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item1PID withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:(model.item1Smoothing)];
    [self setDataCount:100 range:550 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item2PID withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:(model.item2Smoothing)];
    [self setDataCount:100 range:110 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:model.item3PID withLineColor:[ColorTools colorWithHexString:@"3F51B5"] withDependency:AxisDependencyLeft iSsmoothing:(model.item3Smoothing)];
    if (model.item4Enabled == YES) {
        [self setDataCount:100 range:550 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:model.item4PID withLineColor:[ColorTools colorWithHexString:@"FF9800"] withDependency:AxisDependencyRight iSsmoothing:(model.item4Smoothing)];
    }
    [chartViewone animateWithXAxisDuration:1];
    //设置当前可以看到的个数
    [chartViewone setVisibleXRangeMaximum:10];
    //设置当前开始的位置
    [chartViewone moveViewToX:15];
    
    [chartViewTwo animateWithXAxisDuration:1];
    //设置当前可以看到的个数
    [chartViewTwo setVisibleXRangeMaximum:10];
    //设置当前开始的位置
    [chartViewTwo moveViewToX:15];
    
}
#pragma mark 绘制右边Data界面
- (void)initWithDataUI{
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth, 0, MSWidth, MSHeight-100) style:UITableViewStylePlain];
    mytableView.backgroundColor = [UIColor clearColor];
    mytableView.separatorInset = UIEdgeInsetsZero;
    mytableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    [contentScrollView addSubview:mytableView];
    [mytableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];

}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.textLabel.text = self.Datasource[indexPath.row];
      cell.detailTextLabel.text = self.detailDatasource[indexPath.row];
    if (indexPath.row == self.Datasource.count - 1) {
        cell.textLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
        cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];

    }else{
        cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    }
    return cell;
    
}
- (void)btn:(UIButton *)btn{
    contentScrollView.contentOffset = CGPointMake(btn.tag*MSWidth, 0);
    switch (btn.tag) {
        case 0:
            {
            LineView.frame = CGRectMake(0, 38, MSWidth/2, 2);
                contentScrollView.scrollEnabled = YES;
            }
            break;
        case 1:
        {
           LineView.frame = CGRectMake(MSWidth/2, 38, MSWidth/2, 2);
            contentScrollView.scrollEnabled = NO;

        }
            break;
        default:
            break;
    }
    
}
// 设置其中一条折线的内容，数据，颜色，宽度
- (void)setDataCount:(int)count range:(double)range withView:(LineChartView *)view withdata:(LineChartData *)linechartdata withPIDTiltle:(NSString *)title withLineColor:(UIColor *)color withDependency:(AxisDependency)Dependency  iSsmoothing:(BOOL)smoothing
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = range / 2.0;
        double val = (double) (arc4random_uniform(mult)) + 50;
        [yVals addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    set1 = [[LineChartDataSet alloc] initWithValues:yVals label:title];
    set1.axisDependency = Dependency;
    [set1 setColor:color];
    set1.highlightColor = [UIColor clearColor]; //点击时候的颜色
    set1.drawCircleHoleEnabled = NO;
    set1.lineWidth = 2.0;//折线宽度
    //折线拐点样式
    set1.drawCirclesEnabled = NO;//是否绘制拐点
    if (smoothing == YES) {
        [set1 setDrawCubicEnabled:YES];
    }
    [linechartdata addDataSet:set1];
    
    [linechartdata setValueTextColor:UIColor.clearColor];
    [linechartdata setValueFont:[UIFont systemFontOfSize:9.f]];
    
    view.data = linechartdata;
    
    
    
}
- (void)initWithchartView:(LineChartView *)view Type:(NSInteger)type{
    view.delegate = self;
    view.chartDescription.enabled = NO;
    view.dragEnabled = YES;
    [view setScaleEnabled:YES];
    view.pinchZoomEnabled = YES;
    view.drawGridBackgroundEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    view.gridBackgroundColor = [UIColor clearColor];
    
    ChartLegend *l = view.legend;
    l.form = ChartLegendFormLine;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.textColor = UIColor.whiteColor;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    ChartXAxis *xAxis = view.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.labelTextColor = UIColor.whiteColor;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.decimals = 6;
    xAxis.gridColor = [UIColor grayColor];
    //设置左边的Y轴
    ChartYAxis *leftAxis = view.leftAxis;
    leftAxis.labelTextColor = [UIColor whiteColor];
    leftAxis.axisMaximum = 200.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawAxisLineEnabled = YES;
    // 设置右边的Y轴
    ChartYAxis *rightAxis = view.rightAxis;
    rightAxis.labelTextColor = [UIColor whiteColor];
    rightAxis.axisMaximum = 900.0;
    rightAxis.axisMinimum = -200.0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.drawAxisLineEnabled = YES;
    rightAxis.axisLineWidth = 2;
    if (type ==2) {
        [leftAxis setAxisLineColor:[ColorTools colorWithHexString:@"3F51B5"]];
        [rightAxis setAxisLineColor:[ColorTools colorWithHexString:@"FF9800"]];
        if (model.item4Enabled == NO) {
            [rightAxis setAxisLineColor:[UIColor clearColor]];
            rightAxis.labelTextColor = [UIColor clearColor];
        }
    }else{
        [leftAxis setAxisLineColor:[ColorTools colorWithHexString:@"E51C23"]];
        [rightAxis setAxisLineColor:[ColorTools colorWithHexString:@"54C44B"]];
    }
    leftAxis.axisLineWidth = 2;
    leftAxis.labelCount = 5;
}
- (void)startBtn{
    //定时器
    NSTimeInterval period = 1; //设置时间间隔
    //5S后执行；
    int interval = 5;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * interval), period * NSEC_PER_SEC, 0); //每秒执行
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@,%ld",XdataSource,(long)[XdataSource[indextag] integerValue]);
            
            [self updateChartData:chartViewone withData:PartOnedata withIndex:1 withX:(int)[XdataSource[indextag] integerValue] withY:arc4random() % 900];
            [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:(int)[XdataSource[indextag] integerValue] withY:arc4random() % 200];
            if (model.item3Enabled == YES) {
                NSLog(@"item3item3");
                [self updateChartData:chartViewTwo withData:PartTwodata withIndex:0 withX:(int)[XdataSource[indextag] integerValue] withY:arc4random() % 200];
            }
            if (model.item4Enabled == YES) {
                [self updateChartData:chartViewTwo withData:PartTwodata withIndex:1 withX:(int)[XdataSource[indextag] integerValue] withY:arc4random() % 200];
            }
            ++indextag;
            if (indextag == XdataSource.count -1) {
                dispatch_source_cancel(_timer);
                
            }
        });
    });
    // 开启定时器
    dispatch_resume(_timer);
}
//添加动态数据 index代表第几根折线
- (void)updateChartData:(LineChartView *)view withData:(LineChartData *)linechartdata withIndex:(NSInteger)index  withX:(int)X withY:(int)Y
{
    [linechartdata addEntry:[[ChartDataEntry alloc]initWithX:X y:Y] dataSetIndex:index];
    //设置当前可以看到的个数
    [view setVisibleXRangeMaximum:10];
    //设置当前开始的位置
    [view moveViewToX:X - 10];
    [linechartdata notifyDataChanged];
    [view notifyDataSetChanged];
    NSLog(@"updateChartData%ld",(long)linechartdata.entryCount);
    
}

@end
