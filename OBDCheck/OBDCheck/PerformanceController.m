
//
//  PerformanceController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/13.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PerformanceController.h"
typedef NS_ENUM(NSInteger ,testMode)
{
    testMPH=0,   //测试速度
    testMI     //测试路程
    
};
@interface PerformanceController ()
{
    UIView *hpFillView;
    UIView *lbFillView;
    UIView *sheetView;
    UIImageView *dashimageView;
    UILabel *hpLabel;
    UILabel *lbLabel;
    UILabel *resultlabel;
}
@property (nonatomic,strong) NSMutableArray *btntitleDataSource;
@property (nonatomic,strong) NSMutableArray *titileDataSource;
@property (nonatomic,assign) testMode testmode;
@end

@implementation PerformanceController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Performance" andLeftItemImageName:@"back" andRightItemName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.btntitleDataSource = [[NSMutableArray alloc]initWithObjects:@"Start",@"Results",@"0-60 MPH", nil];
    self.titileDataSource = [[NSMutableArray alloc]initWithObjects:@"1/4 mi",@"1000 ft",@"1/8 mi",@"330ft",@"60 ft", nil];
    self.testmode = testMPH;
    [self initWithUI];
}
- (void)initWithUI{
    
    dashimageView = [[UIImageView alloc]initWithFrame:CGRectMake((MSWidth-299)/2, 5, 299, 215)];
    dashimageView.image = [UIImage imageNamed:@"performance_ dash"];
    [self.view addSubview:dashimageView];
    if (IS_IPHONE_5) {
         hpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dashimageView.frame)+5, 30, 20)];
        lbLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(hpLabel.frame)+10, 30, 20)];
    }else if (IS_IPHONE_6){
        hpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dashimageView.frame)+10, 30, 30)];
        hpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dashimageView.frame)+10, 30, 30)];
        lbLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(hpLabel.frame)+20, 30, 30)];
    }
    else{
         hpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dashimageView.frame)+10, 30, 30)];
         hpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dashimageView.frame)+10, 30, 30)];
        lbLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(hpLabel.frame)+20, 30, 30)];
    }
    hpLabel.font = [UIFont systemFontOfSize:14.f];
    hpLabel.text = @"hp";
    hpLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    [self.view addSubview:hpLabel];
    lbLabel.font = [UIFont systemFontOfSize:14.f];
    lbLabel.text = @"lb.ft";
    lbLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    [self.view addSubview:lbLabel];
    
    [self initWithMPHUI];
    
//底部三个按钮
    for (NSInteger i = 0; i<3; i++) {
        UIButton *btn ;
        if (IS_IPHONE_5) {
        btn = [[UIButton alloc]initWithFrame:CGRectMake(10+((MSWidth - 20)/3 +3)*i, MSHeight -self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height -50, (MSWidth - 20-6)/3, 40)];
        }else{
             btn = [[UIButton alloc]initWithFrame:CGRectMake(10+((MSWidth - 20)/3 +3)*i, MSHeight -self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height -50, (MSWidth - 20-6)/3, 40)];
        }
        btn.layer.cornerRadius = 10.f;
        btn.layer.masksToBounds  =YES;
        btn.layer.borderWidth = 1.f;
        btn.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
        NSLog(@"叉叉叉%ld",(long)i);
        if (i == 2) {
            NSLog(@"%ld",(long)i);
           [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
             btn.layer.borderColor = [ColorTools colorWithHexString:@"C8C6C6"].CGColor;
        }else{
        btn.layer.borderColor = [ColorTools colorWithHexString:@"3B3F49"].CGColor;
        [btn setTitleColor:[ColorTools colorWithHexString:@"3B3F49"] forState:UIControlStateNormal];
        }
        [btn setTitle:self.btntitleDataSource[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
        
    }
    UIView *hpView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hpLabel.frame)+5, hpLabel.frame.origin.y, MSWidth-20-hpLabel.frame.origin.x- hpLabel.frame.size.width , hpLabel.frame.size.height)];
    hpView.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
    [self.view addSubview:hpView];
    
    UIView *lbView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbLabel.frame)+5, lbLabel.frame.origin.y, MSWidth-20-lbLabel.frame.origin.x- lbLabel.frame.size.width , lbLabel.frame.size.height)];
    lbView.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
    [self.view addSubview:lbView];
    
    hpFillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, hpView.frame.size.height)];
    hpFillView.backgroundColor= [ColorTools colorWithHexString:@"FF000F"];
    [hpView addSubview:hpFillView];
    
    lbFillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, lbView.frame.size.height)];
    lbFillView.backgroundColor= [ColorTools colorWithHexString:@"0E09ED"];
    [lbView addSubview:lbFillView];

