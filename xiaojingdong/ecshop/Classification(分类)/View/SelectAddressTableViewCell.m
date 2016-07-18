//
//  SelectAddressTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/20.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SelectAddressTableViewCell.h"
#import "UIColor+Hex.h"
@implementation SelectAddressTableViewCell
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
  
    //左侧图片
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, 12, 20)];
    imgView.image = [UIImage imageNamed:@"goods_detail_address"];
    [self addSubview:imgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+aX24*Width,3+ aY24*Height, 200, 16)];
    label.text = @"请选择收货地址";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:label];
    //右侧图片
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Width-Width*aX24-20, aY24*Height, 12, 20)];
    [button setImage:[UIImage imageNamed:@"goods_detail_go"] forState:UIControlStateNormal];
    [self addSubview:button];
    //底部图片
    float aH92 = 92.0/1334.0;
    UIImageView *imgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, aH92*Height, Width, 6)];
    imgView3.image = [UIImage imageNamed:@"goods_detail_address_background"];
    [self addSubview:imgView3];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
