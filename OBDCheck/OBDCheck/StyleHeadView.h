//
//  StyleHeadView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol switchCommonDelegate <NSObject>
@optional
- (void)switchWithIndex:(NSInteger)index;


@end
@interface StyleHeadView : UIView
{
    UIButton *selectBtn;
}
@property (nonatomic,strong) UIView *DashboardView;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *NumberLabel;
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,weak) id<switchCommonDelegate> delegate;

@end
