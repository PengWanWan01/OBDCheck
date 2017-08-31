//
//  SpecialViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SpecialViewController.h"

@interface SpecialViewController ()
@property (nonatomic,strong) NSMutableArray *normalImage;
@property (nonatomic,strong) NSMutableArray *selectImage;
@end

@implementation SpecialViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Special" andLeftItemImageName:@" " andRightItemName:@""];
   
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithData];
    [self initWithUI];
    
}
- (void)initWithData{
    self.normalImage = [[NSMutableArray alloc]initWithObjects:@"obd_normal",@"special_normal",@"personal_normal", nil];
    self.selectImage = [[NSMutableArray alloc]initWithObjects:@"obd_highlight",@"special_highlight",@"personal_highlight", nil];
    
}
- (void)initWithUI{
    
    for (NSInteger i = 0; i< 3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(MSWidth/3), MSHeight - 45*KHeightmultiple-64,MSWidth/3 , 45*KHeightmultiple)];
        [btn setBackgroundImage: [UIImage imageNamed:_normalImage[i]] forState:UIControlStateNormal];
        btn.tag = i;
         [btn setContentMode:UIViewContentModeScaleAspectFit];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
       
        if (i==1) {
            [btn setBackgroundImage: [UIImage imageNamed:_selectImage[i]] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(Selectbtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
}

- (void)Selectbtn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            ViewController *vc = [[ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            SpecialViewController *vc = [[SpecialViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            PersonalViewController *vc = [[PersonalViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
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
