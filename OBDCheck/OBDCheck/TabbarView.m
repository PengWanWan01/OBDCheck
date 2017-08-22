//
//  TabbarView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/22.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "TabbarView.h"

@implementation TabbarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSoureNormal = [[NSMutableArray alloc]initWithObjects:@"obd_normal",@"special_normal",@"personal_normal", nil];
        _dataSoureSelect = [[NSMutableArray alloc]initWithObjects:@"obd_highlight",@"special_highlight",@"personal_highlight", nil];

        for (NSInteger i = 0; i<3; i++) {
//            NSInteger index = i/2;
            
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*(MSWidth/3), 0, MSWidth/3, 59)];
//            imageView.image = [UIImage imageNamed:_dataSoureNormal[i]];
//            
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            imageView.tag = i;
//   [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(MSWidth/3), 0, MSWidth/3, 59)];
//           btn.imageView.image = [UIImage imageNamed:_dataSoureNormal[i]];
           
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:_dataSoureNormal[i]] forState:UIControlStateNormal];
//
////            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
//            [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}
- (void)btn:(UIButton *)btn{


}
@end
