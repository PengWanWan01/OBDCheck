//
//  StyleOneTableViewCell.h
//  
//
//  Created by yutaozhao on 2017/8/21.
//
//

#import <UIKit/UIKit.h>

@protocol sliderBeTouchDelegate <NSObject>

- (void)sliderBeTouch:(UISlider *)Slider;

@end
@interface StyleOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *NumberLabel;
@property (weak, nonatomic) IBOutlet UISlider *NumberSider;
@property (nonatomic,weak) id<sliderBeTouchDelegate> delegate;
@property (nonatomic,assign) NSInteger  dashboardType ;

@end
