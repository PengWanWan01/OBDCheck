//
//  FilesViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/8.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FilesViewController.h"

@interface FilesViewController ()<TBarViewDelegate>

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
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"File one",@"File one",@"File one",@"File one",@"File one", nil];
    
}
- (void)initWithUI{
    TBarView *tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 45-64, MSWidth, 45)];
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
//   UITableViewCell *cell = (UITableViewCell *)
    NSArray *arr = [self.tableView indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in arr) {
        //根据索引，获取cell 然后就可以做你想做的事情啦
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //我这里要隐藏cell 的图片
        cell.imageView.hidden = NO;
    }
    

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
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    cell.detailTextLabel.text = self.dataSource[indexPath.row];
    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"delete"];
    cell.imageView.hidden = YES;
    return cell;
}

@end
