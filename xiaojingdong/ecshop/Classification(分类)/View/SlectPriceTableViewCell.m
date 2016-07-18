//
//  SlectPriceTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/14.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SlectPriceTableViewCell.h"
#import "UIColor+Hex.h"
@implementation SlectPriceTableViewCell
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
    float afloatX14 = 28.0/750.0;
    float afloatY18 = 36.0/1334.0;
    float afloatY14 = 28.0/1334.0;
    float afloatW100 = 200.0/750.0;
    float afloatH21 = 42.0/1334.0;
    float afloatW109 = 218.0/750.0;
    UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(afloatX12*width, afloatY18*height, afloatW100*width, afloatH21*height)];
    priceLab.text = @"价格区间(元)";
    priceLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    priceLab.textAlignment = NSTextAlignmentLeft;
    priceLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:priceLab];
    
    _minPriceText = [[UITextField alloc]initWithFrame:CGRectMake(priceLab.frame.size.width + priceLab.frame.origin.x + afloatX12*width, afloatY18*height, afloatW109*width, afloatH21*height)];
    _minPriceText.font = [UIFont systemFontOfSize:12];
    _minPriceText.textColor = [UIColor colorWithHexString:@"#43464c"];
    _minPriceText.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    _minPriceText.layer.cornerRadius = 5;
    _minPriceText.layer.masksToBounds = YES;
    _minPriceText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_minPriceText];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(_minPriceText.frame.size.width+_minPriceText.frame.origin.x+6, _minPriceText.center.y, 10, 2)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:viewLine];
    
    _maxPriceText = [[UITextField alloc]initWithFrame:CGRectMake(viewLine.frame.size.width+viewLine.frame.origin.x+6, _minPriceText.frame.origin.y, afloatW109*width, afloatH21*height)];
    _maxPriceText.font = [UIFont systemFontOfSize:12];
    _maxPriceText.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    _maxPriceText.textColor = [UIColor colorWithHexString:@"#43464c"];
    _maxPriceText.layer.cornerRadius = 5;
    _maxPriceText.layer.masksToBounds = YES;
    _maxPriceText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_maxPriceText];
//    [self keyBack];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
