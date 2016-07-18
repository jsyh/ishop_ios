//
//  SelectGoodsTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/20.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SelectGoodsTableViewCell.h"
#import "UIColor+Hex.h"
@implementation SelectGoodsTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview{
    float aX24 = 24.0/750.0;
    float aY24 = 24.0/1334.0;
    float aW180 = 180.0/750.0;
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];

    //左侧图片
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, aW180*Width, aW180*Width)];
    [self addSubview:_imgView];
    //名字
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.frame.size.width+_imgView.frame.origin.x+aX24*Width, aY24*Height, Width-Width*aX24*3-aW180*Width, 40)];
    _nameLab.numberOfLines = 0;
    _nameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _nameLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:_nameLab];
    //价格
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x, _imgView.frame.size.height + _imgView.frame.origin.y - 15, 100, 15)];
    _priceLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    [self addSubview:_priceLab];
    
    //商品属性
    _attributeLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x, _priceLab.frame.origin.y-aY24*Height-6, _nameLab.frame.size.width, 12)];
    _attributeLab.text = @"颜色：黑色";
    _attributeLab.font = [UIFont systemFontOfSize:12];
    _attributeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_attributeLab];
    //数量
    _numLab = [[UILabel alloc]initWithFrame:CGRectMake(Width-50-aX24*Width, _priceLab.frame.origin.y, 50, 12)];
    _numLab.font = [UIFont systemFontOfSize:12];
    _numLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _numLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_numLab];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
