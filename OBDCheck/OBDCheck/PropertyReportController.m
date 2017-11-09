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
    self.showDataSource = [[NSMutableArray alloc]initWithObjects:@"0-100KM/H",@"00.0s",@"100km/h-0km/h",@"00.0s",@"0-100m",@"00.0s", nil];
}
- (void)initWithUI{
    for (int i = 0; i<self.showDataSource.count; i++) {
        NSLog(@"得到的数组%@",self.showDataSource);
        
        UIButton *btn =[[UIButton alloc]initWithFrame: CGRectMake([setDistanceUtil setX:i], [setDistanceUtil setY:i], 120*MSWidth/375, 30*MSWidth/375)];
        [btn setTitle:self.showDataSource[i] forState:UIControlStateNormal];
        [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
              [self.view addSubview:btn];
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
