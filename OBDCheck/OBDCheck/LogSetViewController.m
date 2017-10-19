//
//  LogSetViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/11.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "LogSetViewController.h"

@interface LogSetViewController ()<UITableViewDelegate,UITableViewDataSource,selectSwtichDelegete>
{
    UITableView *MYtableView;
    LogsModel *model;
}
@property(nonatomic,strong)NSMutableArray *titleLabel;
@property(nonatomic,strong)NSMutableArray *selectLabel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation LogSetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Logs" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *SQL  = [NSString stringWithFormat:@"LIMIT 0, 1"];
    NSArray *pAll = [LogsModel findByCriteria:SQL];
    for(LogsModel* logsmodel in pAll){
        NSLog(@"logsmodel.item1PID %@",logsmodel.item1PID  );
        model = logsmodel;
    }
    [self initWithUI];
}
- (void)initWithUI{
    MYtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-74) style:UITableViewStyleGrouped];
    MYtableView.backgroundColor = [UIColor clearColor];
    MYtableView.dataSource = self;
    MYtableView.delegate = self;
    MYtableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    [self.view addSubview:MYtableView];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Select",@"Enabled",@"Smoothing", nil];
    self.titleLabel = [[NSMutableArray alloc]initWithObjects:@"Graph Item 1",@"Graph Item 2",@"Graph Item 3",@"Graph Item 4", nil];
    self.selectLabel = [[NSMutableArray alloc]initWithObjects:@"Accel X",@"Mass air flow rate",@"Accel X",@"Accel Z",nil];
    
    [MYtableView registerNib:[UINib nibWithNibName:@"selectTableViewCell" bundle:nil] forCellReuseIdentifier:@"selectTableViewCell"];
    [MYtableView registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ||section == 1 ) {
        return 2;
    }else{
    return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 44.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];//    [ColorTools colorWithHexString:@"#212329"];
    UIView *colourView = [[UIView alloc]initWithFrame:CGRectMake(15, 14, 20, 20)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(colourView.frame)+10, 14, 100, 20)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    label.text = self.titleLabel[section];
    [headView addSubview:colourView];
    [headView addSubview:label];
    switch (section) {
        case 0:
        {
            colourView.backgroundColor = [ColorTools colorWithHexString:@"#E51C23"];
        }
            break;
        case 1:
        {
            colourView.backgroundColor = [ColorTools colorWithHexString:@"#54C44B"];

        }
            break;
        case 2:
        {
            colourView.backgroundColor = [ColorTools colorWithHexString:@"#3F51B5"];

        }
            break;
        case 3:
        {
            colourView.backgroundColor = [ColorTools colorWithHexString:@"#FF9800"];
            
        }
            break;
        default:
            break;
    }
    return headView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *resultCell;
    selectTableViewCell *selectCell = [tableView dequeueReusableCellWithIdentifier:@"selectTableViewCell"];
    StyleThreeTableViewCell *StylethreeCell = [tableView dequeueReusableCellWithIdentifier:@"StyleThreeTableViewCell"];
    if ( indexPath.row == 0) {
        selectCell.backgroundColor  = [ColorTools colorWithHexString:@"3B3F49"];
        selectCell.titlename.text = self.dataSource[indexPath.row];
        selectCell.PIDLabel.text = self.selectLabel[indexPath.section];
        selectCell.selectionStyle = UITableViewCellSelectionStyleNone;
        resultCell= selectCell;
    }else{
        if (indexPath.section == 0 ||indexPath.section == 1 ) {
            StylethreeCell.titleName.text = self.dataSource[indexPath.row +1];
            switch (indexPath.section) {
                case 0:
                {
                    StylethreeCell.SwitchBtn.on = model.item1Smoothing;
                }
                    break;
                case 1:
                {
                    StylethreeCell.SwitchBtn.on = model.item2Smoothing;
                }
                    break;
                default:
                    break;
            }
        }
        else{
            
            StylethreeCell.titleName.text = self.dataSource[indexPath.row];
            switch (indexPath.section) {
                case 2:
                {
                    switch (indexPath.row) {
                        case 1:
                        {
                            StylethreeCell.SwitchBtn.on = model.item3Enabled;
                        }
                            break;
                        case 2:
                        {
                            StylethreeCell.SwitchBtn.on = model.item3Smoothing;
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 3:
                {
                    switch (indexPath.row) {
                        case 1:
                        {
                            StylethreeCell.SwitchBtn.on = model.item4Enabled;
                        }
                            break;
                        case 2:
                        {
                            StylethreeCell.SwitchBtn.on = model.item4Smoothing;
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
        }
         StylethreeCell.backgroundColor  = [ColorTools colorWithHexString:@"3B3F49"];
         StylethreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        StylethreeCell.delegate = self;
        StylethreeCell.SwitchBtn.tag = [[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
        resultCell = StylethreeCell;
    }
    return resultCell;
}
- (void)selectSwtichBetouched:(UISwitch  *)switchBtn{
  LogsModel *model = [LogsModel new];
    switch (switchBtn.tag) {
        case 1:
        {
          
            model.item1Smoothing = switchBtn.on;
        }
            break;
        case 11:{
            model.item2Smoothing = switchBtn.on;
        }
            break;
        case 21:{
               model.item3Enabled = switchBtn.on;
        }
            break;

        case 22:{
            model.item3Smoothing = switchBtn.on;

        }
            break;

        case 31:{
            NSString *sql = [NSString stringWithFormat:@"SET item4Enabled ='%d'",switchBtn.on];
        }
            break;
        case 32:{
            NSString *sql = [NSString stringWithFormat:@"SET item4Smoothing ='%d'",switchBtn.on];
        }
            break;
        default:
            break;
    }
    [model update];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PIDSelectViewController *VC = [[PIDSelectViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
@end
