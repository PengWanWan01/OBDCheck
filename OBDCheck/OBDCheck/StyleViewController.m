


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
    UIView *btnView;//放四个按钮的View
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
    NSLog(@"1231%@",self.indexID);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithHeadUI];
    
    [self initWithUI];

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
    NSLog(@"headU");
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: [DashboardSetting sharedInstance].Dashboardindex]];
    NSArray* pAll = [DashboardA bg_findWhere:findsql];
    for(DashboardA* dashboard in pAll){
        NSLog(@"dashboard.StartAngle %@",dashboard.StartAngle  );
            model = dashboard;
    self.DashViewA = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
      [self.DashViewA addGradientView:model.outerColor  GradientViewWidth:self.DashViewA.frame.size.width];
       [self.DashViewA drawCalibration:[model.StartAngle floatValue]  WithendAngle:[dashboard.endAngle floatValue] WithRingWidth:[dashboard.ringWidth floatValue] MAJORTICKSWidth:[dashboard.maWidth floatValue] MAJORTICKSLength:[dashboard.maLength floatValue] MAJORTICKSColor:dashboard.maColor MINORTICKSWidth:[dashboard.miWidth floatValue ] MINORTICKSLength:[dashboard.miLength floatValue] MINORTICKSColor:dashboard.miColor LABELSVisible:dashboard.LabelVisble Rotate:dashboard.LabelRotate   Font:[dashboard.LabelFontScale floatValue] OffestTickline:[dashboard.LabelOffest floatValue] InnerColor:dashboard.innerColor TitleColor:dashboard.titleColor TitleFontScale:[dashboard.titleFontScale floatValue] TitlePosition:[dashboard.titlePosition floatValue] ValueVisble:dashboard.ValueVisble ValueColor:dashboard.ValueColor ValueFontScale:[dashboard.ValueFontScale floatValue] ValuePosition:[dashboard.ValuePosition floatValue] UnitColor:dashboard.UnitColor UnitFontScale:[dashboard.UnitFontScale floatValue] UnitVerticalPosition:[dashboard.UnitVerticalPosition floatValue] UnitHorizontalPosition:[dashboard.UnitHorizontalPosition floatValue] PointerVisble:dashboard.PointerVisble PointerWidth:[dashboard.PointerWidth floatValue] PointerLength: [dashboard.PointerLength floatValue] PointerColor:dashboard.PointerColor KNOBRadius:[dashboard.KNOBRadius floatValue] KNOBColor:dashboard.KNOBColor Fillenabled:dashboard.Fillenabled FillstartAngle:[dashboard.FillstartAngle floatValue] FillEndAngle:[dashboard.FillEndAngle floatValue] FillColor:dashboard.FillColor];
            
            self.DashViewA.infoLabel.text =  self.infoLabeltext;
            
            self.DashView = self.DashViewA;
            [self.view addSubview:self.DashViewA];
    }
   UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    label.text = @"Value";
    label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    label.font = [UIFont ToAdapFont:14.f];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DashView.frame) + 10, CGRectGetMaxY(label.frame )+10, 150, 20)];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    self.selectStyleElement = SelectFrame;
    [scrollView addSubview:self.tableView];
    
    self.tableViewAxis = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStyleGrouped];
    self.tableViewAxis.dataSource = self;
    self.tableViewAxis.delegate = self;
    self.tableViewAxis.backgroundColor = [UIColor clearColor];
    self.tableViewAxis.separatorStyle = NO;
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewAxis];
 
    
    self.tableViewNeedle = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*2, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStyleGrouped];
    self.tableViewNeedle.dataSource = self;
    self.tableViewNeedle.delegate = self;
    self.tableViewNeedle.backgroundColor = [UIColor clearColor];
    self.tableViewNeedle.separatorStyle = NO;
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewNeedle];
    
    self.tableViewRange = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*3, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStyleGrouped];
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
     StyleTwoTableViewCell *StyleTwoCell = [tableView dequeueReusableCellWithIdentifier:@"StyleTwoTableViewCell"];
    StyleTwoCell.delegate = self;
    StyleTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    StyleTwoCell.colorClick = ^(NSString *color){
        NSLog(@"diandiandianji%@",color);
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
                     StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
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
                     StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
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
                }
                    break;
                case 4:
                {
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[11];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.UnitColor];
                    StyleTwoCell.ColorLabel.text = model.UnitColor;
                    StyleOneCell.titleName.text = _FrameRowTitleSource[indexPath.row +11];
                     StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
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
                            StyleOneCell.NumberSider.maximumValue = 1;
                            StyleOneCell.NumberSider.value = [model.ValuePosition floatValue];

                            StyleOneCell.NumberSider.tag = 7;
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 1;
                            StyleOneCell.NumberSider.value = [model.UnitHorizontalPosition floatValue];
                            StyleOneCell.NumberSider.tag = 8;
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
                     StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 5;
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
                }
                    break;
                case 1:
                {
                    StyleOneCell.titleName.text = _AxisRowTitleSource[indexPath.row];
                    StyleTwoCell.titleName.text = _AxisRowTitleSource[indexPath.row];
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.miColor];
                    StyleTwoCell.ColorLabel.text = model.miColor;
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 5;
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
                }
                    break;
                case 2:
                {
                    StyleThreeCell.titleName.text = _AxisRowTitleSource[indexPath.row +3];
                    StyleOneCell.titleName.text = _AxisRowTitleSource[indexPath.row+3];
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
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
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
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
                }
                    break;
                case 1:
                {
                    StyleOneCell.titleName.text = _NeedleRowTitleSource[4];
                    StyleTwoCell.titleName.text = _NeedleRowTitleSource[5];
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 20;
                    StyleOneCell.NumberSider.value  = [model.KNOBRadius floatValue];
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
            }
            break;
        default:
            break;
    }
    return resultCell;
    
}


