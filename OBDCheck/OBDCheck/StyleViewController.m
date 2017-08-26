


//
//  StyleViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleViewController.h"

@interface StyleViewController ()<switchCommonDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,selectColorDelegete>
{
    UIScrollView *scrollView;
    NSInteger selectTag;
    UIButton *Fristbtn;
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

@end

@implementation StyleViewController
- (void)viewWillAppear:(BOOL)animated{
    [self initNavBarTitle:@"Style" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
  
    
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
    _RangeRowTitleSource = [[NSMutableArray alloc]initWithObjects:@"Enabled",@"Inner Position",@"Outer Position",@"Color", nil];
    
    
    
}
- (void)initWithHeadUI{
    
    self.StartAngle = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StartAngle%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.endAngle= [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"endAngle%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ringWidth =     [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"ringWidth%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.maLength =    [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"maLength%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.maWidth =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"maWidth%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    self.miLength =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"miLength%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    self.miWidth =       [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"miWidth%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    self.maColor =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"maColor%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    self.miColor =   [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"miColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.outerColor =[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"outerColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
  

    self.innerColor =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"innerColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.titleColor =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"titleColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    NSLog(@"9999%@",self.titleColor );
   
    
    self.titleFontScale =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TitleFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]];
   self.titlePosition = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TitlePosition%ld",[DashboardSetting sharedInstance].Dashboardindex]];
   self.ValueVisble = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"ValueVisble%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    
     self.ValueColor =  [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"ValueColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
      self.ValueFontScale = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"ValueFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]];
   
     self.ValuePosition = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"ValuePosition%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    
  self.LabelVisble =   [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"LabelVisble%ld",[DashboardSetting sharedInstance].Dashboardindex]];
 self.LabelRotate =    [[DashboardSetting sharedInstance].defaults boolForKey: [NSString stringWithFormat:@"LabelRotate%ld",[DashboardSetting sharedInstance].Dashboardindex]];
  self.LabelFontScale =   [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LabelFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]];
   self.LabelOffest =  [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LabelOffest%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    
    
            self.DashViewA = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            //画底盘渐变色
            [self.DashViewA addGradientView:self.outerColor GradientViewWidth:150*KFontmultiple];

            [self.DashViewA drawCalibration:self.StartAngle WithendAngle:self.endAngle  WithRingWidth:self.ringWidth MAJORTICKSWidth:self.maWidth MAJORTICKSLength:self.maLength MAJORTICKSColor:self.maColor MINORTICKSWidth:self.miWidth MINORTICKSLength:self.miLength MINORTICKSColor:self.miColor LABELSVisible:YES Rotate:YES Font:self.LabelFontScale OffestTickline:self.LabelOffest InnerColor:self.innerColor TitleColor:self.titleColor TitleFontScale:self.titleFontScale TitlePosition:self.titlePosition ValueVisble:YES ValueColor:self.ValueColor ValueFontScale:self.ValueFontScale ValuePosition:self.ValuePosition];
            
            self.DashView = self.DashViewA;
            [self.view addSubview:self.DashViewA];
          UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    label.text = @"Value";
    label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    label.font = [UIFont ToAdapFont:14.f];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DashView.frame) + 10, CGRectGetMaxY(label.frame )+10, 150, 20)];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(29, CGRectGetMaxY(self.DashView.frame) + 40, MSWidth - 58, 24)];
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
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 237+44, MSWidth, MSHeight)];
    scrollView.contentSize = CGSizeMake(MSWidth*4,MSHeight - 237);
    scrollView.delegate = self;
    scrollView.pagingEnabled=YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    self.selectStyleElement = SelectFrame;
    [scrollView addSubview:self.tableView];
    
    self.tableViewAxis = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStylePlain];
    self.tableViewAxis.dataSource = self;
    self.tableViewAxis.delegate = self;
    self.tableViewAxis.backgroundColor = [UIColor clearColor];
    self.tableViewAxis.separatorStyle = NO;
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewAxis];
 
    
    self.tableViewNeedle = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*2, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStylePlain];
    self.tableViewNeedle.dataSource = self;
    self.tableViewNeedle.delegate = self;
    self.tableViewNeedle.backgroundColor = [UIColor clearColor];
    self.tableViewNeedle.separatorStyle = NO;
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewNeedle];
    
    self.tableViewRange = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*3, 0, MSWidth, MSHeight - 237-44-64) style:UITableViewStylePlain];
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
                            StyleOneCell.NumberSider.value = self.StartAngle;
                            StyleOneCell.NumberSider.tag = 0;
                        }
                            break;
                        case 1:{
                            StyleOneCell.NumberSider.value = self.endAngle;
                            StyleOneCell.NumberSider.tag = 1;
                        }
                            break;
                        default:
                            break;
                    }
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.f",(360/(2*M_PI))*StyleOneCell.NumberSider.value ];

                }
                    break;
                case 1:
                {
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[indexPath.row + 2];
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleTwoCell.ColorView.tag = 0;
                        }
                            break;
                        case 1:
                        {
                            StyleTwoCell.ColorView.tag = 1;

                            
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
                            StyleOneCell.NumberSider.minimumValue = 0.02;
                            StyleOneCell.NumberSider.maximumValue = 0.5;
                            StyleOneCell.NumberSider.tag = 2;

                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 1;
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
                    StyleTwoCell.titleName.text = _FrameRowTitleSource[8];
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
                            StyleOneCell.NumberSider.minimumValue = 0.02;
                            StyleOneCell.NumberSider.maximumValue = 0.5;
                            StyleOneCell.NumberSider.tag = 4;
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 1;
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
                    StyleOneCell.titleName.text = _FrameRowTitleSource[indexPath.row +11];
                     StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    switch (indexPath.row) {
                        case 0:{
                            StyleTwoCell.ColorView.tag = 4;
                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0.02;
                            StyleOneCell.NumberSider.maximumValue = 0.5;
                            StyleOneCell.NumberSider.tag = 6;
                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 1;
                            StyleOneCell.NumberSider.tag = 7;
                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 1;
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
                     StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 5;
                            StyleOneCell.NumberSider.value = self.maWidth;
                            StyleOneCell.NumberSider.tag = 9;
                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 30;
                            StyleOneCell.NumberSider.value = self.maLength;
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
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    switch (indexPath.row) {
                        case 0:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 5;
                            StyleOneCell.NumberSider.tag = 11;
                            StyleOneCell.NumberSider.value = self.miWidth;

                        }
                            break;
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 30;
                            StyleOneCell.NumberSider.tag = 12;
                            StyleOneCell.NumberSider.value = self.maLength;

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
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0.02;
                            StyleOneCell.NumberSider.maximumValue = 0.2;
                            StyleOneCell.NumberSider.tag = 13;

                        }
                            break;
                        case 3:
                        {
                            StyleOneCell.NumberSider.minimumValue = -0.2;
                            StyleOneCell.NumberSider.maximumValue = 0.2;
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
                    StyleOneCell.titleName.text = _NeedleRowTitleSource[indexPath.row];
                    StyleTwoCell.titleName.text = _NeedleRowTitleSource[indexPath.row];
                    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
                    switch (indexPath.row) {
                        case 1:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 0.23f;
                            StyleOneCell.NumberSider.tag = 15;


                        }
                            break;
                        case 2:
                        {
                            StyleOneCell.NumberSider.minimumValue = 0;
                            StyleOneCell.NumberSider.maximumValue = 1;
                            StyleOneCell.NumberSider.tag = 16;


                        }
                            break;
                        case 3:{
                            StyleTwoCell.ColorView.tag = 7;
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
                    StyleOneCell.NumberSider.maximumValue = 0.1;
                    StyleOneCell.NumberSider.tag = 17;
                    StyleTwoCell.ColorView.tag = 8;

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
            StyleOneCell.titleName.text = _RangeRowTitleSource[indexPath.row ];
            StyleTwoCell.titleName.text = _RangeRowTitleSource[indexPath.row];
            if ( indexPath.row==0 ){
                resultCell = StyleThreeCell;
            }else if(indexPath.row==3){
                resultCell = StyleTwoCell;
            }else{
                resultCell = StyleOneCell;
            }
           
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 1;
            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 18;

                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 19;

                }
                case 3:{
                    StyleTwoCell.ColorView.tag = 9;
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
                 [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StartAngle%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.StartAngle = slider.value;
                
                [self upDateDashView];
            }
                break;
            case 1:
            {
              
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"endAngle%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.endAngle = slider.value;
                [self upDateDashView];
            }
                break;
                case 2:
            {
            
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"TitleFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.titleFontScale = slider.value;
                [self upDateDashView];
            }
                break;
            case 3:
            {
                
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"TitlePosition%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.titlePosition = slider.value;
                [self upDateDashView];
            }
                break;
            case 4:
            {
                
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"ValueFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.ValueFontScale = slider.value;
                [self upDateDashView];
            }
                break;
            case 5:
            {
                
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"ValuePosition%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.ValuePosition = slider.value;
                [self upDateDashView];
            }
                break;
            case 9:
            {
                
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"maWidth%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.maWidth = slider.value;
                [self upDateDashView];
            }
                break;
            case 10:
            {
                
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"maLength%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.maLength = slider.value;
                [self upDateDashView];
            }
                break;
            case 11:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"miWidth%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.miWidth = slider.value;
                [self upDateDashView];
            }
                break;
            case 12:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"miLength%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.miLength = slider.value;
                [self upDateDashView];
            }
                break;
            case 13:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"LabelFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.LabelFontScale = slider.value;
                [self upDateDashView];
            }
                break;
            case 14:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"LabelOffest%ld",[DashboardSetting sharedInstance].Dashboardindex]];
                self.LabelOffest = slider.value;
                [self upDateDashView];
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
            self.innerColor = self.selectColor;
            [[DashboardSetting sharedInstance].defaults setObject:self.innerColor forKey:[NSString stringWithFormat:@"innerColor%ld",[DashboardSetting sharedInstance].Dashboardindex]];
            [self upDateDashView];

        }
            break;
        case 1:
        {
            self.outerColor = self.selectColor;
             [[DashboardSetting sharedInstance].defaults setObject:self.outerColor forKey:[NSString stringWithFormat:@"outerColor%ld",[DashboardSetting sharedInstance].Dashboardindex]];
            [self upDateDashView];
            
        }
            break;
         case 2:
        {
            self.titleColor = self.selectColor;
            [[DashboardSetting sharedInstance].defaults setObject:self.titleColor forKey:[NSString stringWithFormat:@"titleColor%ld",[DashboardSetting sharedInstance].Dashboardindex]];
            [self upDateDashView];
        }
            break;
        case 3:
        {
            self.ValueColor = self.selectColor;
            [[DashboardSetting sharedInstance].defaults setObject:self.ValueColor forKey:[NSString stringWithFormat:@"ValueColor%ld",[DashboardSetting sharedInstance].Dashboardindex]];
            [self upDateDashView];
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            self.maColor = self.selectColor;
            [[DashboardSetting sharedInstance].defaults setObject:self.maColor forKey:[NSString stringWithFormat:@"maColor%ld",[DashboardSetting sharedInstance].Dashboardindex]];
            [self upDateDashView];
        }
            break;
        case 6:
        {
            self.miColor = self.selectColor;
            [[DashboardSetting sharedInstance].defaults setObject:self.miColor forKey:[NSString stringWithFormat:@"miColor%ld",[DashboardSetting sharedInstance].Dashboardindex]];
            [self upDateDashView];
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            
        }
            break;
        case 9:
        {
            
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
    [self.DashViewA addGradientView:self.outerColor GradientViewWidth:150*KFontmultiple];
    [self.DashViewA drawCalibration:self.StartAngle WithendAngle:self.endAngle WithRingWidth:self.ringWidth MAJORTICKSWidth:self.maWidth MAJORTICKSLength:self.maLength MAJORTICKSColor:self.maColor MINORTICKSWidth:self.miWidth MINORTICKSLength:self.miLength MINORTICKSColor:self.miColor LABELSVisible:YES Rotate:YES Font:self.LabelFontScale OffestTickline:self.LabelOffest InnerColor:self.innerColor TitleColor:self.titleColor TitleFontScale:self.titleFontScale TitlePosition:self.titlePosition ValueVisble:self.ValueVisble ValueColor:self.ValueColor ValueFontScale:self.ValueFontScale ValuePosition:self.ValuePosition];
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
