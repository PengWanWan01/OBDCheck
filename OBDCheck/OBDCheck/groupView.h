//
//  groupView.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/26.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupView : UIView

/**
 自定义描边从左到右,内部由里到外的渐变圆,设置外环宽度

 @param width 外环宽度
 */
- (void)initWithborderwidth:(CGFloat)width;
@end
