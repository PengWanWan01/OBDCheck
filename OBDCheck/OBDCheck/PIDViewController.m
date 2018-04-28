//
//  PIDViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/23.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "PIDViewController.h"

@interface PIDViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
}
@end

@implementation PIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
   [tableView registerNib:[UINib nibWithNibName:@"PIDViewCell" bundle:nil] forCellReuseIdentifier:@"PIDViewCell"];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PIDViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIDViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
