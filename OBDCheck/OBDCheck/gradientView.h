//
//  gradientView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gradientView : UIView
@property (nonatomic,strong) UIColor *startGradientColor;
@property (nonatomic,strong) UIColor *endGradientColor;
@property (nonatomic,assign) CGFloat  gradientRadius;

@end
