//
//  StyleTwoTableViewCell.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/21.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleTwoTableViewCell.h"
@interface StyleTwoTableViewCell()<ILColorPickerViewDelegate>

@end

@implementation StyleTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ColorView.userInteractionEnabled = YES;
    [self.ColorView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
}
- (void)tap{

    DLog(@"self.ColorView.tag %ld",(long)self.ColorView.tag);
    
    ILColorPickerView *vc = [[ILColorPickerView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight)];
    vc.delegate = self;
    [vc show];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - ILSaturationBrightnessPickerDelegate implementation

-(void)colorPicked:(UIColor *)newColor forPicker:(ILSaturationBrightnessPickerView *)picker
{
   self.ColorView.backgroundColor = newColor;
    self.ColorLabel.text = [ColorTools hexFromUIColor:newColor];
    if (self.colorClick) {
        self.colorClick([ColorTools hexFromUIColor:newColor]);
        
    }
    //颜色改变就会事件代理通知
    if ([self.delegate respondsToSelector:@selector(selectColorBetouched:)]) {
        [self.delegate selectColorBetouched:self.ColorView.tag];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];

}

- (NSString *)hexFromUIColor:(UIColor *)color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}
@end
