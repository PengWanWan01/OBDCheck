//
//  bluetoothView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "bluetoothView.h"
@interface bluetoothView()<UITableViewDataSource,UITableViewDelegate>
@end
@implementation bluetoothView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        RLBtn *btn = [[RLBtn alloc]initWithFrame:CGRectMake(MSWidth- 110, 0, 90, 44)];
        [btn setTitle:@"Rescan" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"矢量智能对象"] forState:UIControlStateNormal];
        btn.alpha = 1;
        [self addSubview:btn];
   
        self.backgroundColor = [ColorTools colorWithHexString:@"#1A1B1E"];
        self.alpha = 0.9;
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, self.bounds.size.width, self.bounds.size.height - 8)];
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
- (void)show{
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    //        UIView *topView = [win.subviews firstObject];
    //        [topView addSubview:self];
    [win addSubview:self];
    
    [win bringSubviewToFront:self];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        
        [self layoutIfNeeded];
    }];
    
}
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
//  /  cell.textLabel.text =  self.dataSource[indexPath.row];
    cell.textLabel.text = @"121";
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
@end