//画hp右边的线
    [self drawLine:CGPointMake(CGRectGetMaxX(hpLabel.frame)+10, hpLabel.frame.origin.y+hpLabel.frame.size.height) WithEndPoint:CGPointMake(hpView.frame.origin.x+hpView.frame.size.width-5, hpLabel.frame.origin.y+hpLabel.frame.size.height) lineWidth:1.f withView:self.view];
//画lb右边的线
   [self drawLine:CGPointMake(CGRectGetMaxX(lbLabel.frame)+10, lbLabel.frame.origin.y+lbLabel.frame.size.height) WithEndPoint:CGPointMake(lbView.frame.origin.x+lbView.frame.size.width-5, lbLabel.frame.origin.y+lbLabel.frame.size.height) lineWidth:1.f withView:self.view];
//画短的刻度线
    for (NSInteger i = 0; i<6; i++) {
       [self drawLine:CGPointMake((CGRectGetMaxX(hpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, hpLabel.frame.origin.y+hpLabel.frame.size.height) WithEndPoint:CGPointMake((CGRectGetMaxX(hpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, hpLabel.frame.origin.y+hpLabel.frame.size.height-5) lineWidth:1.f withView:self.view];
        
        [self drawLine:CGPointMake((CGRectGetMaxX(lbLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, lbLabel.frame.origin.y+lbLabel.frame.size.height) WithEndPoint:CGPointMake((CGRectGetMaxX(lbLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, lbLabel.frame.origin.y+lbLabel.frame.size.height-5)lineWidth:1.f withView:self.view];
        UILabel *hplabel = [[UILabel alloc]initWithFrame:CGRectMake(((hpView.frame.size.width/5)-3)*i, 0, (hpView.frame.size.width/6)-2, 20)];
        NSString *labelstr = [NSString stringWithFormat:@"%ld",(long)i*100];
        hplabel.font = [UIFont systemFontOfSize:10.f];
        hplabel.text = labelstr;
        hplabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        [hpView addSubview:hplabel];
        
        UILabel *lblabel = [[UILabel alloc]initWithFrame:CGRectMake(((lbView.frame.size.width/5)-3)*i, 0, (lbView.frame.size.width/6)-2, 20)];
        NSString *lblabelstr = [NSString stringWithFormat:@"%ld",(long)i*100];
        lblabel.font = [UIFont systemFontOfSize:10.f];
        lblabel.text = lblabelstr;
        lblabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        [lbView addSubview:lblabel];
     
    }

    
}
- (void)drawLine:(CGPoint )startPoint WithEndPoint:(CGPoint )endPoint lineWidth:(CGFloat)linewidth withView:(UIView *)view{
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:startPoint];
    // 其他点
    [linePath addLineToPoint:endPoint];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = linewidth;
    lineLayer.strokeColor = [ColorTools colorWithHexString:@"C8C6C6"].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [view.layer addSublayer:lineLayer];
}
- (void)btn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            {
                
            }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            [sheetView removeFromSuperview];
            if (self.testmode == testMPH) {
                self.testmode = testMI;
                [btn setTitle:@"1/4 mi" forState:UIControlStateNormal];
                [self initWithMIUI];
            }else{
                self.testmode = testMPH;
                [resultlabel removeFromSuperview];
                [btn setTitle:@"0-60 MPH" forState:UIControlStateNormal];
                [self initWithMPHUI];

            }
            
        }
            break;
        default:
            break;
    }
}
- (void)initWithMIUI{
    
    resultlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lbLabel.frame)+20, MSWidth-40, 20)];
    resultlabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    resultlabel.text  = @"0-60 MPH Results";
    resultlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:resultlabel];
//    if (IS_IPHONE_5) {
//        sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(resultlabel.frame)+15, MSWidth - 10, 100)];
//    }else if (IS_IPHONE_6){
//        sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(resultlabel.frame)+2, MSWidth - 10, 100)];
//    }
//    else{
        sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(resultlabel.frame)+15, MSWidth - 10, 100)];
