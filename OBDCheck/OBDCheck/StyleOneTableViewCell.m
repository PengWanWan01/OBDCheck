//
//  StyleOneTableViewCell.m
//  
//
//  Created by yutaozhao on 2017/8/21.
//
//

#import "StyleOneTableViewCell.h"

@implementation StyleOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 为UISlider添加事件方法
    [self.NumberSider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    


}
- (void)sliderValueChanged:(id)sender {
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider * slider = (UISlider *)sender;
        self.NumberLabel.text = [NSString stringWithFormat:@"%.f",slider.value];
        if ([self.delegate respondsToSelector:@selector(sliderBeTouch:)]) {
            [self.delegate sliderBeTouch:slider];
        }
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
