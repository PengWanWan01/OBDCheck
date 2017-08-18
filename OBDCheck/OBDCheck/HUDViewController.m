//
//  HUDViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/18.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "HUDViewController.h"

@interface HUDViewController ()

@end

@implementation HUDViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
//    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
//        
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        
//        [invocation setSelector:selector];
//        
//        [invocation setTarget:[UIDevice currentDevice]];
//        
//        int val = UIInterfaceOrientationLandscapeRight;//横屏
//        
//        [invocation setArgument:&val atIndex:2];
//        
//        [invocation invoke];
//        
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}
- (void)initWithUI{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(MSWidth/2 - 1, 0, 1, MSHeight)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    for (NSInteger i = 0; i< 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (i +1) * (MSHeight/3), MSWidth, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:lineView];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MSWidth/2 - 1, (MSHeight - 2)/3 )];
    imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:imageView];
    for (NSInteger i = 1; i< 6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        HUDView *View  = [[HUDView alloc]initWithFrame:CGRectMake(index * ((MSWidth/2)-1 ), page  * ( (MSWidth-2)/3), MSWidth/2, MSWidth/3 - 2)];
        [self.view addSubview:View];
       }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
