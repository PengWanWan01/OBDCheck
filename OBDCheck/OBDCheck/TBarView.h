//
//  TBarView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/8.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TBarViewDelegate <NSObject>

@optional
- (void)TBarBtnBetouch:(NSInteger )touchSelectNumber;

@end

@interface TBarView : UIView
{
    UIButton *selectBtn;
    NSInteger SelectIndex;
}
@property (nonatomic,assign) NSInteger numberBtn;
@property (nonatomic,strong) NSMutableArray *highimageData;
@property (nonatomic,strong) NSMutableArray *normalimageData;

@property (nonatomic,strong) NSMutableArray *titleData;
@property (nonatomic,weak) id<TBarViewDelegate> delegate;
-(void)initWithData;
@end
