//
//  OrderDetailAddressTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/5/9.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "OrderDetailAddressTableViewCell.h"
#import "UIColor+Hex.h"
@implementation OrderDetailAddressTableViewCell
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
    float aY78 = 78.0/1334.0;
    //左侧图片
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(aX24*Width, aY78*Height, 12, 20)];
    imgView.image = [UIImage imageNamed:@"goods_detail_address"];
    [self addSubview:imgView];
    //收货人
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+aX24*Width, aY24*Height, 150, 15)];
    _nameLab.text = @"收货人：安安";
    _nameLab.font = [UIFont systemFontOfSize:15];
    _nameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:_nameLab];
    //默认图片
    float aX66 = 66.0/750.0;
    float aW44 = 44.0/750.0;
    UILabel *defaultLab = [[UILabel alloc]initWithFrame:CGRectMake(Width-Width*aX66-aW44*Width, aY24*Height, aW44*Width, aY24*Height)];
    [self addSubview:defaultLab];
    //    UIImageView *defaultImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width-Width*aX66-aW44*Width, aY24*Height, aW44*Width, aY24*Height)];
    //    defaultImage.image = [UIImage imageNamed:@""];
    //    [self addSubview:defaultImage];
    //电话
    _telLab = [[UILabel alloc]initWithFrame:CGRectMake(Width-defaultLab.frame.size.width - Width*aX66-112, aY24*Height, 100, 15)];
    _telLab.text = @"18512953344";
    _telLab.font = [UIFont systemFontOfSize:15];
    _telLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:_telLab];
    //收货地址
    float aH68 = 68.0/1334.0;
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x, _nameLab.frame.origin.y+_nameLab.frame.size.height+aY24*Height, Width-_nameLab.frame.origin.x-Width*aX66, aH68*Height)];
    _addressLab.font = [UIFont systemFontOfSize:15];
    _addressLab.numberOfLines = 2;
    _addressLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _addressLab.text =@"aassa";
    [self addSubview:_addressLab];

    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
