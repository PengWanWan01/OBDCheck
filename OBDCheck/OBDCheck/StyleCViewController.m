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
    DashboardC * model;
    NSNumber *indexID;

}
@property (nonatomic,strong) NSMutableArray *sectionSource;
@property (nonatomic,strong) NSMutableArray *rowTitleSource;

@end

@implementation StyleCViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Style" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    indexID =  [NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex] ;

    
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 186, MSWidth, MSHeight - 186-44-64) style:UITableViewStyleGrouped];
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
    NSArray* pAll = [DashboardC bg_findWhere:findsql];
    for(DashboardC * dashboard in pAll){
        NSLog(@"FrameColor %@",dashboard.FrameColor  );
        model = dashboard;
    
    dashViewC = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            [self.view addSubview:dashViewC];
        [dashViewC initWithModel:dashboard];
    }
           UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
   
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
            StyleOneCell.NumberSider.maximumValue = 50;
            StyleOneCell.NumberSider.value  = [model.Gradientradius floatValue];
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
        case 1:
        {
            StyleTwoCell.titleName.text = _rowTitleSource[3];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.titleColor];
            StyleTwoCell.ColorLabel.text = model.titleColor;
            StyleOneCell.titleName.text = _rowTitleSource[indexPath.row + 3];
            StyleTwoCell.ColorView.tag = 2;
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
            StyleThreeCell.titleName.text = _rowTitleSource[6];
            StyleThreeCell.SwitchBtn.tag = 0;
            StyleThreeCell.SwitchBtn.on = model.ValueVisible;
            StyleTwoCell.titleName.text = _rowTitleSource[7];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.ValueColor];
            StyleTwoCell.ColorLabel.text = model.ValueColor;
            StyleOneCell.titleName.text = _rowTitleSource[6+indexPath.row];
            StyleTwoCell.ColorView.tag = 3;
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
            StyleTwoCell.titleName.text = _rowTitleSource[10];
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.UnitColor];
            StyleTwoCell.ColorLabel.text = model.UnitColor;
            StyleOneCell.titleName.text = _rowTitleSource[10+indexPath.row];
            StyleTwoCell.ColorView.tag = 4;
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
            StyleTwoCell.titleName.text = _rowTitleSource[13];
            StyleOneCell.titleName.text = _rowTitleSource[14];
            StyleTwoCell.ColorView.tag = 5;
            StyleOneCell.NumberSider.tag = 7;
            StyleTwoCell.ColorView.backgroundColor = [ColorTools colorWithHexString:model.FrameColor];
            StyleTwoCell.ColorLabel.text = model.FrameColor;
            StyleOneCell.NumberSider.minimumValue = 0;
            StyleOneCell.NumberSider.maximumValue = 2;
            StyleOneCell.NumberSider.value  = [model.FrameScale floatValue];

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
                model.Gradientradius = [NSNumber numberWithFloat: slider.value] ;
                NSString *sql = [NSString stringWithFormat:@"SET Gradientradius = '%@' WHERE  ID = %@",model.Gradientradius ,indexID];
                [DashboardC bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 1:
            {
                model.titleFontScale = [NSNumber numberWithFloat: slider.value] ;
                NSString *sql = [NSString stringWithFormat:@"SET titleFontScale = '%@' WHERE  ID = %@",model.titleFontScale ,indexID];
                [DashboardC bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 2:
            {
                model.Gradientradius = [NSNumber numberWithFloat: slider.value] ;
                NSString *sql = [NSString stringWithFormat:@"SET titlePositon = '%@' WHERE  ID = %@",model.titlePositon ,indexID];
                [DashboardC bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 3:
            {
                if (model.ValueVisible == YES) {
                    model.Gradientradius = [NSNumber numberWithFloat: slider.value] ;
                    NSString *sql = [NSString stringWithFormat:@"SET ValueFontScale = '%@' WHERE  ID = %@",model.ValueFontScale ,indexID];
                    [DashboardC bg_updateSet:sql];
                [self upDateDashView];
                }
            }
                break;
            case 4:
            {
                 if (model.ValueVisible == YES) {
                     model.ValuePositon = [NSNumber numberWithFloat: slider.value] ;
                     NSString *sql = [NSString stringWithFormat:@"SET ValuePositon = '%@' WHERE  ID = %@",model.ValuePositon ,indexID];
                     [DashboardC bg_updateSet:sql];
                [self upDateDashView];
                 }
                
            }
                break;
            case 5:
            {
                model.UnitFontScale = [NSNumber numberWithFloat: slider.value] ;
                NSString *sql = [NSString stringWithFormat:@"SET UnitFontScale = '%@' WHERE  ID = %@",model.UnitFontScale ,indexID];
                [DashboardA bg_updateSet:sql];
                [self upDateDashView];
            }
  
                break;
            case 6:
            {
                model.Gradientradius = [NSNumber numberWithFloat: slider.value] ;
                NSString *sql = [NSString stringWithFormat:@"SET UnitPositon = '%@' WHERE  ID = %@",model.UnitPositon ,indexID];
                [DashboardC bg_updateSet:sql];
                [self upDateDashView];
            }
                break;
            case 7:
            {
                model.Gradientradius = [NSNumber numberWithFloat: slider.value] ;
                NSString *sql = [NSString stringWithFormat:@"SET FrameScale = '%@' WHERE  ID = %@",model.FrameScale ,indexID];
                [DashboardC bg_updateSet:sql];
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
            model.innerColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET innerColor ='%@' WHERE  ID = %@",model.innerColor,indexID];
            [DashboardC bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
        case 1:
        {
            model.outerColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET outerColor ='%@' WHERE  ID = %@",model.outerColor,indexID];
            [DashboardC bg_updateSet:sql];
            [self upDateDashView];

        }
            break;
        case 2:
        {
            model.titleColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET titleColor ='%@' WHERE  ID = %@",model.titleColor,indexID];
            [DashboardC bg_updateSet:sql];
            [self upDateDashView];
            
        }
            break;
        case 3:
        {
             if (model.ValueVisible == YES) {
                 model.ValueColor = self.selectColor;
                 NSString *sql = [NSString stringWithFormat:@"SET ValueColor ='%@' WHERE  ID = %@",model.ValueColor,indexID];
                 [DashboardC bg_updateSet:sql];
            [self upDateDashView];
             }
        }
            break;
        case 4:{
            model.UnitColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET UnitColor ='%@' WHERE  ID = %@",model.UnitColor,indexID];
            [DashboardC bg_updateSet:sql];
            [self upDateDashView];
            
        }
            break;
        case 5:{
            model.FrameColor = self.selectColor;
            NSString *sql = [NSString stringWithFormat:@"SET FrameColor ='%@' WHERE  ID = %@",model.FrameColor,indexID];
            [DashboardC bg_updateSet:sql];
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
            model.ValueVisible = switchBtn.on;
            NSString *sql = [NSString stringWithFormat:@"SET ValueVisible ='%d' WHERE  ID = %@",model.ValueVisible,indexID];
            [DashboardC bg_updateSet:sql];
            [self upDateDashView];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)upDateDashView{
    [dashViewC removeFromSuperview];
    dashViewC = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
    [dashViewC initWithModel:model];
    [self.view addSubview:dashViewC];
    
}
@end
