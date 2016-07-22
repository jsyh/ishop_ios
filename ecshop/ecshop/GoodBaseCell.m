//
//  GoodBaseCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/28.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "GoodBaseCell.h"

@implementation GoodBaseCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self creatBaseview];
    }
    return self;
}
-(void)creatBaseview
{
    _baseLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width/3-10, 20)];
    _baseLab.textColor=[UIColor lightGrayColor];
    _baseLab.font=[UIFont systemFontOfSize:13];
    _baseLab.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_baseLab];
    _baseImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 0, 1, 30)];
    _baseImage.backgroundColor=[UIColor darkGrayColor];
    //_baseImage.image=[UIImage imageNamed:@"login_off_bg.9.png"];
    [self.contentView addSubview:_baseImage];
    _valueLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3+10, 5, (2*self.frame.size.width/3)-10, 20)];
    _valueLab.font=[UIFont systemFontOfSize:13];
    _valueLab.textColor=[UIColor lightGrayColor];
    _valueLab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_valueLab];
}
@end
