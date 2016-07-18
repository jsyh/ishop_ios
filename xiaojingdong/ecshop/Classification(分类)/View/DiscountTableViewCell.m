//
//  DiscountTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/14.
//  Copyright © 2016年 jsyh. All rights reserved.
//折扣和服务

#import "DiscountTableViewCell.h"
#import "UIColor+Hex.h"
@implementation DiscountTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    float afloatX12 = 24.0/750.0;
    float afloatX14 = 35.0/750.0;
    float afloatY18 = 30.0/1334.0;
    float afloatY14 = 35.0/1334.0;
    float afloatW100 = 200.0/750.0;
    float afloatH21 = 42.0/1334.0;
    UILabel *discountLab = [[UILabel alloc]initWithFrame:CGRectMake(afloatX12*width, afloatY18*height, afloatW100*width, afloatH21*height)];
    discountLab.text = @"折扣和服务";
    discountLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    discountLab.textAlignment = NSTextAlignmentLeft;
    discountLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:discountLab];

    //免运费
    float freightW = 100.0/750.0;

    _freightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _freightBtn.frame = CGRectMake(afloatX12*width+5, discountLab.frame.origin.y+discountLab.frame.size.height+afloatY14*height, afloatX14*width+freightW*width, afloatY14*height) ;
    _freightBtn.tag = 10000;
    _freightBtn.selected = NO;
    [_freightBtn setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
    [_freightBtn setTitle:@"免运费" forState:UIControlStateNormal];
    [_freightBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    _freightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    _freightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _freightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_freightBtn];

    //促销
    float proX = 124.0/750.0;
    _promotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _promotionBtn.frame = CGRectMake(_freightBtn.frame.size.width + _freightBtn.frame.origin.x+proX*width, _freightBtn.frame.origin.y, afloatX14*width+freightW*width, afloatY14*height) ;
    _promotionBtn.selected = NO;
    [_promotionBtn setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
    [_promotionBtn setTitle:@"促销" forState:UIControlStateNormal];
    [_promotionBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    _promotionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    _promotionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _promotionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_promotionBtn];
    //货到付款
     float payW = 120.0/750.0;
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(_promotionBtn.frame.size.width + _promotionBtn.frame.origin.x+proX*width, _promotionBtn.frame.origin.y, afloatX14*width+payW*width, afloatY14*height) ;

    _payBtn.selected = NO;

    [_payBtn setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
    [_payBtn setTitle:@"货到付款" forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    _payBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    _payBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_payBtn];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
