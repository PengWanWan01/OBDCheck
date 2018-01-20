//
//  MonController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "MonController.h"

@interface MonController ()<TBarViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    TBarView *tbarView;
    NSInteger selectVC;
    NSMutableDictionary *listDic;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MonController *oneVc;
@property (nonatomic,strong) Sensors2ViewController *twoVC;
@property (nonatomic,strong) Mode06ViewController *ThreeVc;
@property (nonatomic,strong) Mode09ViewController *FourVc;
@end

@implementation MonController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Montiors" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    if (!(selectVC == 0)) {
        DLog(@"yes");
        [self reloadControlleView:selectVC];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 1, MSWidth, MSHeight-TopHigh) ;
    tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
        if (isLandscape) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
        }else{
            DLog(@"竖屏");
            [self setVerticalFrame];
        }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
}
#pragma mark 横屏
- (void)setHorizontalFrame{
}
- (void)initWithUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, MSWidth, MSHeight-TopHigh) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ResultsTableViewCell"];
    [self.tableView registerClass:[SummaryTableViewCell class] forCellReuseIdentifier:@"SummaryTableViewCell"];
    
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 0;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_normal",@"Sensor_normal",@"Mode06_normal",@"Mode09_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_highlight",@"Sensor_highlight",@"Mode06_highlight",@"Mode09_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Monitor Tests",@"O2 Sensors",@"Mode $06",@"Mode $09", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];

}
//根据字典中是否存在相关页面对应的key，没有的话存储
- (UIViewController *)controllerForSegIndex:(NSUInteger)segIndex {
    NSString *keyName = [NSString stringWithFormat:@"VC_%ld",(unsigned long)segIndex];
    
    UIViewController *controller = (UIViewController *)[listDic objectForKey:keyName];
    
    if (!controller) {
        if (segIndex == 0) {//申请
            controller = self.oneVc;
            
        }else if (segIndex == 1) {//待办
            controller = self.twoVC;
        }
        else if (segIndex == 2) {//待办
            controller = self.ThreeVc;
        }
        else if (segIndex == 3) {//待办
            controller = self.FourVc;
        }
        if(!(controller == nil)){
        [listDic setObject:controller forKey:keyName];
        }
    }
    
    return controller;
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    switch (touchSelectNumber) {
        case 0:
        {
            tbarView.isSelectNumber = 0;
        }
            break;
        case 1:
        {
            tbarView.isSelectNumber = 1;
        }
            break;
        case 2:
        {
            tbarView.isSelectNumber = 2;
        }
            break;
        case 3:
        {
            tbarView.isSelectNumber = 3;
        }
            break;
        default:
            break;
    }
    selectVC =  tbarView.isSelectNumber;
    [self reloadControlleView:touchSelectNumber];
}
- (void)reloadControlleView:(NSInteger)VCindex{
    [_oneVc.view   removeFromSuperview];
    [_twoVC.view removeFromSuperview];
    [_ThreeVc.view removeFromSuperview];
    [_FourVc.view removeFromSuperview];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (VCindex == 0) {
        [self initWithUI];
    }else{
        UIViewController *controller = [self controllerForSegIndex:VCindex];
        [self.view addSubview:controller.view];
    }
    [tbarView removeFromSuperview];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = selectVC;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_normal",@"Sensor_normal",@"Mode06_normal",@"Mode09_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_highlight",@"Sensor_highlight",@"Mode06_highlight",@"Mode09_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Monitor Tests",@"O2 Sensors",@"Mode $06",@"Mode $09", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];
}
- (void)back{
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    SummaryTableViewCell *Summarycell = [tableView dequeueReusableCellWithIdentifier:@"SummaryTableViewCell"];
    Summarycell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];

   ResultsTableViewCell *Resultcell = [tableView dequeueReusableCellWithIdentifier:@"ResultsTableViewCell"];
    Summarycell.selectionStyle = UITableViewCellSelectionStyleNone;
    Resultcell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    switch (indexPath.section) {
        case 0:
        {
            Summarycell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            if (indexPath.row == 2 || indexPath.row == 3) {
                Summarycell.textLabel.text = @"MIL ON";
            }else{
                Summarycell.textLabel.numberOfLines = 0;
                Summarycell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",@"This vehcile is not ready for emissions",@"testing"];
            }
            if (indexPath.row == 0) {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(MSWidth-32, 14, 22, 22)];
                image.image =[UIImage imageNamed:@"error"];
                Summarycell.accessoryView = image;
            }else{
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(MSWidth-32, 15, 24, 20)];
                image.image =[UIImage imageNamed:@"troubleCode_highLight"];
                Summarycell.accessoryView = image;
            }
            cell = Summarycell;
        }
            break;
        case 1:
        {
            cell = Resultcell;

        }
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
-(MonController *)oneVC{
    if (_oneVc == nil) {
        _oneVc = [[MonController alloc] init];
    }
    return _oneVc;
}


-(Sensors2ViewController *)twoVC{
    if (_twoVC == nil) {
        _twoVC = [[Sensors2ViewController alloc] init];
    }
    return _twoVC;
}
-(Mode06ViewController *)ThreeVc{
    if (_ThreeVc == nil) {
        _ThreeVc = [[Mode06ViewController alloc] init];
    }
    return _ThreeVc;
}
-(Mode09ViewController *)FourVc{
    if (_FourVc == nil) {
        _FourVc = [[Mode09ViewController alloc] init];
    }
    return _FourVc;
}
@end
