//
//  PropertyReportController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PropertyReportController.h"

@interface PropertyReportController ()
@property (nonatomic,strong) NSMutableArray *showDataSource;

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
    self.showDataSource = [[NSMutableArray alloc]initWithObjects:@"0-100KM/H:",@"100km/h-0km/h:",@"0-100m:", nil];
}
- (void)initWithUI{
    for (int i = 0; i<3; i++) {
        NSLog(@"得到的数组%@",self.showDataSource);
        UILabel *showLabel =[[UILabel alloc]initWithFrame: CGRectMake(0, i*40,MSWidth/2, 25)];
        showLabel.text = self.showDataSource[i];
        showLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        showLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:showLabel];
    }
    for (int i = 0; i<3; i++) {
        NSLog(@"得到的数组%@",self.reportData);
        UILabel *showLabel =[[UILabel alloc]initWithFrame: CGRectMake(MSWidth/2, i*40,MSWidth/2, 25)];
        showLabel.text = self.reportData[i];
        showLabel.textAlignment = NSTextAlignmentCenter;
        showLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        [self.view addSubview:showLabel];
    }
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