//    }
    sheetView.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
    [self.view addSubview:sheetView];
    for (NSInteger i = 0; i<3; i++) {
        //下面的表格 六条横线
        [self drawLine:CGPointMake(sheetView.frame.origin.x+3, 5+((sheetView.frame.size.height-10)/2)*i) WithEndPoint:CGPointMake(sheetView.frame.size.width-6,5+((sheetView.frame.size.height-10)/2)*i) lineWidth:2 withView:sheetView];
    }
    //下面的表格 三条竖线
    for (NSInteger i = 0; i<3; i++) {
        [self drawLine:CGPointMake(sheetView.frame.origin.x+3 +((sheetView.frame.size.width-14)/2)*i, 5) WithEndPoint:CGPointMake(sheetView.frame.origin.x+3 +((sheetView.frame.size.width-14)/2)*i,sheetView.frame.size.height-3) lineWidth:2 withView:sheetView];
    }
    //下面的表格 里面的显示
    for (NSInteger i = 0; i<2; i++) {
        //左边的label
        UILabel *leftlable  = [[UILabel alloc]initWithFrame:CGRectMake(6, ((sheetView.frame.size.height-15)/2+2)*i + 2, (sheetView.frame.size.width-18)/2, (sheetView.frame.size.height-15)/2)];
        leftlable.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        leftlable.text = self.titileDataSource[i];
        leftlable.font = [UIFont systemFontOfSize:14.f];
        leftlable.textAlignment = NSTextAlignmentCenter;
        [sheetView addSubview:leftlable];
        //右边的label
        UILabel *rightlable  = [[UILabel alloc]initWithFrame:CGRectMake((sheetView.frame.size.width-18)/2 +8, ((sheetView.frame.size.height-15)/2+2)*i + 2, (sheetView.frame.size.width-18)/2, (sheetView.frame.size.height-15)/2)];
        rightlable.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        rightlable.text = @"-.-- sec";
        rightlable.font = [UIFont systemFontOfSize:14.f];
        rightlable.textAlignment = NSTextAlignmentCenter;
        [sheetView addSubview:rightlable];
    }
}
- (void)initWithMPHUI{
    if (IS_IPHONE_5) {
        sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbLabel.frame)+5, MSWidth - 10, 170)];
    }else if (IS_IPHONE_6){
        sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbLabel.frame)+2, MSWidth - 10, 230)];
    }
    else{
        sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbLabel.frame)+2, MSWidth - 10, 300)];
    }
    sheetView.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
    [self.view addSubview:sheetView];
    for (NSInteger i = 0; i<6; i++) {
        //下面的表格 六条横线
        [self drawLine:CGPointMake(sheetView.frame.origin.x+3, 5+((sheetView.frame.size.height-10)/5)*i) WithEndPoint:CGPointMake(sheetView.frame.size.width-6,5+((sheetView.frame.size.height-10)/5)*i) lineWidth:2 withView:sheetView];
    }
    //下面的表格 三条竖线
    for (NSInteger i = 0; i<3; i++) {
        [self drawLine:CGPointMake(sheetView.frame.origin.x+3 +((sheetView.frame.size.width-14)/2)*i, 5) WithEndPoint:CGPointMake(sheetView.frame.origin.x+3 +((sheetView.frame.size.width-14)/2)*i,sheetView.frame.size.height-3) lineWidth:2 withView:sheetView];
    }
    //下面的表格 里面的显示
    for (NSInteger i = 0; i<5; i++) {
        //左边的label
        UILabel *leftlable  = [[UILabel alloc]initWithFrame:CGRectMake(6, ((sheetView.frame.size.height-15)/5+2)*i + 2, (sheetView.frame.size.width-18)/2, (sheetView.frame.size.height-15)/5)];
        leftlable.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        leftlable.text = self.titileDataSource[i];
        leftlable.font = [UIFont systemFontOfSize:14.f];
        leftlable.textAlignment = NSTextAlignmentCenter;
        [sheetView addSubview:leftlable];
        //右边的label
        UILabel *rightlable  = [[UILabel alloc]initWithFrame:CGRectMake((sheetView.frame.size.width-18)/2 +8, ((sheetView.frame.size.height-15)/5+2)*i + 2, (sheetView.frame.size.width-18)/2, (sheetView.frame.size.height-15)/5)];
        rightlable.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        rightlable.text = @"-.-- sec";
        rightlable.font = [UIFont systemFontOfSize:14.f];
        rightlable.textAlignment = NSTextAlignmentCenter;
        [sheetView addSubview:rightlable];
    }
    
    
}
@end
