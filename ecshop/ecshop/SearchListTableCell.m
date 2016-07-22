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
    //图片坐标
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 90, 90)];
    [self.contentView addSubview:_iconImage];
    //名字
    _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(114,12,self.viewForFirstBaselineLayout.frame.size.width-126,36)];
    _nameLab.numberOfLines=2;
    _nameLab.font=[UIFont systemFontOfSize:14];
    _nameLab.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.contentView addSubview:_nameLab];
    //￥符号
    _moneySign=[[UILabel alloc]initWithFrame:CGRectMake(114, 63, 13, 14)];
    _moneySign.font=[UIFont systemFontOfSize:13];
    _moneySign.textAlignment=NSTextAlignmentLeft;
    _moneySign.textColor=[UIColor redColor];
    [self.contentView addSubview:_moneySign];
    //价钱
    _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(125, 60,100, 18)];
    _priceLab.font=[UIFont systemFontOfSize:18];
    _priceLab.textColor=[UIColor redColor];
    _priceLab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    //促销图片
    _saleImage=[[UIImageView alloc]initWithFrame:CGRectMake(210, 57, 40, 24)];
    [self.contentView addSubview:_saleImage];
   //好评
//    _haoPinLab=[[UILabel alloc]initWithFrame:CGRectMake(tableHeight+10, tableHeight/2+45, 30, 15)];
//    _haoPinLab.font=[UIFont systemFontOfSize:15];
//    _haoPinLab.textColor=[UIColor lightGrayColor];
//    [self.contentView addSubview:_haoPinLab];
    //haopinglv
    _num1Lab=[[UILabel alloc]initWithFrame:CGRectMake(114, 81, 55, 21)];
    _num1Lab.font=[UIFont systemFontOfSize:10];
    _num1Lab.textAlignment=NSTextAlignmentLeft;
    _num1Lab.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.contentView addSubview:_num1Lab];
    //率
//    _perSian=[[UILabel alloc]initWithFrame:CGRectMake(tableHeight+55, tableHeight/2+45, 12, 15)];
//    _perSian.font=[UIFont systemFontOfSize:15];
//    _perSian.textColor=[UIColor lightGrayColor];
//    [self.contentView addSubview:_perSian];
    //购买的人数
    _num2Lab=[[UILabel alloc]initWithFrame:CGRectMake(166, 81, 73, 21)];
    _num2Lab.font=[UIFont systemFontOfSize:10];
    _num2Lab.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _num2Lab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_num2Lab];
    //人
//    _renLab=[[UILabel alloc]initWithFrame:CGRectMake(tableHeight+91, tableHeight/2+45, 15, 15)];
//    _renLab.font=[UIFont systemFontOfSize:15];
//    _renLab.textColor=[UIColor lightGrayColor];
//    [self.contentView addSubview:_renLab];   
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
