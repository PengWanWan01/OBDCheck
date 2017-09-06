//
//  DiagController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DiagController.h"

@interface DiagController ()<UITableViewDelegate,UITableViewDataSource>
{
    rotationView *roView;
    UILabel *infoLabel;
    UIView *lineView;
    NSInteger totalNumber;
    NSInteger importantNumber;
    UILabel *totalLabel;
    UILabel *importantLabel;
    UITableView *MYTableView;
}
@property (nonatomic,strong) NSMutableArray *typeimageData;
@property (nonatomic,strong) NSMutableArray *titleDataSource;

@end

@implementation DiagController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    UIViewController *navi = [self.navigationController.viewControllers objectAtIndex:0];
    self.tabBarItem.selectedImage=[[UIImage imageNamed:@"troubleCode_highLight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image= [[UIImage imageNamed:@"troubleCode_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.title = @"trouble Codes";
    [navi.navigationController setViewControllers:@[self] animated:NO];
    [self initNavBarTitle:@"Diagnostics" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
  }
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithdata];

    [self initWithUI];
    [self initWithheadUI];
}
- (void)initWithdata{
    _typeimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_highLight",@"troubleCode_important",nil];
    _titleDataSource = [[NSMutableArray alloc]initWithObjects:@"P0103",@"P0103",@"P0103",nil];

}
- (void)initWithUI{
  
    MYTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 205, MSWidth, MSHeight) style:UITableViewStylePlain];
    MYTableView.backgroundColor = [ColorTools colorWithHexString:@"18191D"];
    MYTableView.delegate =self;
    MYTableView.dataSource =self;
    MYTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MYTableView];
      [MYTableView registerNib:[UINib nibWithNibName:@"DiagnosticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiagnosticsTableViewCell"];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 180)];
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(57, 40, MSWidth - 114, 30)];
    clearBtn.backgroundColor = [ColorTools colorWithHexString:@"008EE5"];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn setTitle:@"Clear fault codes" forState:UIControlStateNormal];
    [footView addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *HistoricalBtn = [[UIButton alloc]initWithFrame:CGRectMake(57,CGRectGetMaxY(clearBtn.frame)+10,  MSWidth - 114, 30)];
    HistoricalBtn.backgroundColor = [ColorTools colorWithHexString:@"9E9E9E"];
    [HistoricalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [HistoricalBtn setTitle:@"Historical trouble code" forState:UIControlStateNormal];
    [footView addSubview:HistoricalBtn];
     [HistoricalBtn addTarget:self action:@selector(HistoricalBtn) forControlEvents:UIControlEventTouchUpInside];
    MYTableView.tableFooterView = footView;
}
- (void)initWithheadUI{
    roView = [[rotationView alloc]initWithFrame:CGRectMake(10*Kwidthmultiple, 8*KHeightmultiple, 100*Kwidthmultiple, 100*Kwidthmultiple)];
    roView.rotationImage.image = [UIImage imageNamed:@"rotation"];
    [self.view addSubview:roView];
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(roView.frame)+25*Kwidthmultiple, 32, 210*Kwidthmultiple, 46)];
    infoLabel.text = @"Checking the power system, please wait ...";
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont ToAdapFont:16.f];
    infoLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    [self.view addSubview:infoLabel];

    lineView  = [[UIView alloc]initWithFrame:CGRectMake(0, 116*KHeightmultiple,MSWidth, 4)];
    lineView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
    
    [self.view addSubview:lineView];
    
    for (NSInteger i = 0; i<2; i++) {
        UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(i*MSWidth/2, CGRectGetMaxY(lineView.frame)+20, MSWidth/2, 30)];
        showView.backgroundColor = [ColorTools colorWithHexString:@"#18191D"];
        [self.view addSubview:showView];
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(showView.frame.size.width/4, 10, 24, 20)];
        view.image = [UIImage imageNamed:_typeimageData[i]];
        [showView addSubview:view];
      
        if (i == 1) {
             importantLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 10,showView.frame.size.width -showView.frame.size.width/4- 24  , 20)];
            importantLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            importantLabel.font = [UIFont ToAdapFont:16];
            importantLabel.text = @"Important：01";
            [showView addSubview:importantLabel];
        }else{
          totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 10,showView.frame.size.width -showView.frame.size.width/4- 24  , 20)];
            totalLabel.font = [UIFont ToAdapFont:16];
            totalLabel.text = @"Total：01";
            totalLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];

        [showView addSubview:totalLabel];
        }
        
        
    }
   
    
}
- (void)clearBtn{

}
- (void)HistoricalBtn{
    HistoryViewController *vc = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)back{
   
  
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     DiagnosticsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"DiagnosticsTableViewCell"];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}
@end
