


//
//  StyleViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleViewController.h"

@interface StyleViewController ()<switchCommonDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,selectColorDelegete,selectSwtichDelegete>
{
    UIScrollView *scrollView;
    NSInteger selectTag;
    UIButton *Fristbtn;
    DashboardA* model;
    CustomDashboard *CustomDashModel;
    UIView *btnView;//放四个按钮的View
    CGFloat slideValue;  //slide的前一个
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
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        DLog(@"竖屏");
        [self setVerticalFrame];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
        
        
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    self.DashViewA.frame = CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple);
    btnView.frame = CGRectMake(29, CGRectGetMaxY(self.DashView.frame) + 40, MSWidth - 58, 24);
  scrollView.frame =CGRectMake(0, CGRectGetMaxY(btnView.frame)+20, SCREEN_MIN, SCREEN_MAX);
    scrollView.contentSize = CGSizeMake(SCREEN_MIN*4,SCREEN_MAX - 237);

//    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DashView.frame) + 10, CGRectGetMaxY(label.frame )+10, MSWidth - self.DashViewA.frame.size.width-50*KFontmultiple , 20)];
  
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    self.DashViewA.frame = CGRectMake(66*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple);
    btnView.frame = CGRectMake(SCREEN_MAX -(SCREEN_MIN - 58) - 20 , 25, (SCREEN_MIN - 58), 24);
    btnView.backgroundColor  = [UIColor redColor];
    scrollView.frame =CGRectMake(SCREEN_MAX -(SCREEN_MIN - 58) - 40, CGRectGetMaxY(btnView.frame)+20, SCREEN_MAX -(SCREEN_MIN - 58), SCREEN_MAX);
    scrollView.contentSize = CGSizeMake((SCREEN_MAX -(SCREEN_MIN - 58))*4,SCREEN_MAX);

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
    NSArray *all =@[@"BG_ID",@"=",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
    NSArray *findArr = [CustomDashboard bg_findWhere:all];
    for(CustomDashboard* dashboard in findArr){
        CustomDashModel = dashboard;
    model = dashboard.dashboardA;
    self.DashViewA = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
        DLog(@"%@",dashboard);
      [self.DashViewA addGradientView:dashboard.dashboardA.outerColor  GradientViewWidth:self.DashViewA.frame.size.width];
        [self.DashViewA initWithModel:dashboard.dashboardA];
            self.DashViewA.infoLabel.text =  self.infoLabeltext;
        self.DashViewA.infoLabel.text = dashboard.dashboardA.infoLabeltext;
            self.DashView = self.DashViewA;
            [self.view addSubview:self.DashViewA];
       
    }
   UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    label.text = @"Value";
    label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    label.font = [UIFont ToAdapFont:14.f];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DashView.frame) + 10, CGRectGetMaxY(label.frame )+10, MSWidth - self.DashViewA.frame.size.width-50*KFontmultiple , 20)];
   
    self.slider.minimumValue = [model.minNumber floatValue];
    self.slider.maximumValue = [model.maxNumber floatValue];
     [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    self.slider.tag = 20;
    slideValue = self.slider.value;
    btnView = [[UIView alloc]initWithFrame:CGRectMake(29, CGRectGetMaxY(self.DashView.frame) + 40, MSWidth - 58, 24)];
    _datasource = [[NSMutableArray alloc]initWithObjects:@"Frame",@"Axis",@"Needle",@"Range", nil];
    
    for (NSInteger i = 0; i< 4; i++) {
        selectTag = 0;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(btnView.frame.size.width/4), 0, btnView.frame.size.width/4, 24)];
        [btn setTitle:_datasource[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont ToAdapFont:13];
        if (i == 0) {
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
    [self.view addSubview:label];
    [self.view  addSubview:self.slider];
    [self.view  addSubview:self.NumberLabel];
    [self.view  addSubview:btnView];


}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
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
    self.selectStyleElement = SelectFrame;
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
    StyleTwoCell.colorClick = ^(NSString *color){
        DLog(@"diandiandianji%@",color);
        self.selectColor = color;
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
                            StyleOneCell.NumberSider.value = [model.StartAngle floatValue];
                            StyleOneCell.NumberSider.tag = 0;
                            
                        }
                            break;
                        case 1:{
                            StyleOneCell.NumberSider.value = [model.endAngle floatValue];
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
                            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.innerColor];
                            StyleTwoCell.ColorLabel.text = model.innerColor;
                        }
                            break;
                        case 1:
                        {
                            StyleTwoCell.ColorView.tag = 1;
                            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.outerColor];
                            StyleTwoCell.ColorLabel.text = model.outerColor;

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
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.titleColor];
                    StyleTwoCell.ColorLabel.text = model.titleColor;
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
                            StyleOneCell.NumberSider.value = [model.titleFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 2;

                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.titlePosition floatValue
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
                    StyleThreeCell.SwitchBtn.on = model.ValueVisble;
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[8];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.ValueColor];
                    StyleTwoCell.ColorLabel.text = model.ValueColor;
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
                            StyleOneCell.NumberSider.value = [model.ValueFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 4;
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.ValuePosition floatValue];
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
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.UnitColor];
                    StyleTwoCell.ColorLabel.text = model.UnitColor;
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
                            StyleOneCell.NumberSider.value = [model.UnitFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 6;
                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.ValuePosition floatValue];

                            StyleOneCell.NumberSider.tag = 7;
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.UnitHorizontalPosition floatValue];
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
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.maColor];
                    StyleTwoCell.ColorLabel.text = model.maColor;
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 2;
                            StyleOneCell.NumberSider.maximumValue = 10;
                            StyleOneCell.NumberSider.value = [model.maWidth floatValue];
                            StyleOneCell.NumberSider.tag = 9;
                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 30;
                            StyleOneCell.NumberSider.value = [model.maLength floatValue];
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
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.miColor];
                    StyleTwoCell.ColorLabel.text = model.miColor;
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 2;
                            StyleOneCell.NumberSider.maximumValue = 10;
                            StyleOneCell.NumberSider.tag = 11;
                            StyleOneCell.NumberSider.value = [model.miWidth floatValue];

                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 30;
                            StyleOneCell.NumberSider.tag = 12;
                            StyleOneCell.NumberSider.value = [model.maLength floatValue];

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
                            StyleThreeCell.SwitchBtn.on =   model.LabelVisble;
                        }
                            break;
                        case 1:{
                            StyleThreeCell.SwitchBtn.tag = 2;
                            StyleThreeCell.SwitchBtn.on =  model.LabelRotate;

                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.LabelFontScale floatValue];
                            StyleOneCell.NumberSider.tag = 13;

                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 2;
                            StyleOneCell.NumberSider.value = [model.LabelOffest floatValue];
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
                    StyleThreeCell.SwitchBtn.on = model.PointerVisble;
                    StyleOneCell.titleName.text = _NeedleRowTitleSource[indexPath.row];
                    StyleTwoCell.titleName.text = _NeedleRowTitleSource[indexPath.row];
                    switch (indexPath.row) {
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 18.f;
                            StyleOneCell.NumberSider.value  = [model.PointerWidth floatValue];
                            StyleOneCell.NumberSider.tag = 15;


                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue =  75*KFontmultiple;
                            StyleOneCell.NumberSider.value  = [model.PointerLength floatValue];
                            StyleOneCell.NumberSider.tag = 16;


                        }
                            break;
                        case 3:{
                            StyleTwoCell.ColorView.tag = 7;
                            StyleTwoCell.ColorView.backgroundColor  =[ColorTools colorWithHexString:model.PointerColor];
                            StyleTwoCell.ColorLabel.text = model.PointerColor;
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
                    StyleOneCell.NumberSider.value  = [model.KNOBRadius floatValue];
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    StyleOneCell.NumberSider.tag = 17;
                    StyleTwoCell.ColorView.tag = 8;
                    StyleTwoCell.ColorView.backgroundColor  = [ColorTools colorWithHexString:model.KNOBColor];
                    StyleTwoCell.ColorLabel.text  = model.KNOBColor;
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
            StyleThreeCell.SwitchBtn.on = model.Fillenabled;
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
                   
                    StyleOneCell.NumberSider.value = [model.FillstartAngle floatValue];


                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 19;
                    StyleOneCell.NumberSider.value = [model.FillEndAngle floatValue];

                }
                case 3:{
                    StyleTwoCell.ColorView.tag = 9;
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.FillColor];
                    StyleTwoCell.ColorLabel.text = model.FillColor;
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
    scrollView.contentOffset = CGPointMake(MSWidth*btn.tag,0);
    switch (btn.tag) {
        case 0:
        {
            self.selectStyleElement = SelectFrame;
            [self.tableViewFrame reloadData ];
        }
            break;
        case 1:
        {
            self.selectStyleElement = SelectAxis;
            [self.tableViewAxis reloadData ];
            
        }
            break;
        case 2:
        {
            self.selectStyleElement = SelectNeedle;
            [self.tableViewNeedle reloadData ];
            
        }
            break;
        case 3:
        {
            self.selectStyleElement = SelectRange;
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
                model.StartAngle = [NSNumber numberWithFloat: slider.value] ;
                [self upDateDashView];
            }
                break;
            case 1:
            {
              
                model.endAngle = [NSNumber numberWithFloat: slider.value];
              [self upDateDashView];
            }
                break;
                case 2:
            {
            
                model.titleFontScale =  [NSNumber numberWithFloat: slider.value];
              
                [self upDateDashView];
            }
                break;
            case 3:
            {
                model.titlePosition = [NSNumber numberWithFloat: slider.value];
               
                [self upDateDashView];
            }
                break;
            case 4:
            {
                if (model.ValueVisble == YES) {
                    model.ValueFontScale =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
                }
            }
                break;
            case 5:
            {
                  if (model.ValueVisble == YES) {
                      model.ValuePosition =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
                  }
            }
                break;
            case 6:
            {
                model.UnitFontScale =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
            }

                break;
            case 7:
            {
                model.UnitVerticalPosition =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
            }
                break;
            case 8:
            {
                model.UnitHorizontalPosition = [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
            }
                
                break;

            case 9:
            {
                model.maWidth =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
            }
                break;
            case 10:
            {
                model.maLength = [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
            }
                break;
            case 11:
            {
                model.miWidth =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
            }
                break;
            case 12:
            {
                model.miLength = [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
            }
                break;
            case 13:
            {
                if (model.LabelVisble == YES) {
                    model.LabelFontScale =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
                }
            }
                break;
            case 14:
            {
                 if (model.LabelVisble == YES) {
                     model.LabelOffest =  [NSNumber numberWithFloat: slider.value];
                [self upDateDashView];
                 }
            }
                break;
            case 15:
            {
                if (model.PointerVisble == YES) {
                    model.PointerWidth =  [NSNumber numberWithFloat: slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 16:
            {
                if (model.PointerVisble == YES) {
                    model.PointerLength = [NSNumber numberWithFloat: slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 17:
            {
                model.KNOBRadius =  [NSNumber numberWithFloat: slider.value];
                  [self upDateDashView];
            }
                break;
            case 18:
            {
                if (model.Fillenabled == YES) {
                    model.FillstartAngle =  [NSNumber numberWithFloat: slider.value];
                    [self upDateDashView];
                }
            }
                break;
            case 19:
            {
                if (model.Fillenabled == YES) {
                    model.FillEndAngle =  [NSNumber numberWithFloat: slider.value];
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
      CGFloat Space =   ([model.endAngle floatValue]- [model.StartAngle floatValue])/([model.maxNumber floatValue] - [model.minNumber floatValue]);
      [self.DashViewA rotationWithStartAngle:[model.StartAngle floatValue]  WithEndAngle:[model.StartAngle floatValue] + slideValue*Space];
   

}
#pragma mark 外径颜色的变化
- (void)selectColorBetouched:(NSInteger)indexTag{
    DLog(@"indexTag==%ld",(long)indexTag);
    
    switch (indexTag) {
        case 0:
        {

            model.innerColor = self.selectColor;
                       [self upDateDashView];

        }
            break;
        case 1:
        {
            model.outerColor = self.selectColor;
            [self upDateDashView];
            
        }
            break;
         case 2:
        {
            model.titleColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 3:
        {
              if (model.ValueVisble == YES) {
            model.ValueColor = self.selectColor;
                  [self upDateDashView];
              }
        }
            break;
        case 4:
        {
            model.UnitColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 5:
        {
            model.maColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 6:
        {
            model.miColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 7:
        {
            model.PointerColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 8:
        {
            model.KNOBColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 9:
        {
            if (model.Fillenabled == YES) {
                model.FillColor = self.selectColor;
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
     DLog(@"开关on%d",  switchBtn.on);
    switch (switchBtn.tag) {
        case 0:
        {
            model.ValueVisble = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 1:
        {
            model.LabelVisble = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 2:
        {
            model.LabelRotate = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 3:
        {
            model.PointerVisble = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 4:
        {
            model.Fillenabled = switchBtn.on;
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
    [self.DashViewA addGradientView:model.outerColor GradientViewWidth:150*KFontmultiple];
    [self.DashViewA initWithModel:model];
    self.DashViewA.infoLabel.text = model.infoLabeltext;
    self.DashView = self.DashViewA;
    [self.view addSubview:self.DashViewA];
    
//    NSArray *dashArray = [CustomDashboard findAll];
//    for (CustomDashboard *dash in dashArray) {
//        DLog(@" 测试测试%@ ",dash.dashboardA.StartAngle);
//    }

}
#pragma mark 返回仪表盘更新数据库
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    DLog(@"121");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSArray *all =@[@"BG_ID",@"=",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
            CustomDashModel.dashboardA.StartAngle = model.StartAngle;
             CustomDashModel.dashboardA.miLength = model.miLength;
             CustomDashModel.dashboardA.miWidth = model.miWidth;
             CustomDashModel.dashboardA.maWidth = model.maWidth;
             CustomDashModel.dashboardA.maLength = model.maLength;
             CustomDashModel.dashboardA.UnitHorizontalPosition = model.UnitHorizontalPosition;
            CustomDashModel.dashboardA.UnitVerticalPosition = model.UnitVerticalPosition;
            CustomDashModel.dashboardA.UnitFontScale = model.UnitFontScale;
            CustomDashModel.dashboardA.ValuePosition = model.ValuePosition;
            CustomDashModel.dashboardA.ValueFontScale = model.ValueFontScale;
            CustomDashModel.dashboardA.endAngle = model.endAngle;
            CustomDashModel.dashboardA.titleFontScale = model.titleFontScale;
            
            CustomDashModel.dashboardA.FillstartAngle = model.FillstartAngle;
            CustomDashModel.dashboardA.LabelFontScale = model.LabelFontScale;
            CustomDashModel.dashboardA.LabelOffest = model.LabelOffest;
            CustomDashModel.dashboardA.outerColor = model.outerColor;
            CustomDashModel.dashboardA.innerColor = model.innerColor;
            CustomDashModel.dashboardA.titleColor = model.titleColor;
            CustomDashModel.dashboardA.maColor = model.maColor;
            CustomDashModel.dashboardA.FillColor = model.FillColor;
            CustomDashModel.dashboardA.KNOBColor = model.KNOBColor;
            CustomDashModel.dashboardA.PointerVisble = model.PointerVisble;
            CustomDashModel.dashboardA.LabelRotate = model.LabelRotate;
            CustomDashModel.dashboardA.ValueVisble = model.ValueVisble;
            CustomDashModel.dashboardA.LabelVisble = model.LabelVisble;
            CustomDashModel.dashboardA.PointerWidth = model.PointerWidth;
            [CustomDashModel bg_updateWhere:all];
      
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
