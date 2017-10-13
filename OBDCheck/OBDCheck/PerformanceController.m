
//
//  PerformanceController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/13.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PerformanceController.h"

@interface PerformanceController ()
{
    UIView *hpFillView;
    UIView *lbFillView;
    UIView *sheetView;
    UIImageView *dashimageView;
    UILabel *hpLabel;
    UILabel *lbLabel;

}
@property (nonatomic,strong) NSMutableArray *btntitleDataSource;
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
    [self initWithUI];
}
- (void)initWithUI{
    
    dashimageView = [[UIImageView alloc]initWithFrame:CGRectMake((MSWidth-299)/2, 5, 299, 215)];
    dashimageView.image = [UIImage imageNamed:@"performance_ dash"];
    [self.view addSubview:dashimageView];
    
    hpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dashimageView.frame)+10, 30, 30)];
    lbLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(hpLabel.frame)+20, 30, 30)];
    if (IS_IPHONE_5) {
        sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbLabel.frame)+2, MSWidth - 10, 150)];
    }else{
         sheetView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbLabel.frame)+2, MSWidth - 10, 300)];
    }
    hpLabel.font = [UIFont systemFontOfSize:14.f];
    hpLabel.text = @"hp";
    hpLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    [self.view addSubview:hpLabel];
    lbLabel.font = [UIFont systemFontOfSize:14.f];
    lbLabel.text = @"lb.ft";
    lbLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    [self.view addSubview:lbLabel];
    sheetView.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
    [self.view addSubview:sheetView];
//底部三个按钮
    for (NSInteger i = 0; i<3; i++) {
        NSLog(@"按钮按钮啊");
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+((MSWidth - 20)/3 +3)*i, MSHeight -self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height -50, (MSWidth - 20-6)/3, 40)];
        btn.layer.cornerRadius = 10.f;
        btn.layer.masksToBounds  =YES;
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = [ColorTools colorWithHexString:@"C8C6C6"].CGColor;
        btn.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
        [btn setTitleColor:[ColorTools colorWithHexString:@"3B3F49"] forState:UIControlStateNormal];
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
    [self drawLine:CGPointMake(CGRectGetMaxX(hpLabel.frame)+10, hpLabel.frame.origin.y+hpLabel.frame.size.height) WithEndPoint:CGPointMake(hpView.frame.origin.x+hpView.frame.size.width-5, hpLabel.frame.origin.y+hpLabel.frame.size.height) lineWidth:1.f];
//画lb右边的线
   [self drawLine:CGPointMake(CGRectGetMaxX(lbLabel.frame)+10, lbLabel.frame.origin.y+lbLabel.frame.size.height) WithEndPoint:CGPointMake(lbView.frame.origin.x+lbView.frame.size.width-5, lbLabel.frame.origin.y+lbLabel.frame.size.height) lineWidth:1.f];
    
    for (NSInteger i = 0; i<6; i++) {
       [self drawLine:CGPointMake((CGRectGetMaxX(hpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, hpLabel.frame.origin.y+hpLabel.frame.size.height) WithEndPoint:CGPointMake((CGRectGetMaxX(hpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, hpLabel.frame.origin.y+hpLabel.frame.size.height-5) lineWidth:1.f];
        
        [self drawLine:CGPointMake((CGRectGetMaxX(lbLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, lbLabel.frame.origin.y+lbLabel.frame.size.height) WithEndPoint:CGPointMake((CGRectGetMaxX(lbLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, lbLabel.frame.origin.y+lbLabel.frame.size.height-5)lineWidth:1.f];
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
         //下面的表格
     [self drawLine:CGPointMake(sheetView.frame.origin.x-3, sheetView.frame.origin.y+5+((sheetView.frame.size.height-10)/5)*i) WithEndPoint:CGPointMake(sheetView.frame.size.width-6,sheetView.frame.origin.y+5+((sheetView.frame.size.height-10)/5)*i) lineWidth:2];
  
//        [self drawLine:CGPointMake(self.sheetView.frame.origin.x-3+(self.sheetView.frame.size.width-6)*(i/3), self.sheetView.frame.origin.y+5) WithEndPoint:CGPointMake(self.sheetView.frame.origin.x-3+(self.sheetView.frame.size.width-6)*(i/5),self.sheetView.frame.origin.y+self.sheetView.frame.size.width-10) lineWidth:2];
        
    }
   
    
}
- (void)drawLine:(CGPoint )startPoint WithEndPoint:(CGPoint )endPoint lineWidth:(CGFloat)linewidth{
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
    
    [self.view.layer addSublayer:lineLayer];
}
- (void)btn:(UIButton *)btn{
    
}
@end
