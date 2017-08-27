//
//  StyleCViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/26.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleCViewController.h"

@interface StyleCViewController ()<UITableViewDataSource,UITableViewDelegate,selectColorDelegete,selectSwtichDelegete>
{
    DashboardViewStyleC  *dashViewC;
    NSInteger selectTag;
    UIButton *Fristbtn;
    UIButton *selectBtn;
}
@property (nonatomic,strong) NSMutableArray *sectionSource;
@property (nonatomic,strong) NSMutableArray *rowTitleSource;

@end

@implementation StyleCViewController
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
    _sectionSource = [[NSMutableArray alloc]initWithObjects:@"BACKGROUND COLOR",@"TITLE LABEL",@"VALUE LABEL",@"UNITS LABEL",@"Frame",nil];
    _rowTitleSource = [[NSMutableArray alloc]initWithObjects:@"Inner Color", @"Outer Color",@"Gradient Radius",@"Title Color",@"Font Scale",@"Position",@"Value Visible",@"Value Color",@"Font Scale",@"Position",@"Units Color",@"Font Scale",@"Position",@"Frame Color",@"Frame Scale",nil];
    
}
- (void)initWithUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 186, MSWidth, MSHeight - 186-44-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [self.view addSubview:self.tableView];
    
}
- (void)initWithHeadUI{
 
    
    self.innerColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCinnerColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.outerColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCouterColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
     self.Gradientradius = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCGradientradius%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.titleColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCtitleColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.titleFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCtitleFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.titlePositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCtitlePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.ValueVisible = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleCValueVisible%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValueColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCValueColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.ValueFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValueFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValuePositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValuePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.UnitColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCUnitColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.UnitFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.UnitPositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitPositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.FrameColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.FrameScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCFrameScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    dashViewC = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            [self.view addSubview:dashViewC];
           UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    [dashViewC drawinnerColor:self.innerColor OuterColor:self.outerColor Gradientradius:self.Gradientradius TitleColor:self.titleColor TiltefontScale:self.titleFontScale TitlePosition:self.titlePositon ValueVisible:self.ValueVisible Valuecolor:self.ValueColor ValueFontScale:self.ValueFontScale ValuePositon:self.ValuePositon UnitColor:self.UnitColor UnitFontScale:self.UnitFontScale UnitPositon:self.UnitPositon FrameColor:self.FrameColor FrameScale:self.FrameScale];
    
    label.text = @"Value";
    label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    label.font = [UIFont ToAdapFont:14.f];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dashViewC.frame) + 10, CGRectGetMaxY(label.frame )+10, 150, 20)];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    
         [self.view addSubview:label];
    [self.view  addSubview:self.slider];
    [self.view  addSubview:self.NumberLabel];
    
    
}
#pragma mark tabble代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section ==3) {
        return 3;
    }else if (section == 2){
        return 4;
    }else{
        return 2;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (((indexPath.row == 0 || indexPath.row == 1)&&indexPath.section == 0)) {
        return 44.f;
    }else if ((indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4)&&  indexPath.row == 0 ){
        return 44.f;
    }else if ((indexPath.section == 2) && indexPath.row == 1)
    {
        return 44.f;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        return 44.f;

    }else{
        return 65.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 44)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, MSWidth-15, 30)];
    label.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    label.font = [UIFont ToAdapFont:14.f];
    label.text = _sectionSource[section];
    [headView addSubview:label];
    
    return headView;
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
    StyleThreeCell.delegate = self;
    if (((indexPath.row == 0 || indexPath.row == 1)&&indexPath.section == 0)) {
        resultCell = StyleTwoCell;
    }else if ((indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4)&&  indexPath.row == 0 ){
        resultCell = StyleTwoCell;
    }else if ((indexPath.section == 2) && indexPath.row == 1)
    {
        resultCell = StyleTwoCell;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        resultCell =StyleThreeCell;
    }else{
        resultCell = StyleOneCell;
    }
    switch (indexPath.section) {
        case 0:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[indexPath.row];
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row ];
            StyleOneCell.NumberSider.tag = 0;
            StyleOneCell.NumberSider.minimumValue = 0;
            StyleOneCell.NumberSider.maximumValue = 1;
            StyleOneCell.NumberSider.value  = self.Gradientradius;
            switch (indexPath.row) {
                case 0:
                {
                    StyleTwoCell.ColorView.tag = 0;
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:self.innerColor];
                    StyleTwoCell.ColorLabel.text = self.innerColor;
                }
                    break;
                case 1:
                {
                    StyleTwoCell.ColorView.tag = 1;
                    StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:self.outerColor];
                    StyleTwoCell.ColorLabel.text = self.outerColor;
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case 1:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[3];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:self.titleColor];
            StyleTwoCell.ColorLabel.text = self.titleColor;
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row + 3];
            StyleTwoCell.ColorView.tag = 2;
            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 1;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = self.titleFontScale;
                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 2;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = self.titlePositon;
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case 2:
        {
            StyleThreeCell.titleName.text = _rowTitleSource[6];
            StyleThreeCell.SwitchBtn.tag = 0;
            StyleThreeCell.SwitchBtn.on = self.ValueVisible;
            StyleTwoCell.titleName.text = _rowTitleSource[7];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:self.ValueColor];
            StyleTwoCell.ColorLabel.text = self.ValueColor;
            StyleOneCell.titleName.text = _rowTitleSource[6+indexPath.row];
            StyleTwoCell.ColorView.tag = 3;
            switch (indexPath.row) {
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 3;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = self.ValueFontScale;
                }
                    break;
                case 3:
                {
                    StyleOneCell.NumberSider.tag = 4;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = self.ValuePositon;
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case 3:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[10];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:self.UnitColor];
            StyleTwoCell.ColorLabel.text = self.UnitColor;
            StyleOneCell.titleName.text = _rowTitleSource[10+indexPath.row];
            StyleTwoCell.ColorView.tag = 4;
            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 5;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = self.UnitFontScale;
                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 6;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = self.UnitPositon;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[13];
            StyleOneCell.titleName.text = _rowTitleSource[14];
            StyleTwoCell.ColorView.tag = 5;
            StyleOneCell.NumberSider.tag = 7;
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:self.FrameColor];
            StyleTwoCell.ColorLabel.text = self.FrameColor;
            StyleOneCell.NumberSider.minimumValue = 0;
            StyleOneCell.NumberSider.maximumValue = 2;
            StyleOneCell.NumberSider.value  = self.FrameScale;

        }
            break;
       
        default:
            break;
    }
    return resultCell;
}

