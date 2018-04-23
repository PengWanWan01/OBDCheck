//
//  BasicWebViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/23.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "BasicWebViewController.h"

@interface BasicWebViewController ()

@end

@implementation BasicWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLStr]]];
    
    [self.view addSubview:web];
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
