//
//  bluetoothView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "bluetoothView.h"
@interface bluetoothView()<UITableViewDataSource,UITableViewDelegate>
{
    RLBtn *btn;
}
@end
@implementation bluetoothView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        btn = [[RLBtn alloc]initWithFrame:CGRectMake(MSWidth- 110, 0, 90, 44)];
        [btn setTitle:@"Rescan" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"矢量智能对象"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reconnectionBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.alpha = 1;
        [self addSubview:btn];
   
        self.backgroundColor = [ColorTools colorWithHexString:@"#1A1B1E"];
        self.alpha = 0.9;
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), self.bounds.size.width, self.bounds.size.height - 8)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.scrollEnabled = NO;
        tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
        [self addSubview:tableView];
    }
    return self;
}
- (void)reconnectionBtn{
    DLog(@"重链接1");
    if ([self.delegate respondsToSelector:@selector(reconnectionBlueTooth)]) {
        [self.delegate reconnectionBlueTooth];
    }
}
-(void)setNeedsLayout{
    [super setNeedsLayout];
    self.frame = CGRectMake(0, 64, MSWidth, 140);
    btn.frame = CGRectMake(MSWidth- 110, 0, 90, 44);

}
- (void)show{
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    //        UIView *topView = [win.subviews firstObject];
    //        [topView addSubview:self];
    [win addSubview:self];
    
    [win bringSubviewToFront:self];
    
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        
        [weakSelf layoutIfNeeded];
    }];
    
}
- (void)hide{
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
    DLog(@"---%@",[NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]]);
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
@end
