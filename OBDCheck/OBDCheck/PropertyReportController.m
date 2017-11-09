//
//  PropertyReportController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PropertyReportController.h"

@interface PropertyReportController ()

@end

@implementation PropertyReportController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Report" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initWithData];
    [self initWithUI];
}
- (void)initWithData{
    
}
- (void)initWithUI{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
