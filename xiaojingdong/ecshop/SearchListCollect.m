//
//  SearchListCollect.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "SearchListCollect.h"

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
    self.backgroundColor = [UIColor whiteColor];
    float width = [UIScreen mainScreen].bounds.size.width;
    float imgViewFloatW = 326.0/750.0;
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, imgViewFloatW*width, imgViewFloatW*width)];
    [self.contentView addSubview:_iconImage];
    _nameLab= [[UILabel alloc]initWithFrame: CGRectMake(12, _iconImage.frame.size.height+_iconImage.frame.origin.y+12, self.frame.size.width-24, 35)];
    _nameLab.numberOfLines = 2;
    
    _nameLab.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLab];
    _moneySign=[[UILabel alloc]initWithFrame:CGRectMake(12, _nameLab.frame.size.height+_nameLab.frame.origin.y+5, 10, 12)];
    _moneySign.textColor=[UIColor redColor];
    _moneySign.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_moneySign];
    _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(22, _moneySign.frame.origin.y, 80, 12)];
    _priceLab.textColor=[UIColor redColor];
    _priceLab.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_priceLab];
 
    
}
@end
