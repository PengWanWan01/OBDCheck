//
//  DashboardSetting.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardSetting.h"
#define ScreenHeight (SCREEN_MAX - 100)

@implementation DashboardSetting
#pragma mark - 单例
+ (instancetype)sharedInstance {
    static DashboardSetting *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DashboardSetting alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAddDashboard = NO;
        self.ischangeDashboard = NO;
        self.isDashboardFont = NO;
        self.isDashboardMove = NO;
        self.isDashboardRemove = NO;
        self.RemoveDashboardNumber = 0;
        self.Dashboardindex = 0;
        self.DashBoardFristLoad = NO;
        self.addStyle  = AddStyleNone;
        self.ChangeStyle = ChangeDashboardStyleNone;
        self.CurrentPage = 0;
        self.blueState = 0;
        self.protocolType = KWProtocol;
        self.PIDDataSource  = [[NSArray alloc]initWithObjects:@"MPH",@"RPM",@"Altitude",@"Temperature",@"Pressure",@"Mass",@"Torque",@"Fuel Econmy",@"Airflow", nil];
        //         [self.defaults setObject:@"11" forKey:[NSString stringWithFormat:@"test%ld",[DashboardSetting sharedInstance].Dashboardindex]];
        
    }
    return self;
}




- (void)initWithdashboardA{
    for (int i = 0; i< 9; i++) {
        [self CustomDashboardType:AddStyleOne withTag:i];
    }
}
- (void)initWithdashboardB{
    for (int i = 0; i<9; i++) {
        [self CustomDashboardType:AddStyleTwo withTag:i];
    }
    
    
}

