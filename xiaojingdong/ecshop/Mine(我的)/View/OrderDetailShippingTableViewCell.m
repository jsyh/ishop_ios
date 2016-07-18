//
//  OrderDetailShippingTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/5/9.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "OrderDetailShippingTableViewCell.h"
#import "UIColor+Hex.h"
@implementation OrderDetailShippingTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview{
    float width = [UIScreen mainScreen].bounds.size.width;
 
    //订单编号
    _lab1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 200, 10)];
    _lab1.font = [UIFont systemFontOfSize:10];
    _lab1.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_lab1];
    //创建时间
    _lab2 = [[UILabel alloc]initWithFrame:CGRectMake(12, _lab1.frame.size.height+_lab1.frame.origin.y+6, 200, 10)];
    _lab2.font = [UIFont systemFontOfSize:10];
    _lab2.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_lab2];
    //付款时间
    _lab3 = [[UILabel alloc]initWithFrame:CGRectMake(12, _lab2.frame.size.height+_lab2.frame.origin.y+6, 200, 10)];
    _lab3.font = [UIFont systemFontOfSize:10];
    _lab3.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_lab3];
    //发货时间
    _lab4 = [[UILabel alloc]initWithFrame:CGRectMake(12, _lab3.frame.size.height+_lab3.frame.origin.y+6, 200, 10)];
    _lab4.font = [UIFont systemFontOfSize:10];
    _lab4.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_lab4];
    //复制按钮
    _coppyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coppyBtn.frame = CGRectMake(width-12-60, 12, 60, 20);
    [_coppyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_coppyBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _coppyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _coppyBtn.layer.borderWidth = 0.5f;
    _coppyBtn.layer.cornerRadius = 3;
    _coppyBtn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    _coppyBtn.layer.masksToBounds = YES;
    [self addSubview:_coppyBtn];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
