//
//  rotationView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/30.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rotationView : UIView

@property (nonatomic)  UILabel *numberLabel;
@property (nonatomic)  UIImageView *rotationImage;

- (void)rotate360WithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount ;
@end
