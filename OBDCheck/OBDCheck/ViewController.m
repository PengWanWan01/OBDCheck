//
//  ViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/7/31.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *statusView;
    UILabel  *statusLabel;
    UIImageView  *statusImageView;

}

@property (nonatomic,strong) NSMutableArray *btnTitleArray;
@property (nonatomic,strong) NSMutableArray *btnImageArray;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.title = @"Connect";
     self.view.backgroundColor = [ColorTools colorWithHexString:@"#EDEDED"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithUI];

}

- (void)initWithUI{
    statusView = [[UIView alloc]initWithFrame:CGRectMake(23, 75, MSWidth - 46, 40)];
    statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusView];
    //CGRectGetMaxX(statusView.frame)
    statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(statusView.frame) - 63, 0, 45, 40)];
    statusImageView.backgroundColor = [UIColor redColor];
    [statusView addSubview:statusImageView];
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSWidth - 86, 40)];
    statusLabel.text = @"Connect to the device successfully";
    statusLabel.font = [UIFont systemFontOfSize:16.f];
    [statusView addSubview:statusLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(statusView.frame) + 20, MSWidth, MSHeight - 49 - 150)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i<_btnTitleArray.count; i++) {
     
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake([setDistanceUtil setX:i], [setDistanceUtil setY:i], Button_Width, Button_Height)];
        btn.backgroundColor = [UIColor redColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:_btnTitleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_btnImageArray[i]] forState:UIControlStateNormal];

        CGFloat totalHeight = (btn.imageView.frame.size.height + btn.titleLabel.frame.size.height);
        // 设置按钮图片偏移
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - btn.imageView.frame.size.height), 0.0, 0.0, -btn.titleLabel.frame.size.width)];
        // 设置按钮标题偏移
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -btn.imageView.frame.size.width, -(totalHeight - btn.titleLabel.frame.size.height),0.0)];
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [backView addSubview:btn];
        NSLog(@"%f",btn.frame.size.width);
    }

}
-(void)initWithData{
    self.btnTitleArray = [[NSMutableArray alloc]initWithObjects:@"Dashboards",@"Diagnostics",@"Montiors",@"Logs",@"Performance",@"Settings", nil];
    self.btnImageArray = [[NSMutableArray alloc]initWithObjects:@"Dashboards",@"Diagnostics",@"Montiors",@"Logs",@"Performance",@"Settings", nil];
    NSLog(@"%f",4*MSWidth/15 );
    
}

- (void)btn:(UIButton *)btn{
 self.tabBarController.tabBar.hidden = YES;
    switch (btn.tag) {
        case 0:{
            DashboardController *vc = [[DashboardController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 1:{
            DiagController *vc = [[DiagController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 2:{
            MonController *vc = [[MonController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 3:{
            LogsController *vc = [[LogsController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 4:{
            PerformController *vc = [[PerformController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 5:{
            SetViewController *vc = [[SetViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        default:
            break;
    }

}


@end
