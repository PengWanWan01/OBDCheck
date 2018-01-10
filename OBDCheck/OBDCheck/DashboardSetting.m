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
        self.defaults = [NSUserDefaults standardUserDefaults];
        //        [self.defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:myObject] forKey:@"MyObjectKey"];
        
        [self.defaults synchronize];
        self.dashboardMode = DashboardCustomMode;
        self.dashboardStyle = DashboardStyleOne;
        self.numberDecimals = NumberDecimalZero;
        self.multiplierType = MultiplierType1;
        self.hudModeType = HUDModeTypeToNormal;
        self.KPageNumer = 3;
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
        self.HUDColourStr = @"44FF00";
        self.blueState = 0;
        self.protocolType = KWProtocol;
        //         [self.defaults setObject:@"11" forKey:[NSString stringWithFormat:@"test%ld",[DashboardSetting sharedInstance].Dashboardindex]];
        
    }
    return self;
}
-(void)SetDefultAttribute
{
    
    self.dashboardMode = DashboardClassicMode;
}


-(BOOL)SetAttribute:(CGFloat )Value Key:(NSString *)key
{
    //加入本地设置参数
    [self.defaults setFloat:Value forKey:[NSString stringWithFormat:@"%@",key]];
    
    return YES;
}

-(CGFloat )GetAttribute:(NSString *)Key
{
    //获取本地文件相关属性的值
    CGFloat result = [self.defaults floatForKey:[NSString stringWithFormat:@"%@",Key]];
    
    if (!result) {
        return 100.f;
    }
    return result;
}
- (void)initWithCustomDashboard{
    for (int i = 0; i<9; i++) {
        CustomDashboard *model =  [CustomDashboard new];
        [self initADDdashboardA:model withTag:i ];
        [self initADDdashboardB:model withTag:i ];
        [self initADDdashboardC:model withTag:i ];
        
        [model save];
    }
    
}
- (void)initADDCustomDashboard:(CustomDashboard *)model withTag:(NSInteger)i {
    
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
- (NSString * _Nonnull)extracted {
    return [NSString stringWithFormat:@"%f",150*KFontmultiple];
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
    model.DashboardAPID = @"";
    if (i>=6 && i<8) {
        model.DashboardAorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 100];
        model.DashboardAorigny =[NSString stringWithFormat:@"%f",(i -6) * (ScreenHeight/2)+(ScreenHeight/2 - 240)];
        model.DashboardAorignwidth =[NSString stringWithFormat:@"%d",220];
        model.DashboardAorignheight =[NSString stringWithFormat:@"%d",220+20];
    }else if (i==8){
        model.DashboardAorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN*2+(SCREEN_MIN- 300)/2];
        model.DashboardAorigny =[NSString stringWithFormat:@"%f",ScreenHeight/2 - 160];
        model.DashboardAorignwidth =[NSString stringWithFormat:@"%d",300];
        model.DashboardAorignheight =[NSString stringWithFormat:@"%d",300+20];
    }else{
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
        model.DashboardAorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
        model.DashboardAorigny =[NSString stringWithFormat:@"%f", page  * (((SCREEN_MIN)/2 - 30) + 40)+10];
        model.DashboardAorignwidth =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        model.DashboardAorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple +20];
    }
    //    model.PointerLength =[NSString stringWithFormat:@"%d":([model.orignwidth integerValue]/2) - 15 - 14];
    model.DashboardAPointerLength =[NSString stringWithFormat:@"%d",1];
    model.DashboardAminNumber = @"0";
    model.DashboardAmaxNumber = @"100";
    model.DashboardAinfoLabeltext = @"add";
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
        model.DashboardBorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 100];
        model.DashboardBorigny =[NSString stringWithFormat:@"%f",(i -6) * (ScreenHeight/2)+(ScreenHeight/2 - 220)];
        model.DashboardBorignwidth =[NSString stringWithFormat:@"%d",220];
        model.DashboardBorignheight =[NSString stringWithFormat:@"%d",220];
    }else if(i==8){
        model.DashboardBorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN*2+(SCREEN_MIN- 300)/2];
        model.DashboardBorigny =[NSString stringWithFormat:@"%f",ScreenHeight/2 - 150];
        model.DashboardBorignwidth =[NSString stringWithFormat:@"%d",300];
        model.DashboardBorignheight =[NSString stringWithFormat:@"%d",300];
    }else{
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
        model.DashboardBorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
        model.DashboardBorigny =[NSString stringWithFormat:@"%f",page  * (baseViewHeight + 40)+20];
        model.DashboardBorignwidth = [self extracted];
        model.DashboardBorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple];
    }
    
    model.DashboardBPID = @"";
    model.DashboardBminNumber = @"0";
    model.DashboardBmaxNumber = @"100";
    model.DashboardBinfoLabeltext = @"add";
    
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
        model.DashboardCorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN+ SCREEN_MIN/2 - 100];
        model.DashboardCorigny =[NSString stringWithFormat:@"%f",(i -6) * (ScreenHeight/2)+(ScreenHeight/2 - 220)];
        model.DashboardCorignwidth =[NSString stringWithFormat:@"%d",220];
        model.DashboardCorignheight =[NSString stringWithFormat:@"%d",220];
    }else if (i==8){
        model.DashboardCorignx =[NSString stringWithFormat:@"%f",SCREEN_MIN*2+(SCREEN_MIN- 300)/2];
        model.DashboardCorigny =[NSString stringWithFormat:@"%f",ScreenHeight/2 - 160];
        model.DashboardCorignwidth =[NSString stringWithFormat:@"%d",300];
        model.DashboardCorignheight =[NSString stringWithFormat:@"%d",300];
    }else{
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        CGFloat  space = SCREEN_MIN - 150*KFontmultiple*2 - 50;
        model.DashboardCorignx =[NSString stringWithFormat:@"%f",index * (space+ 150*KFontmultiple)+25];
        model.DashboardCorigny =[NSString stringWithFormat:@"%f",page  * (baseViewHeight + 40)+10];
        model.DashboardCorignwidth =[NSString stringWithFormat:@"%f",150*KFontmultiple];
        model.DashboardCorignheight =[NSString stringWithFormat:@"%f",150*KFontmultiple];
    }
    
    model.DashboardCPID = @"";
    model.DashboardCminNumber = @"0";
    model.DashboardCmaxNumber = @"100";
    model.DashboardCinfoLabeltext = @"add";
    
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
    [self initADDdashboardA:model withTag:i ];
    [self initADDdashboardB:model withTag:i];
    [self initADDdashboardC:model withTag:i];
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
    [model save];
    
}
@end

