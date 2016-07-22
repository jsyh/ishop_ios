//
//  SureTableViewCell.m
//  ecshop
//
//  Created by jsyh-mac on 16/1/12.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SureTableViewCell.h"

@implementation SureTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubvi];
    }
    return self;
}
-(void)createSubvi
{
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    [self.contentView addSubview:_iconImage];
    _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, self.contentView.frame.size.width-80, 30)];
    _nameLab.font=[UIFont systemFontOfSize:15];
    _nameLab.textColor=[UIColor blackColor];
    _nameLab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    _signname=[[UILabel alloc]initWithFrame:CGRectMake(80, 45, 10, 15)];
    _signname.text=@"￥";
    _signname.textColor=[UIColor redColor];
    _signname.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_signname];
    _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(92, 45, 70, 15)];
    _priceLab.textColor=[UIColor redColor];
    _priceLab.textAlignment=NSTextAlignmentLeft;
    _priceLab.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLab];
    _shuliang=[[UILabel alloc]initWithFrame:CGRectMake(170, 45, 30, 15)];
    _shuliang.textAlignment=NSTextAlignmentLeft;
    _shuliang.text=@"数量:";
    _shuliang.font=[UIFont systemFontOfSize:13];
    _shuliang.textColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_shuliang];
    _NumLab=[[UILabel alloc]initWithFrame:CGRectMake(200, 45, 30, 15)];
    _NumLab.textColor=[UIColor lightGrayColor];
    _NumLab.textAlignment=NSTextAlignmentLeft;
    _NumLab.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_NumLab];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
