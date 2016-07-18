//
//  SelectHongBaoTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/20.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SelectHongBaoTableViewCell.h"
#import "UIColor+Hex.h"
@implementation SelectHongBaoTableViewCell
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
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, Width - aX24*Width-12, 16)];
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:_label];
    //右侧图片
    _button = [[UIButton alloc]initWithFrame:CGRectMake(Width-Width*aX24-20, aY24*Height, 12, 20)];
    [self addSubview:_button];
 
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
