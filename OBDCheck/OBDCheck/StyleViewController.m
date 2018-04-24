


//
//  StyleViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleViewController.h"
#import "UIViewController+NavBar.h"

@interface StyleViewController ()<switchCommonDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,selectColorDelegete,selectSwtichDelegete>
{
    UIScrollView *scrollView;
    NSInteger selectTag;
    UIButton *Fristbtn;
    CustomDashboard* model;
    UIView *btnView;//放四个按钮的View
    CGFloat slideValue;  //slide的前一个
    UILabel *ValueLabel;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *tableViewFrame;
@property (nonatomic,strong) UITableView *tableViewAxis;
@property (nonatomic,strong) UITableView *tableViewNeedle;
@property (nonatomic,strong) UITableView *tableViewRange;
@property (nonatomic,strong) NSMutableArray *FrameSectionSource;
@property (nonatomic,strong) NSMutableArray *AxisSectionSource;
@property (nonatomic,strong) NSMutableArray *NeedleSectionSource;
@property (nonatomic,strong) NSMutableArray *RangeSectionSource;

@property (nonatomic,strong) NSMutableArray *FrameRowTitleSource;
@property (nonatomic,strong) NSMutableArray *AxisRowTitleSource;
@property (nonatomic,strong) NSMutableArray *NeedleRowTitleSource;
@property (nonatomic,strong) NSMutableArray *RangeRowTitleSource;
@property (nonatomic,strong) NSNumber *indexID;
@property (nonatomic,assign) NSInteger CurrentSelectStyle;
@end

@implementation StyleViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Style" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.indexID =  [NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex] ;
    DLog(@"1231%@",self.indexID);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithHeadUI];
    
    [self initWithUI];
    
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (isLandscape) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
    }else{
        //翻转为竖屏时
        DLog(@"竖屏");
        [self setVerticalFrame];
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    self.DashViewA.frame = CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple);
    ValueLabel.frame = CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple);
     self.slider.frame = CGRectMake(CGRectGetMaxX(self.DashView.frame) + 10, CGRectGetMaxY(ValueLabel.frame )+10, MSWidth - self.DashViewA.frame.size.width-50*KFontmultiple , 20);
    [btnView removeFromSuperview];
    btnView = [[UIView alloc]initWithFrame:CGRectMake(29, CGRectGetMaxY(self.DashView.frame) + 40, MSWidth - 58, 24)];
    [self initWithBtnView];
    scrollView.frame =CGRectMake(0, CGRectGetMaxY(btnView.frame)+20, MSWidth, MSHeight);
    scrollView.contentSize = CGSizeMake(MSWidth*4,MSHeight - 237);
    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width/4)*self.CurrentSelectStyle,0);
    self.tableView.frame = CGRectMake(0, 0, MSWidth, MSHeight - 237-44-TopHigh);
    self.tableViewAxis.frame =CGRectMake(MSWidth, 0, MSWidth, MSHeight - 237-44-TopHigh);
    self.tableViewNeedle.frame = CGRectMake(MSWidth*2, 0, MSWidth, MSHeight - 237-44-TopHigh);
    self.tableViewRange.frame =CGRectMake(MSWidth*3, 0, MSWidth, MSHeight - 237-44-TopHigh) ;
    self.selectStyleElement = self.CurrentSelectStyle;
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    self.DashViewA.frame = CGRectMake(66*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple);
    ValueLabel.frame = CGRectMake(66*KFontmultiple, CGRectGetMaxY(self.DashViewA.frame)+10, 36*KFontmultiple, 23*KFontmultiple);
    self.slider.frame = CGRectMake(66*KFontmultiple, CGRectGetMaxY(ValueLabel.frame )+10, self.DashViewA.frame.size.width , 20);
    
    [btnView removeFromSuperview];
    btnView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DashViewA.frame)+25, 40, MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+40), 24)];
    [self initWithBtnView];
    scrollView.frame =CGRectMake(CGRectGetMaxX(self.DashViewA.frame)+10, CGRectGetMaxY(btnView.frame)+20, MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10), MSHeight);
    scrollView.contentSize = CGSizeMake((MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10))*4,MSHeight);
    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width/4)*self.CurrentSelectStyle,0);
    self.tableView.frame = CGRectMake(0, 0, (MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10)), MSHeight - 24-44-TopHigh);
    self.tableViewAxis.frame =CGRectMake((MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10)), 0, (MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10)), MSHeight - 24-44-TopHigh);
    self.tableViewNeedle.frame = CGRectMake((MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10))*2, 0, (MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10)), MSHeight - 24-44-TopHigh);
    self.tableViewRange.frame =CGRectMake((MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10))*3, 0, (MSWidth -(CGRectGetMaxX(self.DashViewA.frame)+10)), MSHeight - 24-44-TopHigh ) ;
    self.selectStyleElement = self.CurrentSelectStyle;

}
-(void)initWithBtnView{
  
    _datasource = [[NSMutableArray alloc]initWithObjects:@"Frame",@"Axis",@"Needle",@"Range", nil];
    
    for (NSInteger i = 0; i< 4; i++) {
        selectTag = 0;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(btnView.frame.size.width/4), 0, btnView.frame.size.width/4, 24)];
        [btn setTitle:_datasource[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont ToAdapFont:13];
        if (i == self.CurrentSelectStyle) {
            Fristbtn = btn;
            [Fristbtn setTitleColor:[ColorTools colorWithHexString:@"#212329"] forState:UIControlStateNormal];
            Fristbtn.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        }else{
            [btn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
        }
        
        
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btnView addSubview:btn];
    }
    for (NSInteger i = 0; i< 5; i++) {
        UIView *LineView = [[UIView alloc]initWithFrame:CGRectMake(i*(btnView.bounds.size.width)/4, 0, 1, btnView.bounds.size.height)];
        LineView.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        [btnView addSubview:LineView];
    }
    for (NSInteger i = 0; i< 2; i++) {
        UIView *LineView = [[UIView alloc]initWithFrame:CGRectMake(0, i*(btnView.bounds.size.height), btnView.bounds.size.width,1)];
        LineView.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        [btnView addSubview:LineView];
    }
    [self.view addSubview:btnView];
}
- (void)initWithData{
    _FrameSectionSource = [[NSMutableArray alloc]initWithObjects:@"ANGLES",@"BACKGROUND COLOR",@"TITLE LABEL",@"VALUE LABEL",@"UNITS LABEL", nil];
    
    _AxisSectionSource = [[NSMutableArray alloc]initWithObjects:@"MAJOR TICKS",@"MINOR TICKS",@"LABELS", nil];
    _NeedleSectionSource = [[NSMutableArray alloc]initWithObjects:@"LABELS",@"KNOB", nil];
    
    _RangeSectionSource = [[NSMutableArray alloc]initWithObjects:@"FILL", nil];
    
    _FrameRowTitleSource = [[NSMutableArray alloc]initWithObjects:@"Start Angle",@"End Angle",@"Inner Color",@"Outer Color",@"Title Color",@"Font Scale",@"Position",@"Value Visible",@"Value Color",@"Font Scale",@"Position",@"Units Color",@"Font Scale",@"Vertical Position",@"Horizontal Position", nil];
    _AxisRowTitleSource = [[NSMutableArray alloc]initWithObjects:@"Width",@"Length",@"Color",@"Visible",@"Rotate",@"Fonts Scale",@"Offest From Tickline", nil];
    _NeedleRowTitleSource = [[NSMutableArray alloc]initWithObjects:@"Visible",@"Width",@"Length",@"Color",@"Radius",@"Color", nil];
    _RangeRowTitleSource = [[NSMutableArray alloc]initWithObjects:@"Enabled",@"Start Angle",@"End Angle",@"Color", nil];
    
    
    
}
- (void)initWithHeadUI{
    DLog(@"headU");
    
    CustomDashboard *dashboard = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:[DashboardSetting sharedInstance].Dashboardindex].lastObject;
    
    model = dashboard;
    self.DashViewA = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
    DLog(@"%@",dashboard);
    [self.DashViewA addGradientView:dashboard.DashboardAouterColor  GradientViewWidth:self.DashViewA.frame.size.width];
    [self.DashViewA initWithModel:dashboard];
    self.DashView = self.DashViewA;
    [self.view addSubview:self.DashViewA];
    ValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    ValueLabel.text = @"Value";
    ValueLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    ValueLabel.font = [UIFont ToAdapFont:14.f];
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DashView.frame) + 10, CGRectGetMaxY(ValueLabel.frame )+10, MSWidth - self.DashViewA.frame.size.width-50*KFontmultiple , 20)];
    
    self.slider.minimumValue = [model.DashboardminNumber floatValue];
    self.slider.maximumValue = [model.DashboardmaxNumber floatValue];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    self.slider.tag = 20;
    slideValue = self.slider.value;
    [self.view addSubview:ValueLabel];
    [self.view  addSubview:self.slider];
    [self.view  addSubview:self.NumberLabel];
    
}

