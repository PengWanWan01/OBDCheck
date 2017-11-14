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

    UILabel *firstTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, MSWidth-20, 20)];
    firstTitle.textColor = [ColorTools colorWithHexString:@"918E8E"];
    firstTitle.text = @"Time/Max Speed";
    firstTitle.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:firstTitle];
    for (NSInteger i = 0; i<2; i++) {
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(MSWidth/2), CGRectGetMaxY(firstTitle.frame)+10, MSWidth/2, 30)];
        numberLabel.font = [UIFont systemFontOfSize:24.f];
        numberLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
        numberLabel.textAlignment = NSTextAlignmentCenter;
      
       
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(MSWidth/2), CGRectGetMaxY(numberLabel.frame), MSWidth/2, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        if (i==0) {
            numberLabel.text = self.model.reportRunTime;
            titleLabel.text = @"Time";
        }else{
            numberLabel.text = self.model.reportMaxSpeed;
            titleLabel.text = @"Max Speed";
        }
          [self.view addSubview:numberLabel];
        [self.view addSubview:titleLabel];
    }
    for (int i = 0; i<3; i++) {//左边的三个内容
//        NSLog(@"得到的数组%@",self.showDataSource);
        UILabel *showLabel =[[UILabel alloc]initWithFrame: CGRectMake(0, CGRectGetMaxY(firstTitle.frame)+120+ i*40,MSWidth/2, 25)];
        showLabel.text = self.showDataSource[i];
        showLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        showLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:showLabel];
    }
    NSArray *dataArray = [[NSArray alloc]initWithObjects:self.model.reportSpeedUpTime,self.model.reportSpeedDownDistance,self.model.reportUp100Time, nil];
    
    for (int i = 0; i<3; i++) {//右边的三个内容
        UILabel *showLabel =[[UILabel alloc]initWithFrame: CGRectMake(MSWidth/2, CGRectGetMaxY(firstTitle.frame)+120+ i*40,MSWidth/2, 25)];
        showLabel.text = dataArray[i];
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
