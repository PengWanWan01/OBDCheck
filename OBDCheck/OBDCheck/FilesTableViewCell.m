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
        _deleteBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame=CGRectMake(-40, 0, 40, 44);
        _deleteBtn.userInteractionEnabled = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.font=[UIFont systemFontOfSize:17];
        _nameLabel.textColor= [ColorTools colorWithHexString:@"C8C6C6"];
        _nameLabel.frame=CGRectMake(15, 0, 200, 44);
        [self.contentView addSubview:_nameLabel];
        
        _detailLabel=[[UILabel alloc]init];
        _detailLabel.font=[UIFont systemFontOfSize:17];
        _detailLabel.textColor= [ColorTools colorWithHexString:@"FE9002"];
        _detailLabel.frame=CGRectMake(MSWidth - 110, 0, 80, 44);
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
        
        _accView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_detailLabel.frame)+10 , 15.5, 8, 13)];
        _accView.image = [UIImage imageNamed:@"enter"];
        [self.contentView addSubview:_accView];

        [self initView];
    }
    return self;
}
-(void)setNeedsDisplay{
  [self initView];
}
-(void)initView
{
  
       switch (self.editstatus) {
        case EditstatusType1:
        {
            _deleteBtn.frame=CGRectMake(-40, 0, 40, 44);
            _nameLabel.frame=CGRectMake(15, 0, 200, 44);
        }
            break;
        case EditstatusType2:
        {
            _deleteBtn.frame=CGRectMake(10, 0, 55, 44);
            _nameLabel.frame=CGRectMake(15+40+10, 0, 200, 44);
        }
            break;
        default:
            break;
    }
    
}

- (void)test:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deletewithRow:)]) {
        [self.delegate deletewithRow:btn.tag];
        
    }
}
@end
