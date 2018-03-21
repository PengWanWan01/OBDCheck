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
#pragma mark 设置横竖屏布局

-(void)layoutSubviews{
    [super layoutSubviews];
            if (isLandscape) {
            //翻转为横屏时
            DLog(@"横屏");
            [self setHorizontalFrame];
        }else{
            DLog(@"竖屏");
            [self setVerticalFrame];
        }
    }

#pragma mark 竖屏
- (void)setVerticalFrame{
   [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<self.numberBtn; i++) {
        //        DLog(@"numberBtn%ld",(long)self.numberBtn);
        JXButton *btn = [[JXButton alloc]initWithFrame:CGRectMake(i*(SCREEN_MIN/self.numberBtn), 0,SCREEN_MIN/self.numberBtn , ViewHeight)];
        [btn setTitle:@"12" forState:UIControlStateNormal];
        [btn setTitle:_titleData[i] forState:UIControlStateNormal];
        [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_normalimageData[i]] forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        if (i == 0) {
            [btn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_highimageData[btn.tag-100]] forState:UIControlStateNormal];
        }
        [self addSubview:btn];
    }
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<self.numberBtn; i++) {
        //        DLog(@"numberBtn%ld",(long)self.numberBtn);
        JXButton *btn = [[JXButton alloc]initWithFrame:CGRectMake(i*(SCREEN_MAX/self.numberBtn), 0,SCREEN_MAX/self.numberBtn , ViewHeight)];
        [btn setTitle:@"12" forState:UIControlStateNormal];
        [btn setTitle:_titleData[i] forState:UIControlStateNormal];
        [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_normalimageData[i]] forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        if (i == 0) {
            [btn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_highimageData[btn.tag-100]] forState:UIControlStateNormal];
        }
        [self addSubview:btn];
    }
}
-(void)initWithData{
//  DLog(@"numberBtn%ld",(long)self.numberBtn);
   
  
}
- (void)btn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(TBarBtnBetouch:)]) {
        [self.delegate TBarBtnBetouch:btn.tag];
    }
        //上次点击过的按钮，不做处理
    if (!(btn.tag == 100)) {
        UIButton *btn = (UIButton *)[self viewWithTag:100];
        [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_normalimageData[btn.tag-100]] forState:UIControlStateNormal];
    }
        if(selectBtn == btn ) {
            SelectIndex = selectBtn.tag - 99;
        } else{
            //本次点击的按钮设为黑色
            [btn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_highimageData[btn.tag-100]] forState:UIControlStateNormal];
            SelectIndex = btn.tag - 99;
            //将上次点击过的按钮设为白色
            [selectBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
            if (!(selectBtn == nil)) {
            [selectBtn setImage:[UIImage imageNamed:_normalimageData[selectBtn.tag-100]] forState:UIControlStateNormal];
            }
        }
    selectBtn= btn;
  

}

@end
