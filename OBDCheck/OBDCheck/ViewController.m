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
    UIImageView *statusView;
    UILabel  *statusLabel;
    UIImageView  *statusImageView;
    BOOL isSelect;
}

@property (nonatomic,strong) NSMutableArray *btnTitleArray;
@property (nonatomic,strong) NSMutableArray *btnImageArray;
@property (nonatomic,strong) bluetoothView *blueView;
@property (nonatomic,strong) NSMutableArray *normalImage;
@property (nonatomic,strong) NSMutableArray *selectImage;

@end

@implementation ViewController
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
     [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
     self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    //ColorTools colorWithHexString:@"#212329"
    [self initNavBarTitle:@"" andLeftItemImageName:@"Upload" andRightItemImageName:@"help"];
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithUI];

}

- (void)initWithUI{
    
    RLBtn * titleBtn= [[RLBtn alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleBtn setTitle:@"Connect" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [titleBtn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtn) forControlEvents:UIControlEventTouchUpInside];
    isSelect = YES;
    self.navigationItem.titleView = titleBtn;
//    [ColorTools colorWithHexString:@"#212329"];
    statusView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 11, MSWidth - 44, 41)];
    statusView.image = [UIImage imageNamed:@"information"];
    statusView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:statusView];
    //CGRectGetMaxX(statusView.frame)
    statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(statusView.frame) - 50, 10, 24, 20)];
    statusImageView.image = [UIImage imageNamed:@"signal"];
    statusImageView.contentMode = UIViewContentModeScaleAspectFill;
    [statusView addSubview:statusImageView];
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MSWidth - 86, 40)];
    statusLabel.text = @"Connect to the device successfully";
    statusLabel.font = [UIFont systemFontOfSize:16.f];
    [statusLabel setTextColor:[ColorTools colorWithHexString:@"#FE9002"]];
    [statusView addSubview:statusLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(statusView.frame), MSWidth, MSHeight - 165)];
    [self.view addSubview:backView];
    
    for (int i = 0; i<_btnTitleArray.count; i++) {
    
        OBDBtn *btn =[[OBDBtn alloc]initWithFrame: CGRectMake([setDistanceUtil setX:i], [setDistanceUtil setY:i], 100*MSWidth/375, 100*MSWidth/375 + 30)];
        btn.Label.text = _btnTitleArray[i];
        btn.imageView.image = [UIImage imageNamed:_btnImageArray[i]];
//        btn.backgroundColor= [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [btn addGestureRecognizer:tap];
      UIView *singleTapView  = [tap view];
        singleTapView.tag = i;
        [backView addSubview:btn];
        NSLog(@"%f",btn.frame.size.width);
    }

}
-(void)initWithData{
    self.btnImageArray = [[NSMutableArray alloc]initWithObjects:@"dashboards",@"diagnostics",@"montiors",@"logs",@"performance",@"settings", nil];
    self.btnTitleArray = [[NSMutableArray alloc]initWithObjects:@"Dashboards",@"Diagnostics",@"Montiors",@"Logs",@"Performance",@"Settings", nil];
    self.normalImage = [[NSMutableArray alloc]initWithObjects:@"obd_normal",@"special_normal",@"personal_normal", nil];
    self.selectImage = [[NSMutableArray alloc]initWithObjects:@"obd_highlight",@"special_highlight",@"personal_highlight", nil];
    
    NSLog(@"%f",4*MSWidth/15 );
    
}
#pragma mark 六个按钮的点击
- (void)tap:(UITapGestureRecognizer *)sender{
 self.tabBarController.tabBar.hidden = YES;
    switch ([sender view].tag) {
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


#pragma mark 导航栏的点击

- (void)titleBtn{
    if (isSelect) {
        NSLog(@"12");
         self.blueView= [[bluetoothView alloc]initWithFrame:CGRectMake(0, 64, MSWidth, 140)];
     [ self.blueView show];
        isSelect = NO;
    }else{
        NSLog(@"13");
        [ self.blueView hide];
        isSelect = YES;
    }
}
- (UIImage*)imageCompressWithSimple:(UIImage*)image{
    CGSize size = image.size;
    CGFloat scale = 1.0;
    //TODO:KScreenWidth屏幕宽
    if (size.width > 100 || size.height > 100) {
        if (size.width > size.height) {
            scale = 100 / size.width;
        }else {
            scale = 100 / size.height;
        }
    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize secSize =CGSizeMake(scaledWidth, scaledHeight);
    //TODO:设置新图片的宽高
    UIGraphicsBeginImageContext(secSize); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
