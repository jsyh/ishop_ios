//
//  GoodBaseCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/28.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "GoodBaseCell.h"
#import "UIColor+Hex.h"
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
    float width = [UIScreen mainScreen].bounds.size.width;
    _baseLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 113, 15)];
    _baseLab.textColor=[UIColor colorWithHexString:@"#666666"];
    _baseLab.font=[UIFont systemFontOfSize:15];
    _baseLab.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_baseLab];
//    _baseImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 0, 1, 30)];
//    _baseImage.backgroundColor=[UIColor darkGrayColor];
//    //_baseImage.image=[UIImage imageNamed:@"login_off_bg.9.png"];
//    [self.contentView addSubview:_baseImage];
    _valueLab=[[UILabel alloc]initWithFrame:CGRectMake(125 , 12,width , 15)];
    _valueLab.font=[UIFont systemFontOfSize:15];
    _valueLab.textColor=[UIColor colorWithHexString:@"#43464c"];
    _valueLab.textAlignment=NSTextAlignmentLeft;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_valueLab];
}
@end
