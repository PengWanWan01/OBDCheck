//
//  FilesTableViewCell.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/14.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FilesTableViewCell.h"



@implementation FilesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
    }
    return self;
}
-(void)initView
{
    self.contentView.userInteractionEnabled = YES;

    _deleteBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame=CGRectMake(-18, 13, 18, 18);
    _deleteBtn.userInteractionEnabled = YES;
    [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
     [_deleteBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchDragInside];
      [self.contentView addSubview:_deleteBtn];
    _nameLabel=[[UILabel alloc]init];
    _nameLabel.font=[UIFont systemFontOfSize:17];
    _nameLabel.textColor= [ColorTools colorWithHexString:@"C8C6C6"];
    _nameLabel.frame=CGRectMake(15, 0, 200, 44);
    [self.contentView addSubview:_nameLabel];
    
    _detailLabel=[[UILabel alloc]init];
    _detailLabel=[[UILabel alloc]init];
    _detailLabel.font=[UIFont systemFontOfSize:17];
    _detailLabel.textColor= [ColorTools colorWithHexString:@"FE9002"];
    _detailLabel.frame=CGRectMake(MSWidth - 110, 0, 80, 44);
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_detailLabel];
    
    _accView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_detailLabel.frame)+10 , 15.5, 8, 13)];
    _accView.image = [UIImage imageNamed:@"enter"];
    [self.contentView addSubview:_accView];
    
}
-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
   
    if (self.editing == editing)
    {
        return;
    }
    
    [super setEditing:editing animated:animated];
    //
    CGFloat moveSpace = 15+18-38;//cell的编辑模式会帮你自动移动38 所以我们要继续移动18-38
    if (self.editing)
    {
         NSLog(@"编辑");
        [_deleteBtn setFrame:CGRectMake(_deleteBtn .frame.origin.x + moveSpace,_deleteBtn.frame.origin.y,_deleteBtn.frame.size.width, _deleteBtn.frame.size.height)];
        [_deleteBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchDragInside];
        _deleteBtn.tag = self.tag;
        [_nameLabel setFrame:CGRectMake(_nameLabel.frame.origin.x + moveSpace, _nameLabel.frame.origin.y, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        [_detailLabel setFrame:CGRectMake(_detailLabel.frame.origin.x  -38, _detailLabel.frame.origin.y, _detailLabel.frame.size.width, _detailLabel.frame.size.height)];
        [_accView setFrame:CGRectMake(CGRectGetMaxX(_detailLabel.frame)+10 , 15.5, 8, 13)];
        
    }else
    {
         NSLog(@"quxiao编辑");
        [_deleteBtn setFrame:CGRectMake(_deleteBtn.frame.origin.x - moveSpace, _deleteBtn.frame.origin.y, _deleteBtn.frame.size.width, _deleteBtn.frame.size.height)];
        [_nameLabel setFrame:CGRectMake(_nameLabel.frame.origin.x - moveSpace, _nameLabel.frame.origin.y, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        [_detailLabel setFrame:CGRectMake(_detailLabel.frame.origin.x+38 , _detailLabel.frame.origin.y, _detailLabel.frame.size.width, _detailLabel.frame.size.height)];
         [_accView setFrame:CGRectMake(CGRectGetMaxX(_detailLabel.frame)+10 , 15.5, 8, 13)];
    }
}
- (void)test{
NSLog(@"cescesquxiao编辑");
}
@end
