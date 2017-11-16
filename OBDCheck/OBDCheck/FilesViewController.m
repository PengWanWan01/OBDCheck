//
//  FilesViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/8.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FilesViewController.h"

@interface FilesViewController ()<TBarViewDelegate,UITableViewDelegate,UITableViewDataSource,deleteFileDelegate>
{
    LogsModel *model;
}
@property (nonatomic,strong) UITableView *tableView ;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation FilesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self initNavBarTitle:@"Files" andLeftItemImageName:@"back" andRightItemName:@"Edit"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithUI];
}
- (void)initWithData{
    NSArray *array = [LogsModel bg_findAll];
    NSLog(@"%@",array);
    self.dataSource = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i<=array.count; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"File%ld",(long)i]];
    }
    
    
}
- (void)initWithUI{
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-TopHigh-49) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [ColorTools colorWithHexString:@"212329"];
    self.tableView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    //FilesTableViewCell
    [self.tableView registerClass:[FilesTableViewCell class] forCellReuseIdentifier:@"FilesTableViewCell"];
    
    TBarView *tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 3;
    tbarView.isSelectNumber = 2;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_normal",@"trips_normal",@"file_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_highlight",@"trips_highlight",@"file_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Graphs",@"Trips",@"Files", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];

}
- (void)back{
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)rightBarButtonClick{
   
    
    NSArray *arr = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in arr) {
        FilesTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.editstatus = EditstatusType2;
        [cell setNeedsDisplay];
        [cell setNeedsLayout];
    }
 
}



- (void)deleteData:(NSInteger)tag{
    NSLog(@"%@",[NSNumber numberWithInteger:tag+1]);
    NSArray *arr = [LogsModel bg_findAll];
    model = arr[tag];
     [LogsModel bg_deleteWhere:@[@"BG_ID",@"=",model.bg_id]];
      NSLog(@"剩余%@",[LogsModel bg_findAll]);
    [self.dataSource removeObjectAtIndex:tag]; //从模型中删除
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tag inSection:0]]  withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView reloadData];

}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    switch (touchSelectNumber) {
        case 0:
        {
            LogsController *vc = [[LogsController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            TripsViewController *vc = [[TripsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            FilesViewController *vc = [[FilesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     FilesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilesTableViewCell"];
    cell.editstatus = EditstatusType1;
    cell.delegate = self;
    cell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.nameLabel.text = self.dataSource[indexPath.row];    
    cell.detailLabel.text =self.dataSource[indexPath.row];
    cell.editstatus = EditstatusType1;
    cell.deleteBtn.tag = indexPath.row;
    
      return cell;
}
- (void)deletewithRow:(NSInteger)index{
    NSLog(@"121%ld",(long)index);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete all log files?" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *arr = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in arr) {
            FilesTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.editstatus = EditstatusType1;
            [cell setNeedsDisplay];
            [cell setNeedsLayout];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *arr = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in arr) {
            FilesTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.editstatus = EditstatusType1;
            [cell setNeedsDisplay];
            [cell setNeedsLayout];
        }
        [self deleteData:index];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    FileBackViewController *vc = [[FileBackViewController alloc]init];
    NSArray *array = [LogsModel bg_findAll];
    vc.model = array[indexPath.row];
    NSLog(@"%@%@%@%@%d%d",vc.model,vc.model.PID1dataSource,vc.model.PID2dataSource,vc.model.PID3dataSource,vc.model.item3Enabled,vc.model.item3Enabled);
    NSLog(@"%@%@%@%@",vc.model.item1PID,vc.model.item2PID,vc.model.item3PID,vc.model.item4PID);
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
