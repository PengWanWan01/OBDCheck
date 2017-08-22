
//
//  StyleHeadView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleHeadView.h"

@implementation StyleHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        switch ([DashboardSetting sharedInstance].dashboardStyle ) {
            case DashboardStyleOne:{
              self.DashboardView = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            }
                break;
            case DashboardStyleTwo:{
                self.DashboardView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
            }
                break;
            case DashboardStyleThree:{
                   self.DashboardView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
                }
                break;
            default:
                break;
        }
        self.NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.DashboardView.frame) + 5, 150, 20)];
        self.NumberLabel.textAlignment = NSTextAlignmentCenter;
        self.NumberLabel.font = [UIFont ToAdapFont:12];
        self.NumberLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        self.NumberLabel.text = @"60";

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
        label.text = @"Value";
        label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        label.font = [UIFont ToAdapFont:14.f];
        
        self.slider = [[UISlider alloc]initWithFrame:CGRectMake(260, CGRectGetMaxY(label.frame )+10, 150, 20)];
        self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(29, CGRectGetMaxY(self.NumberLabel.frame) + 10, MSWidth - 58, 24)];
               _datasource = [[NSMutableArray alloc]initWithObjects:@"Frame",@"Axis",@"Needle",@"Range", nil];
        
        for (NSInteger i = 0; i< 4; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(btnView.frame.size.width/4), 0, btnView.frame.size.width/4, 24)];
            [btn setTitle:_datasource[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont ToAdapFont:13];
            [btn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            
            [btnView addSubview:btn];
        }
//        CGFloat distance = (CGFloat)(btnView.bounds.size.width)/4;
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
        [self addSubview:self.DashboardView];
        [self addSubview:label];
        [self addSubview:self.slider];
        [self addSubview:self.NumberLabel];
        [self addSubview:btnView];
        
        
    }
    return self;
}
- (void)btn:(UIButton *)btn{
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
