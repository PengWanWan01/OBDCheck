
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
    UIView *sheetBackView;
}
@end

@implementation PerformanceController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Performance" andLeftItemImageName:@"back" andRightItemName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}
- (void)initWithUI{
    
    UIView *hpView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.hpLabel.frame)+5, self.hpLabel.frame.origin.y, MSWidth-20-self.hpLabel.frame.origin.x- self.hpLabel.frame.size.width , self.hpLabel.frame.size.height)];
    hpView.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
    [self.view addSubview:hpView];
    
    UIView *lbView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lpLabel.frame)+5, self.lpLabel.frame.origin.y, MSWidth-20-self.lpLabel.frame.origin.x- self.lpLabel.frame.size.width , self.lpLabel.frame.size.height)];
    lbView.backgroundColor = [ColorTools colorWithHexString:@"18181C"];
    [self.view addSubview:lbView];
    
    hpFillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, hpView.frame.size.height)];
    hpFillView.backgroundColor= [ColorTools colorWithHexString:@"FF000F"];
    [hpView addSubview:hpFillView];
    
    lbFillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, lbView.frame.size.height)];
    lbFillView.backgroundColor= [ColorTools colorWithHexString:@"0E09ED"];
    [lbView addSubview:lbFillView];

//画hp右边的线
    [self drawLine:CGPointMake(CGRectGetMaxX(self.hpLabel.frame)+10, self.hpLabel.frame.origin.y+self.hpLabel.frame.size.height) WithEndPoint:CGPointMake(hpView.frame.origin.x+hpView.frame.size.width-5, self.hpLabel.frame.origin.y+self.hpLabel.frame.size.height) lineWidth:1.f];
//画lb右边的线
   [self drawLine:CGPointMake(CGRectGetMaxX(self.lpLabel.frame)+10, self.lpLabel.frame.origin.y+self.lpLabel.frame.size.height) WithEndPoint:CGPointMake(lbView.frame.origin.x+lbView.frame.size.width-5, self.lpLabel.frame.origin.y+self.lpLabel.frame.size.height) lineWidth:1.f];
    
    for (NSInteger i = 0; i<6; i++) {
        NSLog(@"12");
       [self drawLine:CGPointMake((CGRectGetMaxX(self.hpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, self.hpLabel.frame.origin.y+self.hpLabel.frame.size.height) WithEndPoint:CGPointMake((CGRectGetMaxX(self.hpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, self.hpLabel.frame.origin.y+self.hpLabel.frame.size.height-5) lineWidth:1.f];
        
        [self drawLine:CGPointMake((CGRectGetMaxX(self.lpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, self.lpLabel.frame.origin.y+self.lpLabel.frame.size.height) WithEndPoint:CGPointMake((CGRectGetMaxX(self.lpLabel.frame)+10)+((hpView.frame.size.width-10)/5)*i, self.lpLabel.frame.origin.y+self.lpLabel.frame.size.height-5)lineWidth:1.f];
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
     [self drawLine:CGPointMake(self.sheetView.frame.origin.x-3, self.sheetView.frame.origin.y+5+((self.sheetView.frame.size.height-10)/5)*i) WithEndPoint:CGPointMake(self.sheetView.frame.size.width-6,self.sheetView.frame.origin.y+5+((self.sheetView.frame.size.height-10)/5)*i) lineWidth:2];
  
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
@end
