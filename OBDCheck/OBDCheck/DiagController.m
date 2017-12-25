//
//  DiagController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DiagController.h"
static dispatch_source_t _timer;

@interface DiagController ()<UITableViewDelegate,UITableViewDataSource,TBarViewDelegate,BlueToothControllerDelegate>
{
    rotationView *roView;
    UILabel *infoLabel;
    UIProgressView *progressView;
    NSInteger totalNumber;
    NSInteger importantNumber;
    UILabel *totalLabel;
    UILabel *importantLabel;
    UITableView *MYTableView;
    NSString *sendType;
    UIView *showView;
    UIView *footView;
    BOOL isSave;
    TBarView *tbarView;
    UIButton *clearBtn;
    UIButton *HistoricalBtn;
    UIView *lineView;
}
@property (nonatomic,strong) NSMutableArray *typeimageData;
@property (nonatomic,strong) NSMutableArray *totalDataSource;
@property (nonatomic,strong) NSMutableArray *importantDataSource;
@property (nonatomic,strong) NSMutableArray *troubleDataSource;
@property (nonatomic,copy) NSString *currentTime;
@end

@implementation DiagController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self initNavBarTitle:@"Diagnostics" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    [self.blueTooth SendData:[BlueTool hexToBytes:@"30370D"]];
    [self initWithdata];
    [self initWithheadUI];
    [self initWithUI];
  }
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
//    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
//        //翻转为竖屏时
//        DLog(@"竖屏");
//        [self setVerticalFrame];
//    }else
        if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
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
      roView.frame = CGRectMake(10*Kwidthmultiple, 8*KHeightmultiple, 100*Kwidthmultiple, 100*Kwidthmultiple);
    infoLabel.frame = CGRectMake(CGRectGetMaxX(roView.frame)+25*Kwidthmultiple, 32, 210*Kwidthmultiple, 46);
     progressView.frame  = CGRectMake(0, 116*KHeightmultiple,MSWidth, 4);
    [showView removeFromSuperview];
    showView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(progressView.frame)+10, SCREEN_MIN, 30)];
    [self.view addSubview:showView];
    for (NSInteger i = 0; i<2; i++) {
        UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(i*MSWidth/2, 0, MSWidth/2, 30)];
        itemView.backgroundColor = [ColorTools colorWithHexString:@"#18191D"];
        
        [showView addSubview:itemView];
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(itemView.frame.size.width/4, 5, 24, 20)];
        view.image = [UIImage imageNamed:_typeimageData[i]];
        [itemView addSubview:view];
        
        if (i == 1) {
            importantLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 5,itemView.frame.size.width -view.frame.size.width/4- 24  , 20)];
            importantLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            importantLabel.font = [UIFont ToAdapFont:16];
            //            importantLabel.text = @"Important：01";
            [itemView addSubview:importantLabel];
        }else{
            totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 5,itemView.frame.size.width -view.frame.size.width/4- 24  , 20)];
            totalLabel.font = [UIFont ToAdapFont:16];
            //            totalLabel.text = @"Total：01";
            totalLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            
            [itemView addSubview:totalLabel];
        }
    }
    footView.frame = CGRectMake(0, 0, SCREEN_MIN, 180);
    clearBtn.frame = CGRectMake(57, 40, SCREEN_MIN - 114, 30);
    HistoricalBtn.frame = CGRectMake(57,CGRectGetMaxY(clearBtn.frame)+10,  MSWidth - 114, 30);
    MYTableView.frame = CGRectMake(0, CGRectGetMaxY(showView.frame), MSWidth, MSHeight-showView.frame.origin.y - showView.frame.size.height-70);
    
    tbarView.frame = CGRectMake(0, SCREEN_MAX - 49-TopHigh, SCREEN_MIN, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, SCREEN_MAX - 49-TopHigh-34,SCREEN_MIN , 49);
    }
}
#pragma mark 横屏
- (void)setHorizontalFrame{
//    MYTableView.frame = CGRectMake(0, 34, SCREEN_MAX, _styleDataArray.count*44) ;
    roView.frame = CGRectMake(10*Kwidthmultiple, 8*KHeightmultiple, 100*Kwidthmultiple, 100*Kwidthmultiple);
    infoLabel.frame = CGRectMake(CGRectGetMaxX(roView.frame)+25*Kwidthmultiple, 32, 210*Kwidthmultiple, 46);
    progressView.frame  = CGRectMake(0, 116*KHeightmultiple,MSWidth, 4);
    
    [showView removeFromSuperview];
    showView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(progressView.frame)+10, SCREEN_MAX, 30)];
