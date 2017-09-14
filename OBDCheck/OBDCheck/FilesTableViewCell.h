//
//  FilesTableViewCell.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/14.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,Editstatus)
{
    EditstatusType1=0,   // 没有被编辑
    EditstatusType2    //被编辑
};
@protocol deleteFileDelegate <NSObject>

- (void)deletewithRow:(NSInteger)index;

@end
@interface FilesTableViewCell : UITableViewCell


@property (nonatomic,strong)  UIButton *deleteBtn;
@property (nonatomic,strong)  UILabel *nameLabel;
@property (nonatomic,strong)  UILabel *detailLabel;
@property (nonatomic,strong)  UIImageView *accView;
@property (nonatomic,assign) NSInteger editstatus;
@property (nonatomic,weak) id<deleteFileDelegate> delegate;
@end
