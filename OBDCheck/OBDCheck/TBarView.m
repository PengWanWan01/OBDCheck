//
//  TBarView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/8.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "TBarView.h"

@implementation TBarView

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
       
            }
    return self;
}
-(void)initWithData{
//  NSLog(@"numberBtn%ld",(long)self.numberBtn);
    for (int i = 0; i<self.numberBtn; i++) {
//        NSLog(@"numberBtn%ld",(long)self.numberBtn);
        JXButton *btn = [[JXButton alloc]initWithFrame:CGRectMake(i*(MSWidth/self.numberBtn), 0,MSWidth/self.numberBtn , ViewHeight)];
        [btn setTitle:@"12" forState:UIControlStateNormal];
        [btn setTitle:_titleData[i] forState:UIControlStateNormal];
        [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_normalimageData[i]] forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (i == self.isSelectNumber) {
            [btn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_highimageData[i]] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
    }
  
}
- (void)btn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(TBarBtnBetouch:)]) {
        [self.delegate TBarBtnBetouch:btn.tag];
    }

}

@end
