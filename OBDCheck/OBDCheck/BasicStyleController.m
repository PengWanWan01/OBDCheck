//
//  BasicStyleController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/21.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "BasicStyleController.h"

@interface BasicStyleController ()

@end

@implementation BasicStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"One",@"Two",@"Three",nil];
}
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  self.dataSource[indexPath.row];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    cell.accessoryView = imageView;
    cell.accessoryView.hidden = YES;
//    if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardClassicMode) {
//        switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardStyle"]) {
//            case DashboardStyleOne:{
//                if (indexPath.row == 0) {
//                    cell.accessoryView.hidden = NO;
//                }
//            }
//                break;
//            case DashboardStyleTwo:{
//                if (indexPath.row == 1) {
//                    cell.accessoryView.hidden = NO;
//                }
//            }
//                break;
//            case DashboardStyleThree:{
//                if (indexPath.row == 2) {
//                    cell.accessoryView.hidden = NO;
//                }
//            }
//                break;
//            default:
//                break;
//        }
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i<self.dataSource.count; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == indexPath.row) {
            cell.accessoryView.hidden = NO;
        }else{
            cell.accessoryView.hidden = YES;
            
        }
    }
    if ([self.delegate respondsToSelector:@selector(chosseBoardStyleBetouched:)]) {
        [self.delegate chosseBoardStyleBetouched:indexPath.row];
    }
}

@end
