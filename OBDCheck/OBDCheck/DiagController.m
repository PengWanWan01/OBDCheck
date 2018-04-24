//
//  DiagController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DiagController.h"
static dispatch_source_t _timer;

@interface DiagController ()<UITableViewDelegate,UITableViewDataSource,BlueToothControllerDelegate>
{
    rotationView *roView;
    UILabel *infoLabel;
    UIProgressView *progressView;
    NSInteger totalNumber;
    NSInteger importantNumber;
    UIButton *totalBtn;
    UIButton *importantBtn;
    UITableView *MYTableView;
    NSString *sendType;
    UIView *showView;
    UIView *footView;
    BOOL isSave;
    UIButton *clearBtn;
    UIButton *HistoricalBtn;
    NSMutableDictionary *listDic;
}
@property (nonatomic,strong) NSMutableArray *typeimageData;
@property (nonatomic,copy) NSString *currentTime;

@end

@implementation DiagController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    if ([OBDLibTool sharedInstance].EnterSuccess == YES) {
        //请求故障码
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{              
              [[OBDLibTool sharedInstance] OBDIIReadDTC];
            });
    }
    [self initWithdata];
    [self initWithheadUI];
    [self initWithUI];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"readTroubleCode"object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (void)refreshUI{
    NSInteger importantCount=0,totalCount = 0;
    for (NSInteger i = 0; i<[OBDLibTool sharedInstance].troubleCodeArray.count; i++) {
        NSDictionary *dict = [OBDLibTool sharedInstance].troubleCodeArray[i];
        if ( [[dict allKeys].lastObject isEqualToString:@"important"]) {
            ++importantCount;
        }else if ( [ [dict allKeys].lastObject isEqualToString:@"total"]){
            ++totalCount;
        }
    }
    [importantBtn setTitle:[NSString stringWithFormat:@"Important:%lu",importantCount] forState:UIControlStateNormal];
    [totalBtn setTitle:[NSString stringWithFormat:@"Total:%lu",totalCount] forState:UIControlStateNormal];
    [MYTableView reloadData];
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
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
      roView.frame = CGRectMake(10*Kwidthmultiple, 8*KHeightmultiple, 100*Kwidthmultiple, 100*Kwidthmultiple);
    infoLabel.frame = CGRectMake(CGRectGetMaxX(roView.frame)+25*Kwidthmultiple, 32, 210*Kwidthmultiple, 46);
     progressView.frame  = CGRectMake(0, 116*KHeightmultiple,MSWidth, 4);
     showView.frame = CGRectMake(0, CGRectGetMaxY(progressView.frame)+10, MSWidth, 30);
    importantBtn.frame = CGRectMake(MSWidth/2, 0,MSWidth/2 , 20);
    totalBtn.frame = CGRectMake(0, 0,MSWidth/2 , 20);
    footView.frame = CGRectMake(0, 0, MSWidth, 180);
    clearBtn.frame = CGRectMake(57, 40, MSWidth - 114, 30);
    HistoricalBtn.frame = CGRectMake(57,CGRectGetMaxY(clearBtn.frame)+10,  MSWidth - 114, 30);
    MYTableView.frame = CGRectMake(0, CGRectGetMaxY(showView.frame), MSWidth, MSHeight-showView.frame.origin.y - showView.frame.size.height-70-49);
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
//    MYTableView.frame = CGRectMake(0, 34, SCREEN_MAX, _styleDataArray.count*44) ;
    roView.frame = CGRectMake(10*Kwidthmultiple, 8*KHeightmultiple, 100*Kwidthmultiple, 100*Kwidthmultiple);
    infoLabel.frame = CGRectMake(CGRectGetMaxX(roView.frame)+25*Kwidthmultiple, 32, 210*Kwidthmultiple, 46);
    progressView.frame  = CGRectMake(0, 116*KHeightmultiple,MSWidth, 4);
    
    showView.frame = CGRectMake(0, CGRectGetMaxY(progressView.frame)+10, SCREEN_MIN, 30);
    importantBtn.frame = CGRectMake(MSWidth/2, 0,MSWidth/2 , 20);
    totalBtn.frame = CGRectMake(0, 0,MSWidth/2 , 20);
    footView.frame = CGRectMake(0, 0, MSWidth, 180);
    clearBtn.frame = CGRectMake(57, 40, MSWidth - 114, 30);
    HistoricalBtn.frame = CGRectMake(57,CGRectGetMaxY(clearBtn.frame)+10,  MSWidth - 114, 30);
       MYTableView.frame = CGRectMake(0, CGRectGetMaxY(showView.frame), MSWidth, MSHeight-showView.frame.origin.y - showView.frame.size.height-70-49);
   
    
}