#pragma mark Slider的点击事件
- (void)sliderValueChanged:(id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider * slider = (UISlider *)sender;
        NSLog(@"slide.tag%ld",(long)slider.tag );
        
        switch (slider.tag) {
            case 0:
            {
            
            }
                break;
            case 1:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleCtitleFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.titleFontScale = slider.value;
                [self upDateDashView];
            }
                break;
            case 2:
            {
                 [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleCtitlePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.titlePositon = slider.value;
                [self upDateDashView];
            }
                break;
            case 3:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleCValueFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.ValueFontScale = slider.value;
                [self upDateDashView];
            }
                break;
            case 4:
            {
                 [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleCValuePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.ValuePositon   = slider.value;
                [self upDateDashView];
                
            }
                break;
            case 5:
            {
                 [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleCUnitFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.UnitFontScale = slider.value;
                [self upDateDashView];
              
            }
                break;
            case 6:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleCUnitPositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.UnitPositon = slider.value;
                [self upDateDashView];
            }
                break;
            case 7:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.FrameScale  = slider.value;
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
             [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleCinnerColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.innerColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 1:
        {
             [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleCouterColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
             self.outerColor = self.selectColor;
            [self upDateDashView];

        }
            break;
        case 2:
        {
            [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleCtitleColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.titleColor = self.selectColor;
            [self upDateDashView];
            
        }
            break;
        case 3:
        {
            [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleCValueColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.ValueColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 4:{
          [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleCUnitColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.UnitColor = self.selectColor;
            [self upDateDashView];
            
        }
            break;
        case 5:{
            [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.FrameColor   = self.selectColor;
            [self upDateDashView];
        }
        default:
            break;
    }
}
#pragma mark 开关按钮
- (void)selectSwtichBetouched:(UISwitch *)switchBtn{
    NSLog(@"开关tag%ld",(long)switchBtn.tag);

    switch (switchBtn.tag) {
        case 0:
        {
        
        
        }
            break;
            
        default:
            break;
    }
    
}
- (void)upDateDashView{
    [dashViewC removeFromSuperview];
    dashViewC = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];

    [dashViewC drawinnerColor:self.innerColor OuterColor:self.outerColor Gradientradius:self.Gradientradius TitleColor:self.titleColor TiltefontScale:self.titleFontScale TitlePosition:self.titlePositon ValueVisible:self.ValueVisible Valuecolor:self.ValueColor ValueFontScale:self.ValueFontScale ValuePositon:self.ValuePositon UnitColor:self.UnitColor UnitFontScale:self.UnitFontScale UnitPositon:self.UnitPositon FrameColor:self.FrameColor FrameScale:self.FrameScale];
    [self.view addSubview:dashViewC];
    
}
@end
