//
//  DashboardSetting.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardSetting.h"


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
        self.DashBoardFristLoad = @"NO";
        self.addStyle  = AddStyleNone;
        self.ChangeStyle = ChangeDashboardStyleNone;
        self.CurrentPage = 0;
        self.HUDColourStr = @"44FF00";
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
- (void)initWithdashboardA{
    for (int i = 0; i<9; i++) {
        DashboardA *model =  [DashboardA new];
        [self initADDdashboardA:model];
        [model bg_saveOrUpdate];
    }
    
}
- (void)initADDdashboardA:(DashboardA *)model {
    bg_setDebug(YES);
     model.titleColor = @"FE9002";
    model.titleFontScale = [NSNumber numberWithFloat:1];
    model.titlePosition = [NSNumber numberWithFloat:1];
    
    model.ValueVisble = YES;
    model.ValueFontScale = [NSNumber numberWithFloat:1];
    model.ValuePosition =[NSNumber numberWithFloat:1];
    model.ValueColor = @"FE9002";
    
    model.LabelVisble = YES;
    model.LabelRotate = YES;
    model.LabelOffest = [NSNumber numberWithFloat:1];
    model.LabelFontScale = [NSNumber numberWithFloat:1];
    
    model.PointerVisble = YES;
    model.PointerWidth = [NSNumber numberWithFloat:10];
    model.PointerLength = [NSNumber numberWithFloat:(160/2) - 15 - 14];
    model.PointerColor = @"FE9002";
    
    model.KNOBRadius = [NSNumber numberWithFloat:10.f];
    model.KNOBColor = @"FFFFFF";
    
    model.Fillenabled = YES;
    model.FillstartAngle = [NSNumber numberWithFloat:0];
    model.FillEndAngle = [NSNumber numberWithFloat:0];
    model.FillColor = @"FE9002";
    
    model.UnitColor = @"FE9002";
    model.UnitFontScale = [NSNumber numberWithFloat:1];
    model.UnitVerticalPosition = [NSNumber numberWithFloat:1];
    model.UnitHorizontalPosition = [NSNumber numberWithFloat:1];
    
    model.StartAngle = [NSNumber numberWithFloat:0.f];
    model.endAngle = [NSNumber numberWithFloat:2*M_PI];
    model.ringWidth = [NSNumber numberWithFloat:10.f];
    model.maLength = [NSNumber numberWithFloat:15.f];
    model.miLength = [NSNumber numberWithFloat:5];
    model.miWidth = [NSNumber numberWithFloat:10.f];
    model.maWidth = [NSNumber numberWithFloat:10.f];
    model.maColor = @"FFFFFF";
    model.miColor = @"FFFFFF";
    model.innerColor = @"18191C";
    model.outerColor = @"18191C";
    model.orignx = [NSNumber numberWithFloat:0];
    model.origny = [NSNumber numberWithFloat:0];
    model.orignwidth = [NSNumber numberWithFloat:0];
    model.orignheight = [NSNumber numberWithFloat:0];
    model.minNumber = @"0";
    model.maxNumber = @"100";
    model.infoLabeltext = @"add";
    /**
     存储.
     */
}
- (void)initWithdashboardB{
    for (int i = 0; i<9; i++) {
        DashboardB *model =  [DashboardB new];
        [self initADDdashboardB:model];
         [model bg_saveOrUpdate];
    }


}
- (void)initADDdashboardB:(DashboardB *)model{
    bg_setDebug(YES);
    model.ValueColor  = @"#FFFFFF";
    model.ValueFontScale = [NSNumber numberWithFloat:1.f];
    model.ValuePositon = [NSNumber numberWithFloat:1.f];
    model.ValueVisible = YES;
    model.titleColor  = @"#757476";
    model.titleFontScale = [NSNumber numberWithFloat:1.f];
    model.titlePositon = [NSNumber numberWithFloat:1.f];
    
    model.UnitColor = @"#757476";
    model.UnitFontScale = [NSNumber numberWithFloat:1.f];
    model.UnitPositon = [NSNumber numberWithFloat:1.f];
    
    
    model.backColor = @"00a6ff";
    model.GradientRadius = [NSNumber numberWithFloat:MSWidth/2];
    
    model.FillColor = @"FE9002";
    model.FillEnable = YES;
    
    model.Pointerwidth = [NSNumber numberWithFloat:1.f];
    model.pointerColor = @"#FFFFFF";
    model.orignx = [NSNumber numberWithFloat:0];
    model.origny = [NSNumber numberWithFloat:0];
    model.orignwidth = [NSNumber numberWithFloat:0];
    model.orignheight = [NSNumber numberWithFloat:0];
    
    model.minNumber = @"0";
    model.maxNumber = @"100";
    model.infoLabeltext = @"add";

    /**
     存储.
     */
}
- (void)initWithdashboardC{
    for (int i = 0; i<9; i++) {
        DashboardC *model = [DashboardC new];
        [self initADDdashboardC:model];
         [model bg_saveOrUpdate];
    }
    
    
}
- (void)initADDdashboardC:(DashboardC *)model{
    bg_setDebug(YES);
    model.UnitColor = @"FFFFFF";
    model.UnitFontScale = [NSNumber numberWithFloat:1.f];
    model.UnitPositon = [NSNumber numberWithFloat:1.f];
    
    model.FrameColor = @"FFFFFF";
    model.titlePositon = [NSNumber numberWithFloat:1.f];
    model.titleFontScale =[NSNumber numberWithFloat:1.f];
    model.titleColor = @"FFFFFF";
    
    model.ValueColor = @"FFFFFF";
    model.ValueFontScale = [NSNumber numberWithFloat:1.f];
    model.ValuePositon = [NSNumber numberWithFloat:1.f];
    model.ValueVisible = YES;
    model.innerColor = @"000000";
    model.outerColor = @"000000";
    model.Gradientradius = [NSNumber numberWithFloat:MSWidth/2];
    model.orignx = [NSNumber numberWithFloat:0];
    model.origny = [NSNumber numberWithFloat:0];
    model.orignwidth = [NSNumber numberWithFloat:0];
    model.orignheight = [NSNumber numberWithFloat:0];
    
    model.minNumber = @"0";
    model.maxNumber = @"100";
    model.infoLabeltext = @"add";

    /**
     存储.
     */
   
}

- (void)initwithCustomDashboard{
   
    for (int i = 0; i< 9; i++) {
        if (i<6) {
        [self CustomDashboardType:AddStyleOne];
        }else if (i>=6 && i < 8){
        
        [self CustomDashboardType:AddStyleTwo];
        }else{
        [self CustomDashboardType:AddStyleThree];
        }
    }

}
- (void)CustomDashboardType:(AddDashboardStyle)type{
    
    CustomDashboard *model = [[CustomDashboard alloc]init];
    DashboardA *dashA = [DashboardA new];
    [self initADDdashboardA:dashA];
    model.dashboardA = dashA;
    
    DashboardB *dashB = [DashboardB new];
    [self initADDdashboardB:dashB];
    model.dashboardB = dashB;
    
    DashboardC *dashC = [DashboardC new];
    [self initADDdashboardC:dashC];
    model.dashboardC = dashC;
    
    switch (type) {
        case AddStyleOne:
        {
            model.dashboardType = 1;
            [model bg_saveOrUpdate];
        }
            break;
        case AddStyleTwo:
        {
            model.dashboardType = 2;
            [model bg_saveOrUpdate];
        }
            break;
        case AddStyleThree:
        {
            model.dashboardType = 3;
            [model bg_saveOrUpdate];
        }
            break;
        default:
            break;
    }

}
@end