- (void)initWithUI{
    
    //创建滚动视图
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnView.frame)+20, MSWidth, MSHeight)];
    scrollView.contentSize = CGSizeMake(MSWidth*4,MSHeight - 237);
    scrollView.delegate = self;
    scrollView.pagingEnabled=YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight - 237-44-TopHigh) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    self.CurrentSelectStyle = SelectFrame;
    [scrollView addSubview:self.tableView];
    
    self.tableViewAxis = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth, 0, MSWidth, MSHeight - 237-44-TopHigh) style:UITableViewStyleGrouped];
    self.tableViewAxis.dataSource = self;
    self.tableViewAxis.delegate = self;
    self.tableViewAxis.backgroundColor = [UIColor clearColor];
    self.tableViewAxis.separatorStyle = NO;
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewAxis];
    
    
    self.tableViewNeedle = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*2, 0, MSWidth, MSHeight - 237-44-TopHigh) style:UITableViewStyleGrouped];
    self.tableViewNeedle.dataSource = self;
    self.tableViewNeedle.delegate = self;
    self.tableViewNeedle.backgroundColor = [UIColor clearColor];
    self.tableViewNeedle.separatorStyle = NO;
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewNeedle];
    
    self.tableViewRange = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*3, 0, MSWidth, MSHeight - 237-44-TopHigh) style:UITableViewStyleGrouped];
    self.tableViewRange.dataSource = self;
    self.tableViewRange.delegate = self;
    self.tableViewRange.backgroundColor = [UIColor clearColor];
    self.tableViewRange.separatorStyle = NO;
    [self.tableViewRange registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewRange registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewRange registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewRange];
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            return 5;
        }
            break;
        case SelectAxis:
        {
            return 3;
        }
            break;
        case SelectNeedle:
        {
            return 2;
        }
            break;
        case SelectRange:
        {
            return 1;
        }
            break;
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            if (section == 0 || section == 1) {
                return 2;
            }else if (section == 3 || section == 4){
                return 4;
            }else{
                return 3;
            }
        }
            break;
        case SelectAxis:
        {
            if (section == 0 || section == 1) {
                return 3;
            }else{
                return 4;
            }
        }
            break;
        case SelectNeedle:
        {
            if (section == 0 ) {
                return 4;
            }else{
                return 2;
            }        }
            break;
        case SelectRange:
        {
            return 4;
        }
            break;
        default:
            break;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 44)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, MSWidth-15, 30)];
    label.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    label.font = [UIFont ToAdapFont:14.f];
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            label.text = _FrameSectionSource[section];
            
        }
            break;
        case SelectAxis:
        {
            label.text =  _AxisSectionSource[section];
            
        }
            break;
        case SelectNeedle:
        {
            label.text = _NeedleSectionSource[section];
            
        }
            break;
        case SelectRange:
        {
            label.text = _RangeSectionSource[section];
            
        }
            break;
        default:
            break;
    }
    [headView addSubview:label];
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            if (indexPath.section == 1 ) {
                return 44.f;
            }else if (indexPath.section == 2 && indexPath.row == 0 ){
                return 44.f;
            }else if (indexPath.section == 3 && (indexPath.row==0 || indexPath.row==1)){
                return 44.f;
            }else if (indexPath.section == 4 && indexPath.row==0){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        case SelectAxis:
        {
            if (indexPath.section == 0 && indexPath.row == 2 ){
                return 44.f;
            }else if (indexPath.section == 2 && (indexPath.row==0 || indexPath.row==1)){
                return 44.f;
            }else if (indexPath.section == 1 && indexPath.row==2){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        case SelectNeedle:
        {
            if (indexPath.section == 0 && (indexPath.row==0 || indexPath.row==3)){
                return 44.f;
            }else if (indexPath.section == 1 && indexPath.row==1){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        case SelectRange:
        {
            if ( indexPath.row==0 || indexPath.row==3){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *resultCell = [[UITableViewCell alloc]init];
    resultCell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    StyleOneTableViewCell *StyleOneCell = [tableView dequeueReusableCellWithIdentifier:@"StyleOneTableViewCell"];
    [ StyleOneCell.NumberSider    addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    StyleOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
    StyleOneCell.dashboardType = 1;
    StyleTwoTableViewCell *StyleTwoCell = [tableView dequeueReusableCellWithIdentifier:@"StyleTwoTableViewCell"];
    StyleTwoCell.delegate = self;
    StyleTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak __typeof(&*self)weakSelf = self;
    StyleTwoCell.colorClick = ^(NSString *color){
        DLog(@"diandiandianji%@",color);
        weakSelf.selectColor = color;
    };
    
    StyleThreeTableViewCell *StyleThreeCell = [tableView dequeueReusableCellWithIdentifier:@"StyleThreeTableViewCell"];
    StyleThreeCell.delegate  =self;
    StyleThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            switch (indexPath.section) {
                case 0:
                {
                    StyleOneCell.titleName.text = _FrameRowTitleSource[indexPath.row];
                    StyleOneCell.NumberSider.minimumValue = -2*M_PI;
                    StyleOneCell.NumberSider.maximumValue = 2*M_PI;
                    
                    switch (indexPath.row) {
                        case 0:{
                            StyleOneCell.NumberSider.value = [model.DashboardAStartAngle floatValue];
                            
                            StyleOneCell.NumberSider.tag = 0;
                            
                        }
                            break;
                        case 1:{
                            StyleOneCell.NumberSider.value = [model.DashboardAendAngle floatValue];
                            StyleOneCell.NumberSider.tag = 1;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.f",(360/(2*M_PI))*StyleOneCell.NumberSider.value];
                    
                }
                    break;
                case 1:
                {
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[indexPath.row + 2];
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleTwoCell.ColorView.tag = 0;
                            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAinnerColor];
                            StyleTwoCell.ColorLabel.text = model.DashboardAinnerColor;
                        }
                            break;
                        case 1:
                        {
                            StyleTwoCell.ColorView.tag = 1;
                            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAouterColor];
                            StyleTwoCell.ColorLabel.text = model.DashboardAouterColor;
                            
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 2:
                {
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[4];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAtitleColor];
                    StyleTwoCell.ColorLabel.text = model.DashboardAtitleColor;
                    StyleOneCell.titleName.text = _FrameRowTitleSource[indexPath.row +4];
                    StyleOneCell.NumberSider.tag = indexPath.row +4 ;
                    
                    switch (indexPath.row) {
                        case 0:{
                            StyleTwoCell.ColorView.tag = 2;
                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardAtitleFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 2;
                            
                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardAtitlePosition floatValue
                                                              ];
                            StyleOneCell.NumberSider.tag = 3;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                }
                    break;
                case 3:
                {
                    StyleThreeCell.titleName.text = _FrameRowTitleSource[7];
                    StyleThreeCell.SwitchBtn.tag = 0;
                    StyleThreeCell.SwitchBtn.on = model.DashboardAValueVisble;
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[8];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAValueColor];
                    StyleTwoCell.ColorLabel.text = model.DashboardAValueColor;
                    StyleOneCell.titleName.text = _FrameRowTitleSource[indexPath.row +7];
                    StyleOneCell.tag = indexPath.row +7 ;
                    
                    switch (indexPath.row) {
                        case 1:{
                            StyleTwoCell.ColorView.tag = 3;
                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardAValueFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 4;
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardAValuePosition floatValue];
                            StyleOneCell.NumberSider.tag = 5;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                }
                    break;
                case 4:
                {
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[11];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAUnitColor];
                    StyleTwoCell.ColorLabel.text = model.DashboardAUnitColor;
                    StyleOneCell.titleName.text = _FrameRowTitleSource[indexPath.row +11];
                    switch (indexPath.row) {
                        case 0:{
                            StyleTwoCell.ColorView.tag = 4;
                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardAUnitFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 6;
                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardAValuePosition floatValue];
                            
                            StyleOneCell.NumberSider.tag = 7;
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardAUnitHorizontalPosition floatValue];
                            StyleOneCell.NumberSider.tag = 8;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                }
                    break;
                default:
                    break;
            }
            
            if (indexPath.section == 1 ) {
                
                resultCell = StyleTwoCell;
            }else if ((indexPath.section == 2 || indexPath.section == 4)  && indexPath.row==0  ){
                
                resultCell = StyleTwoCell;
            }else if (indexPath.section == 3 && ( indexPath.row==1)){
                resultCell = StyleTwoCell;
            }else if (indexPath.section == 3 && ( indexPath.row==0)){
                resultCell = StyleThreeCell;
            }else{
                resultCell = StyleOneCell;
            }
            
        }
            break;
        case SelectAxis:
        {
            switch (indexPath.section) {
                case 0:
                {
                    StyleOneCell.titleName.text = _AxisRowTitleSource[indexPath.row];
                    StyleTwoCell.titleName.text = _AxisRowTitleSource[indexPath.row];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAmaColor];
                    StyleTwoCell.ColorLabel.text = model.DashboardAmaColor;
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 2;
                            StyleOneCell.NumberSider.maximumValue = 10;
                            StyleOneCell.NumberSider.value = [model.DashboardAmaWidth floatValue];
                            StyleOneCell.NumberSider.tag = 9;
                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 30;
                            StyleOneCell.NumberSider.value = [model.DashboardAmaLength floatValue];
                            StyleOneCell.NumberSider.tag = 10;
                        }
                            break;
                        case 2:{
                            StyleTwoCell.ColorView.tag = 5;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                }
                    break;
                case 1:
                {
                    StyleOneCell.titleName.text = _AxisRowTitleSource[indexPath.row];
                    StyleTwoCell.titleName.text = _AxisRowTitleSource[indexPath.row];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAmiColor];
                    StyleTwoCell.ColorLabel.text = model.DashboardAmiColor;
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 2;
                            StyleOneCell.NumberSider.maximumValue = 10;
                            StyleOneCell.NumberSider.tag = 11;
                            StyleOneCell.NumberSider.value = [model.DashboardAmiWidth floatValue];
                            
                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 30;
                            StyleOneCell.NumberSider.tag = 12;
                            StyleOneCell.NumberSider.value = [model.DashboardAmaLength floatValue];
                            
                        }
                            break;
                        case 2:{
                            StyleTwoCell.ColorView.tag = 6;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                }
                    break;
                case 2:
                {
                    StyleThreeCell.titleName.text = _AxisRowTitleSource[indexPath.row +3];
                    StyleOneCell.titleName.text = _AxisRowTitleSource[indexPath.row+3];
                    switch (indexPath.row) {
                        case 0:{
                            StyleThreeCell.SwitchBtn.tag = 1;
                            StyleThreeCell.SwitchBtn.on =   model.DashboardALabelVisble;
                        }
                            break;
                        case 1:{
                            StyleThreeCell.SwitchBtn.tag = 2;
                            StyleThreeCell.SwitchBtn.on =  model.DashboardALabelRotate;
                            
                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardALabelFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 13;
                            
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.DashboardALabelOffest floatValue];
                            StyleOneCell.NumberSider.tag = 14;
                            StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
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
            if ((indexPath.section == 0 || indexPath.section == 1)&& indexPath.row == 2 ){
                resultCell = StyleTwoCell;
            }else if (indexPath.section == 2 && (indexPath.row==0 || indexPath.row==1)){
                resultCell = StyleThreeCell;
            }else {
                resultCell = StyleOneCell;
            }
        }
            break;
        case SelectNeedle:
        {
            switch (indexPath.section) {
                case 0:
                {
                    StyleThreeCell.titleName.text = _NeedleRowTitleSource[indexPath.row];
                    StyleThreeCell.SwitchBtn.tag = 3;
                    StyleThreeCell.SwitchBtn.on = model.DashboardAPointerVisble;
                    StyleOneCell.titleName.text = _NeedleRowTitleSource[indexPath.row];
                    StyleTwoCell.titleName.text = _NeedleRowTitleSource[indexPath.row];
                    switch (indexPath.row) {
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 18.f;
                            StyleOneCell.NumberSider.value  = [model.DashboardAPointerWidth floatValue];
                            StyleOneCell.NumberSider.tag = 15;
                            
                            
                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue =  1;
                            StyleOneCell.NumberSider.value  = [model.DashboardAPointerLength floatValue];
                            StyleOneCell.NumberSider.tag = 16;
                            
                            
                        }
                            break;
                        case 3:{
                            StyleTwoCell.ColorView.tag = 7;
                            StyleTwoCell.ColorView.backgroundColor  =[ColorTools colorWithHexString:model.DashboardAPointerColor];
                            StyleTwoCell.ColorLabel.text = model.DashboardAPointerColor;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                }
                    break;
                case 1:
                {
                    StyleOneCell.titleName.text = _NeedleRowTitleSource[4];
                    StyleTwoCell.titleName.text = _NeedleRowTitleSource[5];
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 20;
                    StyleOneCell.NumberSider.value  = [model.DashboardAKNOBRadius floatValue];
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    StyleOneCell.NumberSider.tag = 17;
                    StyleTwoCell.ColorView.tag = 8;
                    StyleTwoCell.ColorView.backgroundColor  = [ColorTools colorWithHexString:model.DashboardAKNOBColor];
                    StyleTwoCell.ColorLabel.text  = model.DashboardAKNOBColor;
                }
                    break;
                default:
                    break;
            }
            if (indexPath.section == 0 && indexPath.row==0 ){
                resultCell = StyleThreeCell;
            }else if (  indexPath.section == 0 && indexPath.row==3){
                resultCell = StyleTwoCell;
            }else if(indexPath.section == 1 && indexPath.row==1)
            {
                resultCell = StyleTwoCell;
            }else{
                resultCell = StyleOneCell;
            }
        }
            break;
        case SelectRange:
        {
            StyleThreeCell.titleName.text = _RangeRowTitleSource[0];
            StyleThreeCell.SwitchBtn.tag = 4;
            StyleThreeCell.SwitchBtn.on = model.DashboardAFillenabled;
            StyleOneCell.titleName.text = _RangeRowTitleSource[indexPath.row ];
            StyleTwoCell.titleName.text = _RangeRowTitleSource[indexPath.row];
            StyleOneCell.NumberSider.minimumValue = -2*M_PI;
            StyleOneCell.NumberSider.maximumValue = 2*M_PI;
            if ( indexPath.row==0 ){
                resultCell = StyleThreeCell;
            }else if(indexPath.row==3){
                resultCell = StyleTwoCell;
            }else{
                resultCell = StyleOneCell;
            }
            
            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 18;
                    
                    StyleOneCell.NumberSider.value = [model.DashboardAFillstartAngle floatValue];
                    
                    
                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 19;
                    StyleOneCell.NumberSider.value = [model.DashboardAFillEndAngle floatValue];
                    
                }
                case 3:{
                    StyleTwoCell.ColorView.tag = 9;
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.DashboardAFillColor];
                    StyleTwoCell.ColorLabel.text = model.DashboardAFillColor;
                }
                    break;
                default:
                    break;
            }
            StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
        }
            break;
        default:
            break;
    }
    return resultCell;
    
}


- (void)btn:(UIButton *)btn{
    DLog(@"111===%ld",(long)btn.tag);
    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width/4)*btn.tag,0);
    switch (btn.tag) {
        case 0:
        {
            self.selectStyleElement = SelectFrame;
            self.CurrentSelectStyle = SelectFrame;
            [self.tableViewFrame reloadData ];
        }
            break;
        case 1:
        {
            self.selectStyleElement = SelectAxis;
            self.CurrentSelectStyle = SelectAxis;
            [self.tableViewAxis reloadData ];
            
        }
            break;
        case 2:
        {
            self.selectStyleElement = SelectNeedle;
            self.CurrentSelectStyle = SelectNeedle;
            [self.tableViewNeedle reloadData ];
            
        }
            break;
        case 3:
        {
            self.selectStyleElement = SelectRange;
            self.CurrentSelectStyle = SelectRange;
            [self.tableViewRange reloadData ];
            
        }
            break;
        default:
            break;
    }
    if (btn.tag != 0 && selectTag == 0) {
        DLog(@"yyyyy");
        [Fristbtn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
        Fristbtn.backgroundColor = [UIColor clearColor];
        
    }
    if (btn.tag==0) {
        selectTag=1;
    }
    if(selectBtn == btn ) {
        //上次点击过的按钮，不做处理
    } else{
        //本次点击的按钮设为黑色
        [btn setTitleColor:[ColorTools colorWithHexString:@"#212329"] forState:UIControlStateNormal];
        btn.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        
        
        //将上次点击过的按钮设为白色
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
        selectBtn.backgroundColor = [UIColor clearColor];
        
        
    }
    selectBtn= btn;
    
    
    
}

#pragma mark Slider的点击事件
- (void)sliderValueChanged:(id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider * slider = (UISlider *)sender;
        DLog(@"slide.tag%ld",(long)slider.tag);
        switch (slider.tag) {
            case 0:
            {
                model.DashboardAStartAngle = [NSString stringWithFormat:@"%f", slider.value ];
                [self upDateDashView];
            }
                break;
            case 1:
            {
                
                model.DashboardAendAngle = [NSString stringWithFormat:@"%f", slider.value ];
                [self upDateDashView];
            }
                break;
            case 2:
            {
                
                model.DashboardAtitleFontScale =  [NSString stringWithFormat:@"%f", slider.value];
                
                [self upDateDashView];
            }
                break;
            case 3:
            {
                model.DashboardAtitlePosition = [NSString stringWithFormat:@"%f", slider.value];
                
                [self upDateDashView];
            }
                break;
            case 4:
            {
                if (model.DashboardAValueVisble == YES) {
                    model.DashboardAValueFontScale =  [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 5:
            {
                if (model.DashboardAValueVisble == YES) {
                    model.DashboardAValuePosition =  [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 6:
            {
                model.DashboardAUnitFontScale =  [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                
                break;
            case 7:
            {
                model.DashboardAUnitVerticalPosition =  [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                break;
            case 8:
            {
                model.DashboardAUnitHorizontalPosition = [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                
                break;
                
            case 9:
            {
                model.DashboardAmaWidth =  [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                break;
            case 10:
            {
                model.DashboardAmaLength = [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                break;
            case 11:
            {
                model.DashboardAmiWidth =  [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                break;
            case 12:
            {
                model.DashboardAmiLength = [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                break;
            case 13:
            {
                if (model.DashboardALabelVisble == YES) {
                    model.DashboardALabelFontScale =  [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 14:
            {
                if (model.DashboardALabelVisble == YES) {
                    model.DashboardALabelOffest =  [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 15:
            {
                if (model.DashboardAPointerVisble == YES) {
                    model.DashboardAPointerWidth =  [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 16:
            {
                if (model.DashboardAPointerVisble == YES) {
                    model.DashboardAPointerLength = [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 17:
            {
                model.DashboardAKNOBRadius =  [NSString stringWithFormat:@"%f", slider.value];
                [self upDateDashView];
            }
                break;
            case 18:
            {
                if (model.DashboardAFillenabled == YES) {
                    model.DashboardAFillstartAngle =  [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 19:
            {
                if (model.DashboardAFillenabled == YES) {
                    model.DashboardAFillEndAngle =  [NSString stringWithFormat:@"%f", slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 20:
            {
                self.DashViewA.numberLabel.text = [NSString stringWithFormat:@"%.f",roundf(slider.value)];
                slideValue = slider.value;
                [self rotationWithView];
            }
                break;
            default:
                break;
        }
    }
    
    
}
- (void)rotationWithView{
    CGFloat Space =   ([model.DashboardAendAngle floatValue] - [model.DashboardAStartAngle floatValue])/([model.DashboardmaxNumber floatValue]  - [model.DashboardminNumber floatValue] );
    [self.DashViewA rotationWithStartAngle:[model.DashboardAStartAngle floatValue]  WithEndAngle:[model.DashboardAStartAngle  floatValue]+ slideValue*Space];
    
    
}
#pragma mark 外径颜色的变化
- (void)selectColorBetouched:(NSInteger)indexTag{
    DLog(@"indexTag==%ld",(long)indexTag);
    
    switch (indexTag) {
        case 0:
        {
            
            model.DashboardAinnerColor = self.selectColor;
            [self upDateDashView];
            
        }
            break;
        case 1:
        {
            model.DashboardAouterColor = self.selectColor;
            [self upDateDashView];
            
        }
            break;
        case 2:
        {
            model.DashboardAtitleColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 3:
        {
            if (model.DashboardAValueVisble == YES) {
                model.DashboardAValueColor = self.selectColor;
                [self upDateDashView];
            }
        }
            break;
        case 4:
        {
            model.DashboardAUnitColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 5:
        {
            model.DashboardAmaColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 6:
        {
            model.DashboardAmiColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 7:
        {
            model.DashboardAPointerColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 8:
        {
            model.DashboardAKNOBColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 9:
        {
            if (model.DashboardAFillenabled == YES) {
                model.DashboardAFillColor = self.selectColor;
                [self upDateDashView];
            }
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark 开关按钮
- (void)selectSwtichBetouched:(UISwitch *)switchBtn{
    DLog(@"开关tag%ld",  (long)switchBtn.tag);
//    DLog(@"开关on%ld",  switchBtn.on);
    switch (switchBtn.tag) {
        case 0:
        {
            model.DashboardAValueVisble = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 1:
        {
            model.DashboardALabelVisble = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 2:
        {
            model.DashboardALabelRotate = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 3:
        {
            model.DashboardAPointerVisble = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 4:
        {
            model.DashboardAFillenabled = switchBtn.on;
            [self upDateDashView];
        }
            break;
        default:
            break;
    }
}
#pragma mark 更新仪表盘
- (void)upDateDashView{
    [self.DashViewA removeFromSuperview];
    
    self.DashViewA = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
    //画底盘渐变色
    [self.DashViewA addGradientView:model.DashboardAouterColor GradientViewWidth:150*KFontmultiple];
    [self.DashViewA initWithModel:model];
    self.DashView = self.DashViewA;
    [self.view addSubview:self.DashViewA];
}
#pragma mark 返回仪表盘更新数据库
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    DLog(@"121");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           [[OBDataModel sharedDataBase]updateTableName:@"Dashboards" withdata:[model yy_modelToJSONString] withID:model.ID];
    });
}
-(void)rightBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    
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

//当滚动视图发生位移，就会进入下方代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end