//    showView.backgroundColor = [UIColor redColor];
    [self.view addSubview:showView];
    for (NSInteger i = 0; i<2; i++) {
         UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_MAX/2, 0, SCREEN_MAX/2, 30)];
        itemView.backgroundColor = [ColorTools colorWithHexString:@"#18191D"];
        
        [showView addSubview:itemView];
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(itemView.frame.size.width/4, 5, 24, 20)];
        view.image = [UIImage imageNamed:_typeimageData[i]];
        [itemView addSubview:view];
        
        if (i == 1) {
            importantLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 5,itemView.frame.size.width -view.frame.size.width/4- 24  , 20)];
            importantLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            importantLabel.font = [UIFont ToAdapFont:16];
                        importantLabel.text = @"Important：01";
            [itemView addSubview:importantLabel];
        }else{
            totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 5,itemView.frame.size.width -view.frame.size.width/4- 24  , 20)];
            totalLabel.font = [UIFont ToAdapFont:16];
                        totalLabel.text = @"Total：01";
            totalLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            
            [itemView addSubview:totalLabel];
        }
    }
    footView.frame = CGRectMake(0, 0, SCREEN_MAX, 180);
    clearBtn.frame = CGRectMake(57, 40, SCREEN_MAX - 114, 30);
    HistoricalBtn.frame = CGRectMake(57,CGRectGetMaxY(clearBtn.frame)+10,  SCREEN_MAX - 114, 30);
       MYTableView.frame = CGRectMake(0, CGRectGetMaxY(showView.frame), SCREEN_MAX, SCREEN_MIN-showView.frame.origin.y - showView.frame.size.height-70);
    tbarView.frame = CGRectMake(0, SCREEN_MIN - 49-TopHigh, SCREEN_MAX, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, SCREEN_MIN - 49-TopHigh-34,SCREEN_MAX , 49);
    }
    
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
- (void)initWithdata{
    _typeimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_highLight",@"troubleCode_important",nil];
    self.totalDataSource = [[NSMutableArray alloc]init];
    self.importantDataSource = [[NSMutableArray alloc]init];
    self.troubleDataSource = [[NSMutableArray alloc]init];
}
- (void)initWithUI{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    MYTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(showView.frame), MSWidth, MSHeight-showView.frame.origin.y - showView.frame.size.height-70) style:UITableViewStylePlain];
    MYTableView.backgroundColor = [ColorTools colorWithHexString:@"18191D"];
    MYTableView.delegate =self;
    MYTableView.dataSource =self;
    MYTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MYTableView];
      [MYTableView registerNib:[UINib nibWithNibName:@"DiagnosticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiagnosticsTableViewCell"];
    footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 180)];
    clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(57, 40, MSWidth - 114, 30)];
    clearBtn.backgroundColor = [ColorTools colorWithHexString:@"008EE5"];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn setTitle:@"Clear fault codes" forState:UIControlStateNormal];
    [footView addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearBtn) forControlEvents:UIControlEventTouchUpInside];
    HistoricalBtn = [[UIButton alloc]initWithFrame:CGRectMake(57,CGRectGetMaxY(clearBtn.frame)+10,  MSWidth - 114, 30)];
    HistoricalBtn.backgroundColor = [ColorTools colorWithHexString:@"9E9E9E"];
    [HistoricalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [HistoricalBtn setTitle:@"Historical trouble code" forState:UIControlStateNormal];
    [footView addSubview:HistoricalBtn];
    [HistoricalBtn addTarget:self action:@selector(HistoricalBtn) forControlEvents:UIControlEventTouchUpInside];
    MYTableView.tableFooterView = footView;
    
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth , 49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 0;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_normal",@"freeze_normal",@"readiness_normal",@"report_normal", nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_highLight",@"Freeze_highlight",@"readiness_highLight",@"report_highLight", nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"trouble Codes",@"Freeze Frame",@"Readiness Test",@"Report", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    
    [self.view addSubview:tbarView];
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    [self save];
    switch (touchSelectNumber) {
        case 0:
        {
            DiagController *vc = [[DiagController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            FreezeViewController *vc = [[FreezeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            ReadinessViewController *vc = [[ReadinessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 3:
        {
            ReportViewController *vc = [[ReportViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
}
- (void)initWithheadUI{
    roView = [[rotationView alloc]initWithFrame:CGRectMake(10*Kwidthmultiple, 8*KHeightmultiple, 100*Kwidthmultiple, 100*Kwidthmultiple)];
    [roView rotate360WithDuration:0.1 repeatCount:50];
    roView.rotationImage.image = [UIImage imageNamed:@"rotation"];
    [self.view addSubview:roView];
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(roView.frame)+25*Kwidthmultiple, 32, 210*Kwidthmultiple, 46)];
    infoLabel.text = @"Checking the power system, please wait ...";
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont ToAdapFont:16.f];
    infoLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    [self.view addSubview:infoLabel];

    progressView  = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 116*KHeightmultiple,MSWidth, 4)];
    progressView.progress = 0;
    progressView.trackTintColor= [ColorTools colorWithHexString:@"#C8C6C6"];
    progressView.progressTintColor= [ColorTools colorWithHexString:@"#FE9002"];
    [self.view addSubview:progressView];
    NSTimeInterval period = 1; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress =   progressView.progress+0.2;
            roView.numberLabel.text = [NSString stringWithFormat:@"%.f%%",progressView.progress*100];
            
            if (progressView.progress == 1) {
                 dispatch_source_cancel(_timer);
            }
        });
    });
    
    // 开启定时器
    dispatch_resume(_timer);

}
#pragma mark 清楚故障码
- (void)clearBtn{
    [self.blueTooth SendData:[BlueTool hexToBytes:@"30340D"]];
}
- (void)HistoricalBtn{
    
    HistoryViewController *vc = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self save];
}
- (void)save{
    if (isSave == YES) {
        troubleCodeModel *model = [troubleCodeModel new];
        model.toubleCode = self.troubleDataSource;
        model.currentTime = self.currentTime;
        [model bg_saveOrUpdate];
        isSave = NO;
    }
}
-(void)back{
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
    [self save];
}
#pragma mark蓝牙代理协议，处理信息
- (void)getDeviceInfo:(BELInfo *)info{
    
}
-(void)BlueToothState:(BlueToothState)state{
    
    
}
#pragma mark 收到数据
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
    DLog(@"收到收到%@",data);
    
    DLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DLog(@"最后的数据%@,数据长度%ld",string,(unsigned long)string.length);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    isSave  = YES;
    self.currentTime = [formatter stringFromDate:datenow];
    [self.troubleDataSource addObject:string];
    NSString *code03Str = [BlueTool istroubleCode03:string];
    NSString *code07Str = [BlueTool istroubleCode07:string];
    NSString *code0aStr = [BlueTool istroubleCode0a:string];

    if (!(code07Str == nil)) {
         DLog(@"得到%@",code07Str);
        //发送命令为07
        sendType = @"07";
        switch ([DashboardSetting sharedInstance].protocolType) {
            case CanProtocol:
                {
                    for (NSInteger i = 0; i<code07Str.length/4; i++) {
                        NSString *codeStr = [code07Str substringWithRange:NSMakeRange(i*4, 4)];
                        [self getCodeType:codeStr];
                        DLog(@"四个数的故障码%@",codeStr);
                    }
                }
                break;
            case KWProtocol:
            {
                [self getTroubleCode:string];
            }
                break;
            default:
                break;
        }
        [self.blueTooth SendData:[BlueTool hexToBytes:@"30330D"]];
    }
        if (!(code03Str == nil)) {
            DLog(@"得到%@",code03Str);
            //发送命令为07
            sendType = @"03";
            switch ([DashboardSetting sharedInstance].protocolType) {
                case CanProtocol:
                {
                    for (NSInteger i = 0; i<code03Str.length/4; i++) {
                        NSString *codeStr = [code03Str substringWithRange:NSMakeRange(i*4, 4)];
                        [self getCodeType:codeStr];
                        DLog(@"四个数的故障码%@",codeStr);
                    }
                }
                    break;
                case KWProtocol:
                {
                [self getTroubleCode:string];
                }
                    break;
                default:
                    break;
            }
            [self.blueTooth SendData:[BlueTool hexToBytes:@"30410D"]];
        }
        
        if (!(code0aStr == nil)) {
               DLog(@"得到%@",code0aStr);
            //发送命令为07
            sendType = @"0a";
            switch ([DashboardSetting sharedInstance].protocolType) {
                case CanProtocol:
                {
                    for (NSInteger i = 0; i<code0aStr.length/4; i++) {
                        NSString *codeStr = [code0aStr substringWithRange:NSMakeRange(i*4, 4)];
                        [self getCodeType:codeStr];
                        DLog(@"四个数的故障码%@",codeStr);
                    }
                }
                    break;
                case KWProtocol:
                {
            [self getTroubleCode:string];
                }
                    break;
                default:
                    break;
            }
          
        }
    
}
- (void)getTroubleCode:(NSString *)strring{
    NSString *numberStr = [strring substringWithRange:NSMakeRange(1, 1)];
    //获取一条数据的故障码
    [self getcode:strring];
    
    if (![[strring substringWithRange:NSMakeRange(8+([numberStr integerValue]*2), 1)] isEqualToString:@">"]) {
        DLog(@"如果发完第一条之后还没有结束");
        NSString *nextStr = [strring substringWithRange:NSMakeRange(8+([numberStr integerValue]*2), strring.length- 1-8-([numberStr integerValue]*2))];
        DLog(@"剩下的内容%@",nextStr);
        [self getcode:nextStr];
        
    }
    
}
- (void)getcode:(NSString *)str{
    NSString *numberStr = [str substringWithRange:NSMakeRange(1, 1)];
    DLog(@"%ldd",(long)([numberStr integerValue] - 1)/2);
    for (NSInteger i = 0; i< ([numberStr integerValue] - 1)/2; i++) {
        NSString *codeStr= [str substringWithRange:NSMakeRange(8+(4*i), 4)];
        if (![codeStr isEqualToString:@"0000"]) {
            DLog(@"最终获取出去0000的故障码%@",codeStr);
            [self getCodeType:codeStr];
        }
    }
    
}
#pragma mark 得到最终故障码将故障码的十六进制变为二进制，取二进制的最高位，获得去P、C、B、U的哪一位；
- (void)getCodeType:(NSString *)codeStr{
    NSString *str = [BlueTool getBinaryByHex:codeStr];
    NSString *nextStr = [@"00" stringByAppendingString:[str substringFromIndex:2]];
    NSInteger index = [BlueTool getDecimalByBinary:[str substringToIndex:2]];
    NSString *nextIndex = [BlueTool getHexByBinary:nextStr];
    NSArray *arr =  [[NSArray alloc]initWithObjects:@"P",@"C",@"B",@"U", nil];
    NSString *resultCode = [NSString stringWithFormat:@"%@%@",arr[index],nextIndex];
    if([sendType isEqualToString:@"03"]){
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:resultCode,@"important",nil];
        [self.importantDataSource addObject:dict];
        [self.totalDataSource addObject:dict];
    }else{
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:resultCode,@"total",nil];
        [self.totalDataSource addObject:dict];
    }
    [self refreshUI];
}
- (void)refreshUI{
    importantLabel.text = [NSString stringWithFormat:@"Important:%lu",(unsigned long)self.importantDataSource.count];
    totalLabel.text = [NSString stringWithFormat:@"Total:%lu",(unsigned long)self.totalDataSource.count];
    [MYTableView reloadData];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.totalDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     DiagnosticsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"DiagnosticsTableViewCell"];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.totalDataSource[indexPath.row];
    DLog(@"数组%@",[dict allKeys].lastObject);
    if ( [[dict allKeys].lastObject isEqualToString:@"important"]) {
        Cell.nameTitle.text = [dict objectForKey:@"important"];
        Cell.toubleCodeType = toubleCodeTypeimportant;
    }else if ( [ [dict allKeys].lastObject isEqualToString:@"total"]){
         Cell.nameTitle.text = [dict objectForKey:@"total"];
        Cell.toubleCodeType = toubleCodeTypenormal;
    }
    return Cell;
}
@end
