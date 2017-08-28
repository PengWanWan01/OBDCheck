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
       
        if (self.NumberSider.tag == 0 ||  self.NumberSider.tag == 1  ||  self.NumberSider.tag == 18 ||   self.NumberSider.tag == 19) {
             self.NumberLabel.text = [NSString stringWithFormat:@"%.f",(360/(2*M_PI))*slider.value];
        }else{
             self.NumberLabel.text = [NSString stringWithFormat:@"%.2f",slider.value];
        }
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