- (void)initWithdata{
    _typeimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_highLight",@"troubleCode_important",nil];
}
- (void)initWithUI{
   
    MYTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(showView.frame), MSWidth, MSHeight-showView.frame.origin.y - showView.frame.size.height-70-49) style:UITableViewStylePlain];
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
    showView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(progressView.frame)+10, SCREEN_MIN, 30)];
    [self.view addSubview:showView];
    for (NSInteger i = 0; i<2; i++) {
        
        if (i == 1) {
            importantBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_MIN/2, 0,SCREEN_MIN/2 , 20)];
            [importantBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
            importantBtn.titleLabel.font = [UIFont ToAdapFont:16];
            [importantBtn  setTitle:@"Important：0" forState:UIControlStateNormal] ;
            [importantBtn setImage:[UIImage imageNamed:_typeimageData[i]] forState:UIControlStateNormal];
            [showView addSubview:importantBtn];
        }else{
            
            totalBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_MAX/2, 0,SCREEN_MIN/2 , 20)];
            totalBtn.titleLabel.font = [UIFont ToAdapFont:16];
            [totalBtn setTitle:@"Total：0" forState:UIControlStateNormal];
            [totalBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
            [totalBtn setImage:[UIImage imageNamed:_typeimageData[i]] forState:UIControlStateNormal];
            [showView addSubview:totalBtn];
        }
    }

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
        model.toubleCode =[OBDLibTool sharedInstance].troubleCodeArray;
        model.currentTime = self.currentTime;
      [[OBDataModel sharedDataBase]insertTableName:@"troubleCodes" withdata:[model yy_modelToJSONString]];
        isSave = NO;
    }
}

#pragma mark蓝牙代理协议，处理信息
- (void)getDeviceInfo:(BELInfo *)info{
    
}
-(void)BlueToothState:(BlueToothState)state{
    
    
}
#pragma mark 收到数据
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
    DLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
  [OBDLibTool sharedInstance].backData  = data;
//    [OBDLibTool sharedInstance].currentData = data;
//
//    [[OBDLibTool sharedInstance] resolvingData:data withrequestData:[BlueTool hexToBytes:@"02000201"]];

}


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [OBDLibTool sharedInstance].troubleCodeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     DiagnosticsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"DiagnosticsTableViewCell"];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [OBDLibTool sharedInstance].troubleCodeArray[indexPath.row];
    NSDictionary *detailDict = [OBDLibTool sharedInstance].explainCodeArray[indexPath.row];

    DLog(@"数组%@",[dict allKeys].lastObject);
    if ( [[dict allKeys].lastObject isEqualToString:@"important"]) {
        Cell.nameTitle.text = [dict objectForKey:@"important"];
        Cell.detialTitle.text = [detailDict objectForKey:@"important"];
        Cell.toubleCodeType = toubleCodeTypeimportant;
    }else if ( [ [dict allKeys].lastObject isEqualToString:@"total"]){
         Cell.nameTitle.text = [dict objectForKey:@"total"];
        Cell.detialTitle.text = [detailDict objectForKey:@"total"];
        Cell.toubleCodeType = toubleCodeTypenormal;
    }
    return Cell;
}

/**
 刷新
 */
- (void)rightBarButtonClick{
    DLog(@"刷新");
}

@end
