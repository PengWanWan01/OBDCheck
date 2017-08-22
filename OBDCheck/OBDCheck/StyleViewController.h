//
//  StyleViewController.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,SelectStyleElement )
{
    SelectFrame=0,   //Frame
    SelectAxis,         //Axis
    SelectNeedle,       //Needle
    SelectRange     //Range
    
};

@interface StyleViewController : UIViewController
@property (nonatomic,assign) SelectStyleElement selectStyleElement;
@end
