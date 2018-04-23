
//
//  FeedbackViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/6.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIViewController+NavBar.h"

@interface FeedbackViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FeedbackViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self initNavBarTitle:@"Feedback" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initWithData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    self.tableView.backgroundColor = [ColorTools colorWithHexString:@"212329"];
    [self.view addSubview:self.tableView];
}

#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
  
        if (isLandscape) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
        }else{
            DLog(@"竖屏");
            [self setVerticalFrame];
        }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
    
}
-(void)initWithData{
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Feedback Switch",@"Feedback document",nil];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = self.dataSource[indexPath.row];
            UISwitch *selectSwitch = [[UISwitch alloc]init];
            selectSwitch.on = YES;
            cell.accessoryView = selectSwitch;
        }
            break;
        case 1:
        {
            cell.textLabel.text = self.dataSource[indexPath.row+1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            {
                
            }
            break;
        case 1:
        {
            FeedbackDocumentController *vc = [[FeedbackDocumentController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
