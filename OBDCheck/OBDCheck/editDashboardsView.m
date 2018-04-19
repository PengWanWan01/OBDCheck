//
//  editDashboardsView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "editDashboardsView.h"
@interface editDashboardsView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIView *backView ;
}
@property (nonatomic,strong) NSMutableArray *titileArray;
@end
@implementation editDashboardsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backView = [UIView new];
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        backView.frame = win.frame;
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [backView addSubview:self];
//        [backView bringSubviewToFront:self];
        [win addSubview:backView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewBeTouch)];
        tap.delegate = self;
        [backView addGestureRecognizer:tap];
        backView.hidden = YES;
        
        self.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 8)];
        view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 32, 0, 16, 8)];
        imageView.image = [UIImage imageNamed:@"triangle"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:view];
        [view addSubview:imageView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self initWithData];
        });
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
- (void)initWithData{
   
    switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"] ) {
        case DashboardClassicMode:
        {
            
            DLog(@"1212121212");
            _titileArray = [[NSMutableArray alloc]initWithObjects:@"Edit Dashboards",@"Dashboards Mode",@"Dashboards Style",@"Load Default Dashboards",@"Toggle HUD Mode", nil];
        }
            break;
        case DashboardCustomMode:
        {
              DLog(@"7777");
            _titileArray = [[NSMutableArray alloc]initWithObjects:@"Edit Dashboards",@"Dashboards Mode",@"Add Dashboard",@"Load Default Dashboards",@"Toggle HUD Mode",nil];
        }
            break;
        default:
            break;
    }
    DLog(@"数据:%@",_titileArray);
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
-(void)backViewBeTouch{
    [self hide];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
    }else if (indexPath.row == 2 ||  indexPath.row == 1){
        //设置Mode 与Style的内容显示；
        [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 120, 0, 80, 44)];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#FE9002"] forState:UIControlStateNormal];
        
        if (indexPath.row == 1) {
             cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
             [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:selectBtn];
            switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"]) {
                case DashboardClassicMode:{
                    [selectBtn setTitle:@"Classic" forState:UIControlStateNormal];
                }
                    break;
                case DashboardCustomMode:{
                    [selectBtn setTitle:@"Custom" forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
            
        }else  if (indexPath.row == 2 && [[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"] == DashboardClassicMode ) {
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
             [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:selectBtn];
                    switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardStyle"]) {
                        case DashboardStyleOne:{
                            [selectBtn setTitle:@"One" forState:UIControlStateNormal];
                        }
                            break;
                        case DashboardStyleTwo:{
                            [selectBtn setTitle:@"Two" forState:UIControlStateNormal];
                        }
                            break;
                        case DashboardStyleThree:{
                            [selectBtn setTitle:@"Three" forState:UIControlStateNormal];
                        }
                            break;
                        default:
                            break;
                    }
                    
        }
        
        
        //选择Mode 与Style的设置
        selectBtn.tag = indexPath.row;

    }else{
    [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"点击");
        switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"]) {
        case DashboardCustomMode:
        {
            if (indexPath.row==1) {
                if ([self.delegate respondsToSelector:@selector(selectStyleBtnBetouched:)]) {
                    [self.delegate selectStyleBtnBetouched:indexPath.row];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(AlertBetouched:)]) {
                    [self.delegate AlertBetouched:indexPath.row];
                }
            }
            
            }
            break;
        case DashboardClassicMode:
        {
            if (indexPath.row==1 ||indexPath.row==2 ) {
                if ([self.delegate respondsToSelector:@selector(selectStyleBtnBetouched:)]) {
                    [self.delegate selectStyleBtnBetouched:indexPath.row];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(AlertBetouched:)]) {
                    [self.delegate AlertBetouched:indexPath.row];
                }
            }
        }
            break;
        default:
            break;
    }
   [self hide];
}
- (void)show{
    backView.hidden = NO;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{

        [weakSelf layoutIfNeeded];
    }];
    
}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)hide{
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        backView.alpha = 0;
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}
- (void)selectBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectStyleBtnBetouched:)]) {
        [self.delegate selectStyleBtnBetouched:btn.tag];
    }
}
@end
