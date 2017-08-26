//
//  StyleCViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/26.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleCViewController.h"

@interface StyleCViewController ()
{
    DashboardViewStyleC  *dashViewC;
    NSInteger selectTag;
    UIButton *Fristbtn;
    UIButton *selectBtn;
}
@end

@implementation StyleCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithHeadUI];
}

- (void)initWithHeadUI{
 
    
    self.backColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCbackColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
     self.GradientColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCGradientColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.titleColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCtitleColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.titleFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCtitleFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.ValueVisible = [[DashboardSetting sharedInstance].defaults boolForKey:[NSString stringWithFormat:@"StyleCValueVisible%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValueColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCValueColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.ValueFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValueFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.ValuePositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCValuePositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.UnitColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCUnitColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.UnitFontScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitFontScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
    self.UnitPositon = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCUnitPositon%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.FrameColor = [[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"StyleCFrameColor%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    self.FrameScale = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCFrameScale%ld",[DashboardSetting sharedInstance].Dashboardindex]] ;
    
            dashViewC = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            [self.view addSubview:dashViewC];
           UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
    label.text = @"Value";
    label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
    label.font = [UIFont ToAdapFont:14.f];
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dashViewC.frame) + 10, CGRectGetMaxY(label.frame )+10, 150, 20)];
    self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(29, CGRectGetMaxY(dashViewC.frame) + 40, MSWidth - 58, 24)];
    _datasource = [[NSMutableArray alloc]initWithObjects:@"Frame",@"Axis",@"Needle",@"Range", nil];
    
    for (NSInteger i = 0; i< 4; i++) {
        selectTag = 0;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(btnView.frame.size.width/4), 0, btnView.frame.size.width/4, 24)];
        [btn setTitle:_datasource[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont ToAdapFont:13];
        if (i == 0) {
            Fristbtn = btn;
            [Fristbtn setTitleColor:[ColorTools colorWithHexString:@"#212329"] forState:UIControlStateNormal];
            Fristbtn.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        }else{
            [btn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
        }
        
        
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btnView addSubview:btn];
    }
    for (NSInteger i = 0; i< 5; i++) {
        UIView *LineView = [[UIView alloc]initWithFrame:CGRectMake(i*(btnView.bounds.size.width)/4, 0, 1, btnView.bounds.size.height)];
        LineView.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        [btnView addSubview:LineView];
    }
    for (NSInteger i = 0; i< 2; i++) {
        UIView *LineView = [[UIView alloc]initWithFrame:CGRectMake(0, i*(btnView.bounds.size.height), btnView.bounds.size.width,1)];
        LineView.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        [btnView addSubview:LineView];
    }
    [self.view addSubview:label];
    [self.view  addSubview:self.slider];
    [self.view  addSubview:self.NumberLabel];
    [self.view  addSubview:btnView];
    
    
}
- (void)btn:(UIButton *)btn{
    NSLog(@"111===%ld",(long)btn.tag);
    
    if (btn.tag != 0 && selectTag == 0) {
        NSLog(@"yyyyy");
        [Fristbtn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
        Fristbtn.backgroundColor = [UIColor clearColor];
        
    }
    if (btn.tag==0) {
        selectTag=1;
    }
    if(selectBtn == btn ) {
        //上次点击过的按钮，不做处理
    } else{
        //本次点击的按钮设为黑色
        [btn setTitleColor:[ColorTools colorWithHexString:@"#212329"] forState:UIControlStateNormal];
        btn.backgroundColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        
        
        //将上次点击过的按钮设为白色
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
        selectBtn.backgroundColor = [UIColor clearColor];
        
        
    }
    selectBtn= btn;
    
    
    
}
@end