- (void)initADDdashboardA:(CustomDashboard *)model withTag:(NSInteger )i{
    model.DashboardAtitleColor = @"FE9002";
    model.DashboardAtitleFontScale = [NSString stringWithFormat:@"%d",1];
    model.DashboardAtitlePosition =[NSString stringWithFormat:@"%d",1];
    
    model.DashboardAValueVisble = YES;
    model.DashboardAValueFontScale =[NSString stringWithFormat:@"%d",1];
    model.DashboardAValuePosition =[NSString stringWithFormat:@"%d",1];
    model.DashboardAValueColor = @"FE9002";
    
    model.DashboardALabelVisble = YES;
    model.DashboardALabelRotate = YES;
    model.DashboardALabelOffest =[NSString stringWithFormat:@"%d",1];
    model.DashboardALabelFontScale =[NSString stringWithFormat:@"%d",1];
    
    model.DashboardAPointerVisble = YES;
    model.DashboardAPointerWidth =[NSString stringWithFormat:@"%d",10];
    model.DashboardAPointerColor = @"FE9002";
    
    model.DashboardAKNOBRadius =[NSString stringWithFormat:@"%f",10.f];
    model.DashboardAKNOBColor = @"FFFFFF";
    
    model.DashboardAFillenabled = YES;
    model.DashboardAFillstartAngle =[NSString stringWithFormat:@"%d",0];
    model.DashboardAFillEndAngle =[NSString stringWithFormat:@"%d",0];
    model.DashboardAFillColor = @"FE9002";
    
    model.DashboardAUnitColor = @"FE9002";
    model.DashboardAUnitFontScale =[NSString stringWithFormat:@"%d",1];
    model.DashboardAUnitVerticalPosition =[NSString stringWithFormat:@"%d",1];
    model.DashboardAUnitHorizontalPosition =[NSString stringWithFormat:@"%d",1];
    
    model.DashboardAStartAngle = [NSString stringWithFormat:@"%d", 0];
    model.DashboardAendAngle =[NSString stringWithFormat:@"%f", 2*M_PI];
  
    model.DashboardAringWidth =[NSString stringWithFormat:@"%f",10.f];
    model.DashboardAmaLength =[NSString stringWithFormat:@"%f",15.f];
    model.DashboardAmiLength =[NSString stringWithFormat:@"%d",5];
    model.DashboardAmiWidth =[NSString stringWithFormat:@"%f",10.f];
    model.DashboardAmaWidth =[NSString stringWithFormat:@"%f",10.f];
    model.DashboardAmaColor = @"FFFFFF";
    model.DashboardAmiColor = @"FFFFFF";
    model.DashboardAinnerColor = @"18191C";
    model.DashboardAouterColor = @"18191C";
    if (i>=6 && i<8) {
        if (IS_IPHONE_4_OR_LESS) {
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 100*KFontmultiple];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (220*KFontmultiple+10*KFontmultiple)+20*KFontmultiple];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",200*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",220*KFontmultiple];
        }else if(IS_IPHONE_X){
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 110*KFontmultiple];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (240*KFontmultiple+55*KFontmultiple)+50*KFontmultiple];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",220*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",240*KFontmultiple];
        }else{
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 110*KFontmultiple];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (240*KFontmultiple+20*KFontmultiple)+35*KFontmultiple];
        model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",220*KFontmultiple];
        model.Dashboardorignheight =[NSString stringWithFormat:@"%f",240*KFontmultiple];
        }
    }else if (i==8){
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN*2+((SCREEN_MIN- 300*KFontmultiple)/2)];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",ScreenHeight/2 - 160*KFontmultiple];
        model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",300*KFontmultiple];
        model.Dashboardorignheight =[NSString stringWithFormat:@"%f",320*KFontmultiple];
    }else{
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        if (IS_IPHONE_4_OR_LESS) {
            DLog(@"没错没错啊啊");
            CGFloat  space = SCREEN_MIN - 135*KFontmultiple*2 - 70*KFontmultiple;
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 135*KFontmultiple)+35*KFontmultiple];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f", page  * ((135*KFontmultiple +20*KFontmultiple) + 5*KFontmultiple)];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",135*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",135*KFontmultiple +20*KFontmultiple];
        }else if(IS_IPHONE_X){
            CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25*KFontmultiple];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f", page  * (150*KFontmultiple +50*KFontmultiple)+ 50*KFontmultiple];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",150*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple +20*KFontmultiple];
        }else{
            CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25*KFontmultiple];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f", page  * (150*KFontmultiple +35*KFontmultiple)+ 25*KFontmultiple];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",150*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple +20*KFontmultiple];
        }
    }
    //    model.PointerLength =[NSString stringWithFormat:@"%d":([model.orignwidth integerValue]/2) - 15 - 14];
    model.DashboardAPointerLength =[NSString stringWithFormat:@"%d",1];
    /**
     存储.
     */
}
- (void)initADDdashboardB:(CustomDashboard *)model withTag:(NSInteger)i{
    model.DashboardBValueColor  = @"#FFFFFF";
    model.DashboardBValueFontScale =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardBValuePositon =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardBValueVisible = YES;
    model.DashboardBtitleColor  = @"#757476";
    model.DashboardBtitleFontScale =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardBtitlePositon =[NSString stringWithFormat:@"%f",1.f];
    
    model.DashboardBUnitColor = @"#757476";
    model.DashboardBUnitFontScale =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardBUnitPositon =[NSString stringWithFormat:@"%f",1.f];
    
    
    model.DashboardBbackColor = @"00a6ff";
    model.DashboardBGradientRadius =[NSString stringWithFormat:@"%f",SCREEN_MIN/2];
    
    model.DashboardBFillColor = @"FE9002";
    model.DashboardBFillEnable = YES;
    
    model.DashboardBPointerwidth =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardBpointerColor = @"#FFFFFF";
    if (i>=6 && i<8)  {
        if (IS_IPHONE_4_OR_LESS) {
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 100*KFontmultiple];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (200*KFontmultiple+20*KFontmultiple)+15*KFontmultiple];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",200*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",200*KFontmultiple];
        }else if(IS_IPHONE_X){
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 110*KFontmultiple];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (220*KFontmultiple+60*KFontmultiple)+60*KFontmultiple];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",220*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",220*KFontmultiple];
        }else{
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 110*KFontmultiple];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (220*KFontmultiple+35*KFontmultiple)+40*KFontmultiple];
        model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",220*KFontmultiple];
        model.Dashboardorignheight =[NSString stringWithFormat:@"%f",220*KFontmultiple];
        }
        
    }else if(i==8){
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN*2+((SCREEN_MIN- 300*KFontmultiple)/2)];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",ScreenHeight/2 - 150*KFontmultiple];
        model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",300*KFontmultiple];
        model.Dashboardorignheight =[NSString stringWithFormat:@"%f",300*KFontmultiple];
    }else{
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        if (IS_IPHONE_4_OR_LESS) {
            CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",page  * (150*KFontmultiple + 10)];
            model.Dashboardorignwidth = [NSString stringWithFormat:@"%f",150*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        }else if(IS_IPHONE_X){
            CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",page  * (150*KFontmultiple+50*KFontmultiple)+45*KFontmultiple];
            model.Dashboardorignwidth = [NSString stringWithFormat:@"%f",150*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        }else{
        CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",page  * (150*KFontmultiple+35*KFontmultiple)+25*KFontmultiple];
        model.Dashboardorignwidth = [NSString stringWithFormat:@"%f",150*KFontmultiple];
        model.Dashboardorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        }
    }
    
    
    /**
     存储.
     */
}
- (void)initWithdashboardC {
    for (int i = 0; i<9; i++) {
        [self CustomDashboardType:AddStyleThree withTag:i];
    }
    
    
}
- (void)initADDdashboardC:(CustomDashboard *)model withTag:(NSInteger)i{
    model.DashboardCUnitColor = @"FFFFFF";
    model.DashboardCUnitFontScale =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardCUnitPositon =[NSString stringWithFormat:@"%f",1.f];
    
    model.DashboardCFrameColor = @"FFFFFF";
    model.DashboardCtitlePositon =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardCtitleFontScale =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardCtitleColor = @"FFFFFF";
    
    model.DashboardCValueColor = @"FFFFFF";
    model.DashboardCValueFontScale =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardCValuePositon =[NSString stringWithFormat:@"%f",1.f];
    model.DashboardCValueVisible = YES;
    model.DashboardCinnerColor = @"000000";
    model.DashboardCouterColor = @"000000";
    model.DashboardCGradientradius =[NSString stringWithFormat:@"%f",SCREEN_MIN/2];
    if (i>=6 && i<8)  {
         if (IS_IPHONE_4_OR_LESS) {
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 100*KFontmultiple];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (200*KFontmultiple+10*KFontmultiple)+30*KFontmultiple];
        model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",200*KFontmultiple];
             model.Dashboardorignheight =[NSString stringWithFormat:@"%f",200*KFontmultiple];
         }else if(IS_IPHONE_X){
             model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 110*KFontmultiple];
             model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (220*KFontmultiple+60*KFontmultiple)+60*KFontmultiple];
             model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",220*KFontmultiple];
             model.Dashboardorignheight =[NSString stringWithFormat:@"%f",220*KFontmultiple];
         }else{
             model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 110*KFontmultiple];
             model.Dashboardorigny =[NSString stringWithFormat:@"%f",(i -6) * (220*KFontmultiple+35*KFontmultiple)+40*KFontmultiple];
             model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",220*KFontmultiple];
             model.Dashboardorignheight =[NSString stringWithFormat:@"%f",220*KFontmultiple];
             }
    }else if (i==8){
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN*2+((SCREEN_MIN- 300*KFontmultiple)/2)];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",ScreenHeight/2 - 150];
        model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",300*KFontmultiple];
        model.Dashboardorignheight =[NSString stringWithFormat:@"%f",300*KFontmultiple];
    }else{
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        if (IS_IPHONE_4_OR_LESS) {
            CGFloat  space = SCREEN_MIN - 140*KFontmultiple*2 - 50;
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 140*KFontmultiple)+25];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",page  * (140*KFontmultiple + 20)];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",140*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",140*KFontmultiple];
        }else if(IS_IPHONE_X){
            CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
            model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
            model.Dashboardorigny =[NSString stringWithFormat:@"%f",page  * (150*KFontmultiple + 40*KFontmultiple)+50*KFontmultiple];
            model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",150*KFontmultiple];
            model.Dashboardorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        }else{
        CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
        model.Dashboardorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
        model.Dashboardorigny =[NSString stringWithFormat:@"%f",page  * (150*KFontmultiple + 35*KFontmultiple)+25*KFontmultiple];
        model.Dashboardorignwidth =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        model.Dashboardorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        }
    }
    
    
    /**
     存储.
     */
    
}

