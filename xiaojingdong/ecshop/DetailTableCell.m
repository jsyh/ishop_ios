//
//  DetailTableCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/11.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "DetailTableCell.h"
#import "UIColor+Hex.h"
@implementation DetailTableCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self creatSubview];
    }
    return self;
}
-(void)creatSubview
{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    _lab1=[[UILabel alloc]initWithFrame:CGRectMake(12,12, screenWidth - 75, 75)];
    _lab1.numberOfLines=0;
    
    _lab1.font=[UIFont systemFontOfSize:19];
    _lab1.textColor=[UIColor colorWithHexString:@"#43464c"];
    _lab1.textAlignment=NSTextAlignmentNatural;
    [self addSubview:_lab1];
    //商品名称与分享中间的线
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(_lab1.frame.size.width+_lab1.frame.origin.x+15, _lab1.frame.origin.y+6, 1, _lab1.frame.size.height-12)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self addSubview:view1];
    //分享按钮
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(view1.frame.size.width + view1.frame.origin.x , _lab1.frame.origin.y, screenWidth - view1.frame.origin.x, _lab1.frame.size.height);
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"goods_detail_share"] forState:UIControlStateNormal];
     _shareBtn.titleLabel.font=[UIFont systemFontOfSize:10];
    _shareBtn.titleEdgeInsets=UIEdgeInsetsMake(28,-24, 0, 6);
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    _shareBtn.imageEdgeInsets=UIEdgeInsetsMake(-10, 5, 10, -5);
    [_shareBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
    [self addSubview:_shareBtn];
    
    
    _monSign=[[UILabel alloc]initWithFrame:CGRectMake(12, _lab1.frame.size.height+_lab1.frame.origin.y+17, 19, 19)];
    _monSign.textColor=[UIColor colorWithHexString:@"#ff5000"];
    _monSign.font=[UIFont systemFontOfSize:19];
    [self addSubview:_monSign];
    _lab2=[[UILabel alloc]initWithFrame:CGRectMake(_monSign.frame.size.width+_monSign.frame.origin.x, _lab1.frame.size.height+_lab1.frame.origin.y+12, 100, 24)];
    _lab2.font=[UIFont systemFontOfSize:15];
    _lab2.textColor=[UIColor colorWithHexString:@"#ff5000"];
    [self addSubview:_lab2];
    
    float width = (screenWidth - 40) /3;
    //评价个数
    _evaluateNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, _lab2.frame.size.height + _lab2.frame.origin.y + 18, width, 12)];
    _evaluateNumLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _evaluateNumLab.text = @"评价2条";
    _evaluateNumLab.textAlignment = NSTextAlignmentLeft;
    _evaluateNumLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_evaluateNumLab];
    //销量个数
    _saleNumLab = [[UILabel alloc]initWithFrame:CGRectMake(_evaluateNumLab.frame.size.width + _evaluateNumLab.frame.origin.x + 10, _evaluateNumLab.frame.origin.y, width, 12)];
    _saleNumLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _saleNumLab.text = @"销售2件";
    _saleNumLab.textAlignment = NSTextAlignmentCenter;
    _saleNumLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_saleNumLab];
    //地址
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(_saleNumLab.frame.size.width + _saleNumLab.frame.origin.x + 10, _evaluateNumLab.frame.origin.y, width, 12)];
    _addressLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _addressLab.text = @"广东";
    _addressLab.textAlignment = NSTextAlignmentRight;
    _addressLab.font = [UIFont systemFontOfSize:12];
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
