//
//  SearchListCollect.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "SearchListCollect.h"
#import "Masonry.h"
@implementation SearchListCollect
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview
{
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [self.contentView addSubview:_iconImage];
    _nameLab= [[UILabel alloc]initWithFrame: CGRectMake(0, self.frame.size.width+5, self.frame.size.width, 15)];
    _nameLab.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLab];
    _moneySign=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.width+25, 10, 12)];
    _moneySign.textColor=[UIColor redColor];
    _moneySign.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_moneySign];
    _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(10, self.frame.size.width+25, 80, 12)];
    _priceLab.textColor=[UIColor redColor];
    _priceLab.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_priceLab];
    //定义偏移量
//    int padding1=0;
//    int padding2=1;
//    int padding3=5;
//    int padding4=7;
//   // 适配
//    if (_item1==0) {
//    [self.contentView addSubview:_iconImage];
//    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, -40, 0));
//    }];
//    _nameLab.font=[UIFont systemFontOfSize:12];
//    _nameLab.textAlignment=NSTextAlignmentLeft;
//    _nameLab.textColor=[UIColor blackColor];
//    [self.contentView addSubview:_nameLab];
//    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).with.offset(padding1);
//        make.right.equalTo(self.contentView.mas_right).with.offset(padding1);
//        make.height.mas_equalTo(@15);
//        make.width.equalTo(self.contentView);
//        make.top.equalTo(_iconImage.mas_bottom).with.offset(padding3);
//    }];
//    _moneySign.textColor=[UIColor redColor];
//    _moneySign.textAlignment=NSTextAlignmentLeft;
//    [self.contentView addSubview:_moneySign];
//    [_moneySign mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).with.offset(padding1);
//        make.height.mas_equalTo(@10);
//        make.width.mas_equalTo(@3);
//        make.top.equalTo(_nameLab.mas_bottom).with.offset(padding3);
//    }];
//    _priceLab.textColor=[UIColor redColor];
//    _priceLab.textAlignment=NSTextAlignmentLeft;
//    [self.contentView addSubview:_priceLab];
//    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_moneySign.mas_centerY);
//        make.left.equalTo(_moneySign.mas_right).with.offset(padding2);
//        make.height.mas_equalTo(@10);
//        make.width.mas_equalTo(@50);
//    }];
    
    
    
    
    //}
    //列表状态变化之后
//    else if (_item1==1)
//    {
//        [self.contentView addSubview:_iconImage];
//        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).with.offset(padding3);
//            make.height.mas_equalTo(@70);
//            make.width.mas_equalTo(@70);
//            make.top.equalTo(self.contentView.mas_bottom).with.offset(padding3);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-padding3);
//        }];
//        _nameLab.font=[UIFont systemFontOfSize:10];
//        _nameLab.textAlignment=NSTextAlignmentLeft;
//        _nameLab.textColor=[UIColor blackColor];
//        [self.contentView addSubview:_nameLab];
//        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconImage.mas_right).with.offset(padding4);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-padding4);
//            make.height.mas_equalTo(@15);
//            make.top.equalTo(self.contentView.mas_top).with.offset(padding3);
//        }];
//        _moneySign.font=[UIFont systemFontOfSize:10];
//        _moneySign.textColor=[UIColor redColor];
//        _moneySign.textAlignment=NSTextAlignmentLeft;
//        [self.contentView addSubview:_moneySign];
//        [_moneySign mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconImage.mas_right).with.offset(padding4);
//            make.height.mas_equalTo(@15);
//            make.top.equalTo(_nameLab.mas_bottom).with.offset(padding4);
//        }];
//        _priceLab.textColor=[UIColor redColor];
//        _priceLab.textAlignment=NSTextAlignmentLeft;
//        [self.contentView addSubview:_priceLab];
//        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_moneySign.mas_centerY);
//            make.left.equalTo(_moneySign.mas_right).with.offset(padding2);
//            make.height.mas_equalTo(@15);
//            make.width.mas_equalTo(@50);
//        }];
//        [self.contentView addSubview:_saleImage];
//        [_saleImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_moneySign.mas_centerY);
//            make.left.equalTo(_priceLab.mas_right).with.offset(padding2);
//            make.height.mas_equalTo(@15);
//            make.width.mas_equalTo(@50);
//        }];
//        _haoPinLab.textColor=[UIColor lightGrayColor];
//        _haoPinLab.textAlignment=NSTextAlignmentLeft;
//        _haoPinLab.font=[UIFont systemFontOfSize:10];
//        [self.contentView addSubview:_haoPinLab];
//        [_haoPinLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconImage.mas_right).with.offset(padding4);
//            make.height.mas_equalTo(@15);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-padding3);
//        }];
//        [self.contentView addSubview:_num1Lab];
//        [_num1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_haoPinLab.mas_centerY);
//            make.left.equalTo(_haoPinLab.mas_right).with.offset(padding2);
//            make.height.mas_equalTo(@15);
//            make.width.mas_equalTo(@5);
//        }];
//        [self.contentView addSubview:_perSian];
//        [_perSian mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_num1Lab.mas_centerY);
//            make.left.equalTo(_num1Lab.mas_right).with.offset(padding1);
//            make.height.mas_equalTo(@15);
//            make.width.mas_equalTo(@2);
//        }];
//        _num2Lab.textAlignment=NSTextAlignmentRight;
//        [self.contentView addSubview:_num2Lab];
//        [_num2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_num2Lab.mas_centerY);
//            make.left.equalTo(_perSian.mas_right).with.offset(padding1);
//            make.height.mas_equalTo(@15);
//            make.width.mas_equalTo(@10);
//        }];
//        _renLab.textAlignment=NSTextAlignmentLeft;
//        [self.contentView addSubview:_renLab];
//        [_renLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_num2Lab.mas_centerY);
//            make.left.equalTo(_renLab.mas_right).with.offset(padding2);
//            make.height.mas_equalTo(@15);
//            make.width.mas_equalTo(@3);
//        }];
//    }
    
}
@end