- (void)initwithCustomDashboard{
    
  
        for (int i = 0; i< 9; i++) {
            if (i<6) {
                [self CustomDashboardType:AddStyleOne withTag:i];
            }else if (i>=6 && i < 8){
                [self CustomDashboardType:AddStyleTwo withTag:i];
            }else{
                [self CustomDashboardType:AddStyleThree withTag:i];
            }
        }
  
    
    
}
- (void)CustomDashboardType:(AddDashboardStyle)type withTag:(NSInteger)i{
    
    CustomDashboard *model = [CustomDashboard new ];
    [self AddDashBoard:model with:i with:type];
    [[OBDataModel sharedDataBase]insertTableName:@"Dashboards" withdata:[model yy_modelToJSONString]];
}
- (void)AddDashBoard:(CustomDashboard *)model with:(NSInteger)i with:(AddDashboardStyle)type{
    [self initADDdashboardA:model withTag:i];
    [self initADDdashboardB:model withTag:i];
    [self initADDdashboardC:model withTag:i];
    model.DashboardPID = self.PIDDataSource[i];
    model.DashboardminNumber = @"0";
    model.DashboardmaxNumber = @"100";
    if ([model.DashboardPID isEqualToString:@"RPM"]) {
        model.DashboardmaxNumber = [NSString stringWithFormat:@"1000"] ;
    }
    
    NSInteger ID =  [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"dashID"];
    model.ID = ID;
    [[UserDefaultSet sharedInstance] SetIntegerAttribute:ID+1 Key:@"dashID"];
    
    switch (type) {
        case AddStyleOne:
        {
            model.dashboardType = 1;
        }
            break;
        case AddStyleTwo:
        {
            model.dashboardType = 2;
        }
            break;
        case AddStyleThree:
        {
            model.dashboardType = 3;
        }
            break;
        default:
            break;
    }
  
}
@end

