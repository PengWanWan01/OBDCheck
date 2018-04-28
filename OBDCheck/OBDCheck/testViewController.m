//
//  testViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/25.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DashStyleB *dash = [[DashStyleB alloc]initWithFrame:CGRectMake(50, 200, 204, 204)];

    CustomDashboard *model = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:3].lastObject;
    [dash  initWithModel:model];
    [self.view addSubview:dash];
//    BackGradient *Outerback = [[BackGradient alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    //767676 //C9C9C
//    [Outerback  initWithUIWidth:Outerback.frame.size.width withStartAngle:0 withendAngle:2*M_PI withstartPoint:CGPointMake(0, 0.5) withendPoint:CGPointMake(1, 0.5) withStartColor:[UIColor redColor] withendColor:[UIColor orangeRed]];
//    [self.view addSubview:Outerback];
   
//    RudiusGradient *dash = [[RudiusGradient alloc]initWithFrame:CGRectMake(100, 200, 250, 250)];
//    dash.backgroundColor = [UIColor orangeColor];
//    [dash initWithViewStartColor:[UIColor blueColor] withendColor:[UIColor redColor]];
//    
//    [self.view addSubview:dash];
//    groupView *view = [[groupView alloc]initWithFrame:CGRectMake(100, 200, 250, 250)];
//    view.backgroundColor = [UIColor orangeColor];
//
//    [view initWithborderwidth:20];
//    [self.view addSubview:view];
    
    
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
