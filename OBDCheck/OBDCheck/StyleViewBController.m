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
    DashboardB * model;
    NSNumber *indexID;
 CGFloat slideValue;  //slide的前一个
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionSource;
@property (nonatomic,strong) NSMutableArray *rowTitleSource;

@end

@implementation StyleViewBController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Style" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    indexID =  [NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex] ;
    NSLog(@"33%ld",(long)[DashboardSetting sharedInstance].Dashboardindex);
    
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 186, MSWidth, MSHeight - 186 - 44 -64) style:UITableViewStyleGrouped];
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
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: [DashboardSetting sharedInstance].Dashboardindex]];
    NSArray* pAll = [CustomDashboard bg_findWhere:findsql];

    for(CustomDashboard * dashboard in pAll){
        NSLog(@"backColor %@",dashboard.dashboardB.backColor  );
        model = dashboard.dashboardB;
    dashViewB = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
    [dashViewB initWithModel:dashboard.dashboardB];
        dashViewB.PIDLabel.text = dashboard.dashboardB.infoLabeltext;

            [self.view addSubview:dashViewB];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    label.text = @"Value";
    label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    label.font = [UIFont ToAdapFont:14.f];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dashViewB.frame) + 10, CGRectGetMaxY(label.frame )+10, MSWidth - dashViewB.frame.size.width-50*KFontmultiple , 20)];
    self.slider.minimumValue = [model.minNumber floatValue];
    self.slider.maximumValue = [model.maxNumber floatValue];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    self.slider.tag = 9;
    slideValue = self.slider.value;
   
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
    }else if ((indexPath.section == 5  ) && indexPath.row == 1)
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
    }else if (indexPath.section == 5  && indexPath.row == 1)
    {
        resultCell = StyleTwoCell;
    }else {
        resultCell =StyleOneCell;
    }
    switch (indexPath.section) {
        case 0:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[0];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.backColor];
            StyleTwoCell.ColorLabel.text = model.backColor;
            StyleOneCell.titleName.text = _rowTitleSource[1];
            StyleTwoCell.ColorView.tag = 0;
            StyleOneCell.NumberSider.tag = 0;
            StyleOneCell.NumberSider.minimumValue = 0;
            StyleOneCell.NumberSider.maximumValue = 2;
            StyleOneCell.NumberSider.value  = [model.GradientRadius floatValue];

        }
            break;
        case 1:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[2];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.titleColor];
            StyleTwoCell.ColorLabel.text = model.titleColor;
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row +2];
            StyleTwoCell.ColorView.tag = 1;
            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 1;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = [model.titleFontScale floatValue];
                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 2;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = [model.titlePositon floatValue];
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
            StyleThreeCell.SwitchBtn.on = model.ValueVisible;
            StyleThreeCell.SwitchBtn.tag = 0;
            StyleTwoCell.titleName.text = _rowTitleSource[6];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.ValueColor];
            StyleTwoCell.ColorLabel.text = model.ValueColor;
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row +5];
            StyleTwoCell.ColorView.tag = 2;
            switch (indexPath.row) {
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 3;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = [model.ValueFontScale floatValue];

                }
                    break;
                case 3:
                {
                    StyleOneCell.NumberSider.tag = 4;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = [model.ValuePositon floatValue];

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
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.UnitColor ];
            StyleTwoCell.ColorLabel.text = model.UnitColor;

            switch (indexPath.row) {
                case 1:
                {
                    StyleOneCell.NumberSider.tag = 5;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = [model.UnitFontScale floatValue];
                }
                    break;
                case 2:
                {
                    StyleOneCell.NumberSider.tag = 6;
                    StyleOneCell.NumberSider.minimumValue = 0;
                    StyleOneCell.NumberSider.maximumValue = 2;
                    StyleOneCell.NumberSider.value  = [model.UnitPositon floatValue];
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
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.pointerColor ];
            StyleTwoCell.ColorLabel.text = model.pointerColor;
            StyleOneCell.NumberSider.minimumValue = 0;
            StyleOneCell.NumberSider.maximumValue = 2;
            StyleOneCell.NumberSider.value  = [model.Pointerwidth floatValue];
        }
            break;
        case 5:
        {
            StyleThreeCell.titleName.text = _rowTitleSource[14];
            StyleThreeCell.SwitchBtn.tag = 1;
            StyleThreeCell.SwitchBtn.on = model.FillEnable;
            StyleTwoCell.titleName.text = _rowTitleSource[15];
            StyleTwoCell.ColorView.tag = 5;
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.FillColor];
            StyleTwoCell.ColorLabel.text =model.FillColor;
          

        }
            break;
        default:
            break;
    }
    StyleOneCell.NumberLabel.text = [NSString stringWithFormat:@"%.2f",StyleOneCell.NumberSider.value ];
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
                model.GradientRadius =[NSNumber numberWithFloat: slider.value] ;
                [self upDateDashView];
            }
                break;
            case 1:
            {
                model.titleFontScale = [NSNumber numberWithFloat: slider.value] ;
                  [self upDateDashView];
            }
                break;
            case 2:
            {
               
                model.titlePositon = [NSNumber numberWithFloat: slider.value] ;
                [self upDateDashView];
            }
                break;
            case 3:
            {
                if (model.ValueVisible == YES) {
                    model.ValueFontScale = [NSNumber numberWithFloat: slider.value] ;                [self upDateDashView];
                }

            }
                break;
            case 4:
            {
                 if (model.ValueVisible == YES) {
                      model.ValuePositon = [NSNumber numberWithFloat: slider.value] ;
                     [self upDateDashView];
                 }

            }
                break;
            case 5:
            {
                model.UnitFontScale = [NSNumber numberWithFloat: slider.value] ;
                [self upDateDashView];
            }
                break;
            case 6:
            {
                model.UnitPositon = [NSNumber numberWithFloat: slider.value] ;
                [self upDateDashView];
            }
                break;
            case 7:
            {
                model.Pointerwidth = [NSNumber numberWithFloat: slider.value] ;
                [self upDateDashView];
            }
                break;
            case 8:
            {
                if (model.FillEnable == YES) {
                    model.Pointerwidth = [NSNumber numberWithFloat: slider.value] ;
                }
            }
                break;
            case 9:
            {
               dashViewB.NumberLabel.text = [NSString stringWithFormat:@"%.f",roundf(slider.value)];
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
    CGFloat Space =   (3*M_PI/2)/([model.maxNumber floatValue] - [model.minNumber floatValue]);
    [dashViewB rotateImageView:(-M_PI/2-M_PI/4)+Space*slideValue  Withend:(-M_PI/2-M_PI/4) ];
}
#pragma mark 外径颜色的变化
- (void)selectColorBetouched:(NSInteger)indexTag{
    NSLog(@"indexTag==%ld",(long)indexTag);
    switch (indexTag) {
        case 0:
        {
            model.backColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 1:
        {
            model.titleColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 2:
        {
             if (model.ValueVisible == YES) {
                 model.ValueColor = self.selectColor;
                 [self upDateDashView];
             }
        }
            break;
        case 3:
        {
            model.backColor = self.selectColor;
             [self upDateDashView];
            
        }
            break;
        case 4:
        {
            
            model.pointerColor = self.selectColor;
            [self upDateDashView];
        }
            break;
        case 5:
        {
            if (model.FillEnable == YES) {
                
                model.backColor = self.selectColor;
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
    NSLog(@"开关tag%ld",(long)switchBtn.tag);

    switch (switchBtn.tag) {
        case 0:
        {
           
            model.ValueVisible = switchBtn.on;
            [self upDateDashView];
        }
            break;
        case 1:
        {
            model.FillEnable = switchBtn.on;
            [self upDateDashView];
        }
            break;
        default:
            break;
    }
    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];

    bg_setDebug(YES);
    
    NSString *titleFontScalesql = [NSString stringWithFormat:@"SET dashboardB->titleFontScale = '%@' WHERE  ID = %@",model.titleFontScale ,indexID];
    
    NSString *ValueFontScalesql = [NSString stringWithFormat:@"SET dashboardB->ValueFontScale = '%@' WHERE  ID = %@",model.ValueFontScale ,indexID];
    
    NSString *ValuePositonsql = [NSString stringWithFormat:@"SET dashboardB->ValuePositon = '%@' WHERE  ID = %@",model.ValuePositon ,indexID];
    NSString *UnitFontScalesql = [NSString stringWithFormat:@"SET dashboardB->UnitFontScale = '%@' WHERE  ID = %@",model.UnitFontScale ,indexID];

    NSString *UnitPositonsql = [NSString stringWithFormat:@"SET dashboardB->UnitPositon = '%@' WHERE  ID = %@",model.UnitPositon ,indexID];
    NSString *Pointerwidthsql = [NSString stringWithFormat:@"SET dashboardB->Pointerwidth = '%@' WHERE  ID = %@",model.Pointerwidth ,indexID];
    
    NSString *titleColorsql = [NSString stringWithFormat:@"SET dashboardB->titleColor ='%@' WHERE  ID = %@",model.titleColor,indexID];
    NSString *ValueColorsql = [NSString stringWithFormat:@"SET dashboardB->ValueColor ='%@' WHERE  ID = %@",model.ValueColor,indexID];
    
    NSString *UnitColorsql = [NSString stringWithFormat:@"SET dashboardB->UnitColor ='%@' WHERE  ID = %@",model.UnitColor,indexID];
    NSString *pointerColorsql = [NSString stringWithFormat:@"SET dashboardB->pointerColor ='%@' WHERE  ID = %@",model.pointerColor,indexID];
    
    NSString *backColorsql = [NSString stringWithFormat:@"SET dashboardB->backColor ='%@' WHERE  ID = %@",model.backColor,indexID];
    NSString *ValueVisiblesql = [NSString stringWithFormat:@"SET dashboardB->ValueVisible ='%d' WHERE  ID = %@",model.ValueVisible,indexID];
    NSString *FillEnablesql = [NSString stringWithFormat:@"SET dashboardB->FillEnable ='%d' WHERE  ID = %@",model.FillEnable,indexID];
    [CustomDashboard bg_updateSet:titleFontScalesql];
    [CustomDashboard bg_updateSet:ValueColorsql];
    [CustomDashboard bg_updateSet:ValuePositonsql];
    [CustomDashboard bg_updateSet:ValueVisiblesql];
    [CustomDashboard bg_updateSet:ValueFontScalesql];
    [CustomDashboard bg_updateSet:UnitFontScalesql];
    [CustomDashboard bg_updateSet:UnitColorsql];
    [CustomDashboard bg_updateSet:Pointerwidthsql];
    [CustomDashboard bg_updateSet:UnitPositonsql];
    [CustomDashboard bg_updateSet:backColorsql];
    [CustomDashboard bg_updateSet:titleColorsql];
    [CustomDashboard bg_updateSet:pointerColorsql];
    [CustomDashboard bg_updateSet:FillEnablesql];

}
-(void)rightBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark 更新仪表盘
- (void)upDateDashView{
    [dashViewB removeFromSuperview];
    
    dashViewB = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
    [dashViewB initWithModel:model];
    dashViewB.PIDLabel.text = model.infoLabeltext;
    [self.view addSubview:dashViewB];
    
}

@end
