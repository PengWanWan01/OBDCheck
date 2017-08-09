//
//  editDashboardsView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "editDashboardsView.h"
@interface editDashboardsView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *titileArray;
@end
@implementation editDashboardsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 8)];
        view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 32, 0, 16, 8)];
        imageView.image = [UIImage imageNamed:@"triangle"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:view];
        [view addSubview:imageView];
        _titileArray = [[NSMutableArray alloc]initWithObjects:@"Edit Dashboards",@"Dashboards Style",@"Add Display",@"Add Dashboard",@"Remove Dashboard",@"Load Default Dashboards",@"Toggle HUD Mode",@"Calibrate Device Sensors", nil];
        
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titileArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60.f;
    }else{
        return 44.f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
       
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  _titileArray[indexPath.row];
     cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#FE9002"]];
        cell.textLabel.font = [UIFont systemFontOfSize:18.f];
    }else if (indexPath.row == 1){
        [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 60, 0, 50, 44)];
//        selectBtn.backgroundColor = [UIColor redColor];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#FE9002"] forState:UIControlStateNormal];
        [selectBtn setTitle:@"One" forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:selectBtn];
    }
    else{
    [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
    }
    return cell;

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
- (void)selectBtn{
    if ([self.delegate respondsToSelector:@selector(selectStyleBtnBetouched:)]) {
        [self.delegate selectStyleBtnBetouched:self];
    }
}
@end
