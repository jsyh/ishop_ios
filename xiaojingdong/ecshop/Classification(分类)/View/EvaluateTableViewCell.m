//
//  EvaluateTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/3/30.
//  Copyright © 2016年 jsyh. All rights reserved.
//商品详情评论的cell

#import "EvaluateTableViewCell.h"
#import "UIColor+Hex.h"

@implementation EvaluateTableViewCell

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
-(void)creatSubview{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenCenterX = screenWidth/2;
    //宝贝评价
    _totleEvaluateLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, screenWidth - 20, 15)];
    _totleEvaluateLab.text = @"宝贝评价";
    _totleEvaluateLab.font = [UIFont systemFontOfSize:15];
    _totleEvaluateLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:_totleEvaluateLab];
    /**
     *  差评 中评 好评
     */
    float widthLab = (screenWidth - 48)/3;
    _badLab = [[UILabel alloc]initWithFrame:CGRectMake(12, _totleEvaluateLab.frame.size.height + _totleEvaluateLab.frame.origin.y + 12, widthLab, 21)];
    _badLab.text = @"差评(0)";
    _badLab.textAlignment = NSTextAlignmentCenter;
    _badLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _badLab.font = [UIFont systemFontOfSize:12];
    _badLab.layer.cornerRadius = 5;
    _badLab.layer.masksToBounds = YES;
    _badLab.backgroundColor = [UIColor colorWithHexString:@"#FFECE5"];
    [self addSubview:_badLab ];
    
    _midLab = [[UILabel alloc]initWithFrame:CGRectMake(_badLab.frame.size.width + _badLab.frame.origin.x + 12, _totleEvaluateLab.frame.size.height + _totleEvaluateLab.frame.origin.y + 12, widthLab, 21)];
    _midLab.text = @"中评(0)";
    _midLab.font = [UIFont systemFontOfSize:12];
    _midLab.layer.cornerRadius = 5;
    _midLab.layer.masksToBounds = YES;
    _midLab.textAlignment = NSTextAlignmentCenter;
    _midLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _midLab.backgroundColor = [UIColor colorWithHexString:@"#FFECE5"];
    [self addSubview:_midLab ];
    
    _goodLab = [[UILabel alloc]initWithFrame:CGRectMake(_midLab.frame.size.width + _midLab.frame.origin.x + 12, _totleEvaluateLab.frame.size.height + _totleEvaluateLab.frame.origin.y + 12, widthLab, 21)];
    _goodLab.text = @"好评(0)";
    _goodLab.font = [UIFont systemFontOfSize:12];
    _goodLab.layer.cornerRadius = 5;
    _goodLab.layer.masksToBounds = YES;
    _goodLab.textAlignment = NSTextAlignmentCenter;
    _goodLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _goodLab.backgroundColor = [UIColor colorWithHexString:@"#FFECE5"];
    [self addSubview:_goodLab ];
    
    //用户头像
    _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, _badLab.frame.size.height + _badLab.frame.origin.y +12, 21, 21)];
    _userImage.backgroundColor = [UIColor orangeColor];
    float cornerRadius = _userImage.frame.size.width/2.0;
    _userImage.layer.cornerRadius = cornerRadius;
    _userImage.layer.masksToBounds = YES;
    _userImage.image = [UIImage imageNamed:@"goods_detail_user_photo"];
    [self addSubview:_userImage];
    //用户名
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_userImage.frame.size.width + _userImage.frame.origin.x + 6, _badLab.frame.size.height + _badLab.frame.origin.y +15, 200, 14)];
    _userNameLab.font = [UIFont systemFontOfSize:14];
    _userNameLab.text = @"111";
    _userNameLab.textColor = [UIColor colorWithHexString:@"656973"];
    [self addSubview:_userNameLab];
    
    //评价内容
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(12, _userNameLab.frame.size.height + _userNameLab.frame.origin.y + 12, screenWidth - 20, 40)];
    _contentLab.text = @"评论内容111";
    _contentLab.numberOfLines = 0;

    _contentLab.font = [UIFont systemFontOfSize:12];
    _contentLab.textColor = [UIColor colorWithHexString:@"#656973"];
    [self addSubview:_contentLab];
    
    
    
    //商品属性
    
    _goodsPropertyLab = [[UILabel alloc]initWithFrame:CGRectMake(12, _contentLab.frame.size.height + _contentLab.frame.origin.y + 5, screenWidth - 20, 10)];
    _goodsPropertyLab.font = [UIFont systemFontOfSize:10];
    _goodsPropertyLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _goodsPropertyLab.text = @"颜色:灰色";
    [self addSubview:_goodsPropertyLab];
    
    
    //查看全部评论按钮
    _allCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allCommentBtn.frame = CGRectMake(screenCenterX - 54, _goodsPropertyLab.frame.size.height + _goodsPropertyLab.frame.origin.y + 12, 109, 21) ;
    [_allCommentBtn setTitle:@"查看全部评论" forState:UIControlStateNormal];
    _allCommentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_allCommentBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    _allCommentBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    _allCommentBtn.layer.cornerRadius = 4;
    _allCommentBtn.layer.masksToBounds = YES;
    [_allCommentBtn.layer setBorderWidth:1];
    [self addSubview:_allCommentBtn];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

@end
