//
//  MultiplierViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/17.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "MultiplierViewController.h"
#import "UIViewController+NavBar.h"

@interface MultiplierViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *MultiplierDatasource;
@end

@implementation MultiplierViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Multiplier" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    _MultiplierDatasource = [[NSMutableArray alloc]initWithObjects:@"X1",@"X1000", nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _MultiplierDatasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.text = _MultiplierDatasource[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    cell.accessoryView = imageView;
    cell.accessoryView.hidden = YES;
    switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"multiplierType"]) {
        case MultiplierType1:{
            if (indexPath.row == 0) {
                cell.accessoryView.hidden = NO;
            }
        }
            break;
        case MultiplierType1000:{
            if (indexPath.row == 1) {
                cell.accessoryView.hidden = NO;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i<_MultiplierDatasource.count; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == indexPath.row) {
            cell.accessoryView.hidden = NO;
            switch (indexPath.row) {
                case 0:{  //0位小数点
                    [UserDefaultSet sharedInstance].multiplierType = MultiplierType1;
                    [[UserDefaultSet sharedInstance]SetIntegerAttribute:[UserDefaultSet sharedInstance].multiplierType Key:@"MultiplierType1"];
                }
                    break;
                case 1:{  //1位小数点
                    [UserDefaultSet sharedInstance].multiplierType = MultiplierType1000;
                    [[UserDefaultSet sharedInstance]SetIntegerAttribute:[UserDefaultSet sharedInstance].multiplierType Key:@"MultiplierType1"];
                }
                    break;
                default:
                    break;
            }
            DLog(@"122,%ld",(long)[UserDefaultSet sharedInstance].multiplierType);
            
        }else{
            cell.accessoryView.hidden = YES;
        }
    }
}


@end
