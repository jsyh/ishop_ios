//
//  SearchListTableCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/16.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "SearchListTableCell.h"

@implementation SearchListTableCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSub];
    }
    return self;
}
-(void)createSub
{
    float width = [UIScreen mainScreen].bounds.size.width;
    //图片坐标
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 90, 90)];
    [self.contentView addSubview:_iconImage];
    //名字
    _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(114,12,width-126,36)];
    _nameLab.numberOfLines=2;
    _nameLab.font=[UIFont systemFontOfSize:14];
    _nameLab.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.contentView addSubview:_nameLab];
    //￥符号
    _moneySign=[[UILabel alloc]initWithFrame:CGRectMake(114, _nameLab.frame.size.height+_nameLab.frame.origin.y+12, 13, 18)];
    _moneySign.font=[UIFont systemFontOfSize:13];
    _moneySign.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_moneySign];
    //价钱
    _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(125, _moneySign.frame.origin.y,100, 18)];
    _priceLab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    //促销图片
//    _saleImage=[[UIImageView alloc]initWithFrame:CGRectMake(210, 57, 40, 24)];
//    [self.contentView addSubview:_saleImage];

    //评论多少条
    _num1Lab=[[UILabel alloc]initWithFrame:CGRectMake(114, 81, 55, 21)];
    _num1Lab.font=[UIFont systemFontOfSize:10];
    _num1Lab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_num1Lab];

    //好评率
    _num2Lab=[[UILabel alloc]initWithFrame:CGRectMake(166, 81, 73, 21)];
    _num2Lab.font=[UIFont systemFontOfSize:10];
    _num2Lab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_num2Lab];

    UIButton *eidtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [eidtBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
    eidtBtn.frame = CGRectMake(-26, 47, 20, 20);

//    [self.contentView addSubview:eidtBtn];

}
- (void)awakeFromNib {
    // Initialization code
}
-(void)dealloc
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
