//
//  DisplaySetViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DisplaySetViewController.h"

@interface DisplaySetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *titleNameArray;
@property (nonatomic,strong) NSMutableArray *detailArray;

@end

@implementation DisplaySetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Display Configuration" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}

- (void)initWithUI{
    _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Instant fuel economy",@"Min",@"Max",@"PID",@"Number of Decimals",@"Multiplier", nil];
    _detailArray = [[NSMutableArray alloc]initWithObjects:@"Instant fuel economy",@"Zero",@"X1", nil];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, MSHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.scrollEnabled = NO;
    tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:tableView];
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }else{

    return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 34.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 34)];
    footView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section==1) {
        return 34;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 34)];
    HeadView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, MSWidth - 20, 34)];
    [label setTintColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
    label.textColor =[ColorTools colorWithHexString:@"#C8C6C6"];
    [HeadView addSubview:label];
    if (section == 0) {
        label.text = @"TITLE(CAN BE BLANK)";
        return HeadView;
    }else if (section == 1){
        label.text = @"RANGE";
        return HeadView;
    }else{
        return nil;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0)) {
        cell.textLabel.text =  _titleNameArray[indexPath.section];
    }else{
        cell.textLabel.text =  _titleNameArray[indexPath.section +1];
    }
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    if (indexPath.section ==1 ) {
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSWidth - 120, 0, 100, 44)];
        //        selectBtn.backgroundColor = [UIColor redColor];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
        [selectBtn setTitle:@"100" forState:UIControlStateNormal];
        [cell addSubview:selectBtn];
           }
    if (indexPath.section==2 || indexPath.section ==3 || indexPath.section==4) {
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSWidth - 240, 0, 200, 44)];
        //        selectBtn.backgroundColor = [UIColor redColor];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#FE9002"] forState:UIControlStateNormal];
        [selectBtn setTitle:_detailArray[indexPath.section - 2] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = indexPath.section;
        [cell addSubview:selectBtn];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
//            PIDSelectViewController *vc = [[PIDSelectViewController alloc ]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
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

- (void)selectBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 2:
        {
    PIDSelectViewController *vc = [[PIDSelectViewController alloc ]init];
    [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3:
        {
            DecimalViewController *vc = [[DecimalViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            MultiplierViewController *vc = [[MultiplierViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        default:
            break;
    }
}
@end
