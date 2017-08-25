
//
//  StyleHeadView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleHeadView.h"

@interface StyleHeadView()
{
    NSInteger selectTag;
    UIButton *Fristbtn;
}
@end

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
              self.DashViewA = [[DashboardView alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
                [self.DashViewA drawCalibration:M_PI WithendAngle:2*M_PI WithRingWidth:10.f MAJORTICKSWidth:0 MAJORTICKSLength:15.f MAJORTICKSColor:[UIColor whiteColor] MINORTICKSWidth:0 MINORTICKSLength:5.f MAJORTICKSColor:[UIColor whiteColor] LABELSVisible:YES Rotate:YES Font:[UIFont systemFontOfSize:10.f] OffestTickline:0];
                self.View = self.DashViewA;
                [self addSubview:self.DashViewA];
            }
                break;
            case DashboardStyleTwo:{
                self.DashViewB = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
                self.View = self.DashViewB;

                [self addSubview:self.DashViewB];
            }
                break;
            case DashboardStyleThree:{
                   self.DashViewC = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake(30*KFontmultiple, 23*KFontmultiple, 150*KFontmultiple, 150*KFontmultiple)];
                self.View = self.DashViewC;
                [self addSubview:self.DashViewC];
                }
                break;
            default:
                break;
        }
        self.NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.View.frame) + 5, 150, 20)];
        self.NumberLabel.textAlignment = NSTextAlignmentCenter;
        self.NumberLabel.font = [UIFont ToAdapFont:12];
        self.NumberLabel.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        self.NumberLabel.text = @"60";

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(262*KFontmultiple, 84*KFontmultiple, 36*KFontmultiple, 23*KFontmultiple)];
        label.text = @"Value";
        label.textColor = [ColorTools colorWithHexString:@"#FE9002"];
        label.font = [UIFont ToAdapFont:14.f];
        
        self.slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.View.frame) + 10, CGRectGetMaxY(label.frame )+10, 150, 20)];
        self.slider.minimumTrackTintColor = [ColorTools colorWithHexString:@"FE9002"];
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(29, CGRectGetMaxY(self.NumberLabel.frame) + 10, MSWidth - 58, 24)];
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
        [self addSubview:label];
        [self addSubview:self.slider];
        [self addSubview:self.NumberLabel];
        [self addSubview:btnView];
        
        
    }
    return self;
}

- (void)btn:(UIButton *)btn{
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
    
    if ([self.delegate respondsToSelector:@selector(switchWithIndex:)]) {
        [self.delegate switchWithIndex:btn.tag];
    }

}
@end
