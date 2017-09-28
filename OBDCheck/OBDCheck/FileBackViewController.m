//
//  FileBackViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/28.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FileBackViewController.h"

@interface FileBackViewController ()

@end

@implementation FileBackViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initNavBarTitle:@"Files" andLeftItemImageName:@"back" andRightItemName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
