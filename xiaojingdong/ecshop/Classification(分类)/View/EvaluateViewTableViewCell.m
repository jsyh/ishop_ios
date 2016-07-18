//
//  EvaluateViewTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/5.
//  Copyright © 2016年 jsyh. All rights reserved.
//评价页面所用

#import "EvaluateViewTableViewCell.h"
#import "UIColor+Hex.h"
@implementation EvaluateViewTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)creatSubview{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;

    //用户头像
    _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 21, 21)];
    _userImage.backgroundColor = [UIColor orangeColor];
    float cornerRadius = _userImage.frame.size.width/2.0;
    _userImage.layer.cornerRadius = cornerRadius;
    _userImage.layer.masksToBounds = YES;
    _userImage.image = [UIImage imageNamed:@"goods_detail_user_photo"];
    [self addSubview:_userImage];
    //用户名
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_userImage.frame.size.width + _userImage.frame.origin.x + 6, 16, 200, 14)];
    _userNameLab.font = [UIFont systemFontOfSize:14];
    _userNameLab.text = @"111";
    _userNameLab.textColor = [UIColor colorWithHexString:@"656973"];
    [self addSubview:_userNameLab];
    
    //评价内容
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(12, _userNameLab.frame.size.height + _userNameLab.frame.origin.y + 12, screenWidth - 20, 50)];
    _contentLab.text = @"评论内容111";
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont systemFontOfSize:12];
    _contentLab.textColor = [UIColor colorWithHexString:@"#656973"];
    [self addSubview:_contentLab];
    
    
    
   
    //评论时间
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(12, _contentLab.frame.size.height + _contentLab.frame.origin.y + 5, 60, 30)];
    _timeLab.font = [UIFont systemFontOfSize:10];
    _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLab.text = @"2011-10-01";
    [self addSubview:_timeLab];
    
    //商品属性
    
    _goodsPropertyLab = [[UILabel alloc]initWithFrame:CGRectMake(_timeLab.frame.size.width + _timeLab.frame.origin.x + 6, _contentLab.frame.size.height + _contentLab.frame.origin.y + 5, screenWidth - 124, 30)];
    _goodsPropertyLab.font = [UIFont systemFontOfSize:10];
    _goodsPropertyLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _goodsPropertyLab.text = @"颜色:灰色";
    [self addSubview:_goodsPropertyLab];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 129, screenWidth, 1)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self addSubview:view1];
}

@end