- (void)btn:(UIButton *)btn{
    NSLog(@"111===%ld",(long)btn.tag);
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
        NSLog(@"yyyyy");
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
        NSLog(@"slide.tag%ld",(long)slider.tag);

        switch (slider.tag) {
            case 0:
            {
                NSLog(@"开始角度%f",slider.value);
                
                model.StartAngle = [NSNumber numberWithFloat: slider.value] ;
                 bg_setDebug(YES);
                NSLog(@"开始角qe度%@",model.StartAngle);

             NSString *sql = [NSString stringWithFormat:@"SET StartAngle = '%@' WHERE  ID = %@",model.StartAngle , self.indexID];
             [DashboardA bg_updateSet:sql];
                
                NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",  self.indexID];
                NSArray* pAll = [DashboardA bg_findWhere:findsql];
                for(DashboardA* dashboard in pAll){
                    NSLog(@"dashboard.StartAngle %@",dashboard.StartAngle  );
                }
                
                [self upDateDashView];
            }
                break;
            case 1:
            {
              
                model.endAngle = [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET endAngle ='%@' WHERE  ID = %@",model.endAngle, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
                case 2:
            {
            
                model.titleFontScale =  [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET titleFontScale ='%@' WHERE  ID = %@",model.titleFontScale, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 3:
            {
                model.titlePosition = [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET titlePosition ='%@' WHERE  ID = %@",model.titlePosition, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 4:
            {
                if (model.ValueVisble == YES) {
                    model.ValueFontScale =  [NSNumber numberWithFloat: slider.value];
                    NSString *sql = [NSString stringWithFormat:@"SET ValueFontScale ='%@' WHERE  ID = %@",model.ValueFontScale, self.indexID];
                    [DashboardA bg_updateSet:sql];
                [self upDateDashView];
                }
            }
                break;
            case 5:
            {
                  if (model.ValueVisble == YES) {
                      model.ValuePosition =  [NSNumber numberWithFloat: slider.value];
                      NSString *sql = [NSString stringWithFormat:@"SET ValuePosition ='%@' WHERE  ID = %@",model.ValuePosition, self.indexID];
                      [DashboardA bg_updateSet:sql];
                [self upDateDashView];
                  }
            }
                break;
            case 6:
            {
                model.UnitFontScale =  [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET UnitFontScale ='%@' WHERE  ID = %@",model.UnitFontScale, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }

                break;
            case 7:
            {
                model.UnitVerticalPosition =  [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET UnitVerticalPosition ='%@' WHERE  ID = %@",model.UnitVerticalPosition, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 8:
            {
                model.UnitHorizontalPosition = [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET UnitHorizontalPosition ='%@' WHERE  ID = %@",model.UnitHorizontalPosition, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                
                break;

            case 9:
            {
                model.maWidth =  [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET maWidth ='%@' WHERE  ID = %@",model.maWidth, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 10:
            {
                model.maLength = [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET maLength ='%@' WHERE  ID = %@",model.maLength, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 11:
            {
                model.miWidth =  [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET miWidth ='%@' WHERE  ID = %@",model.miWidth, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 12:
            {
                model.miLength = [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET miLength ='%@' WHERE  ID = %@",model.miLength, self.indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 13:
            {
                if (model.LabelVisble == YES) {
                    model.LabelFontScale =  [NSNumber numberWithFloat: slider.value];
                    NSString *sql = [NSString stringWithFormat:@"SET LabelFontScale ='%@' WHERE  ID = %@",model.LabelFontScale, self.indexID];
                    [DashboardA bg_updateSet:sql];
                [self upDateDashView];
                }
            }
                break;
            case 14:
            {
                 if (model.LabelVisble == YES) {
                     model.LabelOffest =  [NSNumber numberWithFloat: slider.value];
                     NSString *sql = [NSString stringWithFormat:@"SET LabelOffest ='%@' WHERE  ID = %@",model.LabelOffest, self.indexID];
                     [DashboardA bg_updateSet:sql];
                [self upDateDashView];
                 }
            }
                break;
            case 15:
            {
                if (model.PointerVisble == YES) {
                    model.PointerWidth =  [NSNumber numberWithFloat: slider.value];
                    NSString *sql = [NSString stringWithFormat:@"SET PointerWidth ='%@' WHERE  ID = %@",model.PointerWidth, self.indexID];
                    [DashboardA bg_updateSet:sql];
                    [self upDateDashView];
                }
            }
                break;
            case 16:
            {
                if (model.PointerVisble == YES) {
                    model.PointerLength = [NSNumber numberWithFloat: slider.value];
                    NSString *sql = [NSString stringWithFormat:@"SET PointerLength ='%@' WHERE  ID = %@",model.PointerLength, self.indexID];
                    [DashboardA bg_updateSet:sql];
                    [self upDateDashView];
                }
            }
                break;
            case 17:
            {
                model.KNOBRadius =  [NSNumber numberWithFloat: slider.value];
                NSString *sql = [NSString stringWithFormat:@"SET KNOBRadius ='%@' WHERE  ID = %@",model.KNOBRadius, self.indexID];
                [DashboardA bg_updateSet:sql];
                    [self upDateDashView];
            }
                break;
            case 18:
            {
                if (model.Fillenabled == YES) {
                    model.FillstartAngle =  [NSNumber numberWithFloat: slider.value];
                    NSString *sql = [NSString stringWithFormat:@"SET FillstartAngle ='%@' WHERE  ID = %@",model.FillstartAngle, self.indexID];
                    [DashboardA bg_updateSet:sql];
                    [self upDateDashView];
                }
            }
                break;
            case 19:
            {
                if (model.Fillenabled == YES) {
                    model.FillEndAngle =  [NSNumber numberWithFloat: slider.value];
                    NSString *sql = [NSString stringWithFormat:@"SET maLength ='%@' WHERE  ID = %@",model.maLength, self.indexID];
                    [DashboardA bg_updateSet:sql];
                    [self upDateDashView];
                }
            }
                break;
            default:
                break;
        }
    }

    
}
#pragma mark 外径颜色的变化
- (void)selectColorBetouched:(NSInteger)indexTag{
    NSLog(@"indexTag==%ld",(long)indexTag);
    
    switch (indexTag) {
        case 0:
        {
            bg_setDebug(YES);

            model.innerColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET innerColor ='%@' WHERE  ID = %@",model.innerColor, self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];

        }
            break;
        case 1:
        {
            model.outerColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET outerColor ='%@' WHERE  ID = %@",model.outerColor, self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
            
        }
            break;
         case 2:
        {
            model.titleColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET titleColor ='%@' WHERE  ID = %@",model.titleColor, self.self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 3:
        {
              if (model.ValueVisble == YES) {
            model.ValueColor = self.selectColor;
                  NSString *sql = [NSString stringWithFormat:@"SET ValueColor ='%@' WHERE  ID = %@",model.ValueColor, self.self.indexID];
                  [DashboardA bg_updateSet:sql];
            [self upDateDashView];
              }
        }
            break;
        case 4:
        {
            model.UnitColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET UnitColor ='%@' WHERE  ID = %@",model.UnitColor,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 5:
        {
            model.maColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET maColor ='%@' WHERE  ID = %@",model.maColor,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 6:
        {
            model.miColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET miColor ='%@' WHERE  ID = %@",model.miColor,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 7:
        {
            model.PointerColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET PointerColor ='%@' WHERE  ID = %@",model.PointerColor,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 8:
        {
            model.KNOBColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET KNOBColor ='%@' WHERE  ID = %@",model.KNOBColor,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 9:
        {
            if (model.Fillenabled == YES) {
                model.FillColor = self.selectColor;
                NSString *sql = [NSString stringWithFormat:@"SET FillColor ='%@' WHERE  ID = %@",model.FillColor,self.indexID];
                [DashboardA bg_updateSet:sql];
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
    NSLog(@"开关tag%ld",  (long)switchBtn.tag);
     NSLog(@"开关on%d",  switchBtn.on);
    switch (switchBtn.tag) {
        case 0:
        {
            model.ValueVisble = switchBtn.on;
            NSString *sql = [NSString stringWithFormat:@"SET ValueVisble ='%d' WHERE  ID = %@",model.ValueVisble,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 1:
        {
            model.LabelVisble = switchBtn.on;
            NSString *sql = [NSString stringWithFormat:@"SET LabelVisble ='%d' WHERE  ID = %@",model.LabelVisble,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 2:
        {
            model.LabelRotate = switchBtn.on;
            NSString *sql = [NSString stringWithFormat:@"SET LabelRotate ='%d' WHERE  ID = %@",model.LabelRotate,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 3:
        {
            model.PointerVisble = switchBtn.on;
            NSString *sql = [NSString stringWithFormat:@"SET PointerVisble ='%d' WHERE  ID = %@",model.PointerVisble,self.indexID];
            [DashboardA bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 4:
        {
            model.Fillenabled = switchBtn.on;
            NSString *sql = [NSString stringWithFormat:@"SET FillColor ='%d' WHERE  ID = %@",model.ValueVisble,self.indexID];
            [DashboardA bg_updateSet:sql];
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
    [self.DashViewA drawCalibration:[model.StartAngle floatValue] WithendAngle:[model.endAngle floatValue] WithRingWidth:[model.ringWidth floatValue] MAJORTICKSWidth:[model.maWidth floatValue] MAJORTICKSLength:[model.maLength floatValue] MAJORTICKSColor:model.maColor MINORTICKSWidth:[model.miWidth floatValue] MINORTICKSLength:[model.miLength floatValue] MINORTICKSColor:model.miColor LABELSVisible:model.LabelVisble Rotate:model.LabelRotate Font:[model.LabelFontScale floatValue] OffestTickline:[model.LabelOffest floatValue] InnerColor:model.innerColor TitleColor:model.titleColor TitleFontScale:[model.titleFontScale floatValue] TitlePosition:[model.titlePosition floatValue] ValueVisble:model.ValueVisble ValueColor:model.ValueColor ValueFontScale:[model.ValueFontScale floatValue ] ValuePosition:[model.ValuePosition floatValue] UnitColor:model.UnitColor UnitFontScale:[model.UnitFontScale floatValue] UnitVerticalPosition:[model.UnitVerticalPosition floatValue] UnitHorizontalPosition:[model.UnitHorizontalPosition floatValue] PointerVisble:model.PointerVisble PointerWidth:[model.PointerWidth floatValue] PointerLength:[model.PointerLength floatValue] PointerColor:model.PointerColor KNOBRadius:[model.KNOBRadius floatValue] KNOBColor:model.KNOBColor Fillenabled:model.Fillenabled FillstartAngle:[model.FillstartAngle floatValue] FillEndAngle:[model.FillEndAngle floatValue]FillColor:model.FillColor];
   
    self.DashView = self.DashViewA;
    [self.view addSubview:self.DashViewA];

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
