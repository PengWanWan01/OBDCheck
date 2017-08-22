//
//  ILColorPicker.m
//  ILColorPickerExample
//
//  Created by Jon Gilkison on 9/2/11.
//  Copyright 2011 Interfacelab LLC. All rights reserved.
//

#import "ILColorPickerView.h"


@implementation ILColorPickerView

@synthesize delegate,pickerLayout, color;



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque=NO;
        self.backgroundColor=[UIColor clearColor];
        
        huePicker=[[ILHuePickerView alloc]init];
        [self addSubview:huePicker];
        
        self.pickerLayout=ILColorPickerViewLayoutBottom;
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
        topView.backgroundColor = [UIColor whiteColor];
//        topView.alpha = 0.5f;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 100, 20, 100, 30)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"Done" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor redColor];
        [topView addSubview:btn];
        [self addSubview:topView];

    }
    return self;
}
- (void)btn{
    [self hide];
}
#pragma mark - Property Set/Get

-(void)setPickerLayout:(ILColorPickerViewLayout)layout
{
    huePicker.pickerOrientation=ILHuePickerViewOrientationHorizontal;
    [huePicker setFrame:CGRectMake(0, self.frame.size.height -120, self.frame.size.width, 120)];
    satPicker=[[ILSaturationBrightnessPickerView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height-120-64)];
    satPicker.delegate=self;
    huePicker.delegate=satPicker;
    [self addSubview:satPicker];
    [self addSubview:huePicker];

}

-(UIColor *)color
{
    return satPicker.color;
}

-(void)setColor:(UIColor *)c
{
    satPicker.color=c;
    huePicker.color=c;
}

#pragma mark - ILSaturationBrightnessPickerDelegate

-(void)colorPicked:(UIColor *)newColor forPicker:(ILSaturationBrightnessPickerView *)picker
{
    [delegate colorPicked:newColor forPicker:self];
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
@end
