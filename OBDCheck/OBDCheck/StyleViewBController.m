//
//  StyleViewBController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/26.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleViewBController.h"

@interface StyleViewBController ()<UITableViewDelegate,UITableViewDataSource,selectColorDelegete,selectSwtichDelegete>
{
    DashboardViewStyleB  *dashViewB;
    NSInteger selectTag;
    UIButton *Fristbtn;
    UIButton *selectBtn;

}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionSource;
@property (nonatomic,strong) NSMutableArray *rowTitleSource;

@end

@implementation StyleViewBController
- (void)viewWillAppear:(BOOL)animated{
    [self initNavBarTitle:@"Style" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self  initWithHeadUI];
    [self initWithUI];
    
}
- (void)initWithData{
_sectionSource = [[NSMutableArray alloc]initWithObjects:@"BACKGROUND COLOR",@"TITLE LABEL",@"VALUE LABEL",@"UNITS LABEL",@"PONITER",@"RANGE", nil];
    _rowTitleSource = [[NSMutableArray alloc]initWithObjects:@"Color",@"Gradient Radius",@"Title Color",@"Font Scale",@"Position",@"Value Visible",@"Value Color",@"Font Scale",@"Position",@"Units Color",@"Font Scale",@"Position",@"Color",@"Width",@"Fill Enabled",@"Color",nil];
    
}
- (void)initWithUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 186, MSWidth, MSHeight - 186 - 44 -64) style:UITableViewStylePlain];
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
       self.backColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBbackColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.GradientColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBGradientColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.titleColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBtitleColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.titleFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBtitleFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.titlePositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValueVisible = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleBValueVisible%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValueColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBValueColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValueFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBValueFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValuePositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBValuePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;

    
    self.UnitColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBUnitColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.UnitFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBUnitFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.UnitPositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBUnitPositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;

    
    self.pointerColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleBpointerColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.Pointerwidth = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBPointerwidth%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.FillEnable = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleBFillEnable%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.FillPosition = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBFillPosition%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
            dashViewB = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
    [dashViewB drawgradient:self.backColor TitlteColor:self.titleColor TitlteFontScale:self.titleFontScale TitlePositon:self.titlePositon ValueVisible:self.ValueVisible Valuecolor:self.ValueColor ValueFontScale:self.ValueFontScale ValuePositon:self.ValuePositon UnitColor:self.UnitColor UnitFontScale:self.UnitFontScale UnitPositon:self.UnitPositon PointColor:self.pointerColor PointWidth:self.Pointerwidth Fillenable:self.FillEnable FillPosition:self.FillPosition];
    
            [self.view addSubview:dashViewB];
          
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    label.text = @"Value";
    label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    label.font = [UIFont ToAdapFont:14.f];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dashViewB.frame) + 10, CGRectGetMaxY(label.frame )+10, 150, 20)];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    
   
    _datasource = [[NSMutableArray alloc]initWithObjects:@"Frame",@"Axis",@"Needle",@"Range", nil];
    
   
    [self.view addSubview:label];
    [self.view  addSubview:self.slider];
    [self.view  addSubview:self.NumberLabel];
    
    
}
#pragma mark tabble代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 || section ==3) {
        return 3;
    }else if (section == 2){
        return 4;
    }else{
        return 2;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (((indexPath.section == 0 || indexPath.section == 1|| indexPath.section == 3 ||indexPath.section == 4 )&&indexPath.row == 0)) {
       return 44.f;
    }else if (indexPath.section == 2 &&  indexPath.row == 1 ){
        return 44.f;
    }else if ((indexPath.section == 2 ||indexPath.section == 5 ) && indexPath.row == 0)
    {
        return 44.f;
    }else{
        return 65.f;;
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
    if (((indexPath.section == 0 || indexPath.section == 1|| indexPath.section == 3 ||indexPath.section == 4 )&&indexPath.row == 0)) {
        resultCell = StyleTwoCell;
    }else if (indexPath.section == 2 &&  indexPath.row == 1 ){
      resultCell = StyleTwoCell;
    }else if ((indexPath.section == 2 ||indexPath.section == 5 ) && indexPath.row == 0)
    {
        resultCell = StyleThreeCell;
    }else{
        resultCell =StyleOneCell;
    }
    switch (indexPath.section) {
        case 0:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[0];
            StyleOneCell.titleName.text = _rowTitleSource[1];
            StyleTwoCell.ColorView.tag = 0;
            StyleOneCell.NumberSider.tag = 0;
        }
            break;
        case 1:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[2];
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row +2];
            StyleTwoCell.ColorView.tag = 1;
            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 1;
                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 2;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            StyleThreeCell.titleName.text = _rowTitleSource[5];
            StyleThreeCell.SwitchBtn.tag = 0;
            StyleTwoCell.titleName.text = _rowTitleSource[6];
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row +5];
            StyleTwoCell.ColorView.tag = 2;
            switch (indexPath.row) {
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 3;
                }
                    break;
                case 3:
                {
                    StyleOneCell.NumberSider.tag = 4;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[9];
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row +9];
            StyleTwoCell.ColorView.tag = 3;
            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 5;
                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 6;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
             StyleTwoCell.titleName.text = _rowTitleSource[12];
            StyleOneCell.titleName.text = _rowTitleSource[13];
            StyleTwoCell.ColorView.tag = 4;
            StyleOneCell.NumberSider.tag = 7;
        }
            break;
        case 5:
        {
            StyleThreeCell.titleName.text = _rowTitleSource[14];
            StyleThreeCell.SwitchBtn.tag = 1;
            StyleTwoCell.titleName.text = _rowTitleSource[15];
            StyleOneCell.NumberSider.tag = 8;

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
                  [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleBtitleFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.titleFontScale = slider.value;
                [self upDateDashView];
            }
                break;
            case 2:
            {
                 [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleBtitlePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.titlePositon = slider.value;
                [self upDateDashView];
            }
                break;
            case 3:
            {
               [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleBValueFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.ValueFontScale =  slider.value;
                [self upDateDashView];

            }
                break;
            case 4:
            {
                  [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleBValuePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.ValuePositon = slider.value;
                [self upDateDashView];

            }
                break;
            case 5:
            {
                [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleBUnitFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.UnitFontScale = slider.value;
                [self upDateDashView];
            }
                break;
            case 6:
            {
               [[DashboardSetting sharedInstance].defaults setFloat:slider.value forKey:[NSString stringWithFormat:@"StyleBUnitPositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
                self.UnitPositon =  slider.value;
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
             [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleBbackColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.backColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 1:
        {
                [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleBtitleColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.titleColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 2:
        {
              [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleBValueColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.ValueColor  = self.selectColor;
             [self upDateDashView];
        }
            break;
        case 3:
        {
               [[DashboardSetting sharedInstance].defaults setObject:self.selectColor forKey:[NSString stringWithFormat:@"StyleBUnitColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
            self.UnitColor = self.selectColor;
             [self upDateDashView];
            
        }
            break;
        case 4:
        {
            
        }
            break;
               default:
            break;
    }
}
#pragma mark 开关按钮
- (void)selectSwtichBetouched:(UISwitch *)switchBtn{
    switch (switchBtn.tag) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
    
}
#pragma mark 更新仪表盘
- (void)upDateDashView{
    [dashViewB removeFromSuperview];
    
    dashViewB = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
    [dashViewB drawgradient:self.backColor TitlteColor:self.titleColor TitlteFontScale:self.titleFontScale TitlePositon:self.titlePositon ValueVisible:self.ValueVisible Valuecolor:self.ValueColor ValueFontScale:self.ValueFontScale ValuePositon:self.ValuePositon UnitColor:self.UnitColor UnitFontScale:self.UnitFontScale UnitPositon:self.UnitPositon PointColor:self.pointerColor PointWidth:self.Pointerwidth Fillenable:self.FillEnable FillPosition:self.FillPosition];
    [self.view addSubview:dashViewB];
    
}

@end
