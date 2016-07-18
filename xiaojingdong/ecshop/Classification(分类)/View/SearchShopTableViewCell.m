//
//  SearchShopTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/13.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SearchShopTableViewCell.h"
#import "UIColor+Hex.h"
@implementation SearchShopTableViewCell
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
    //店铺头像
    _shopImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 49, 49)];
    _shopImage.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:_shopImage];
    UILabel *goShopLab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 12-75, 12, 75, 27)];
    goShopLab.text = @"进店";
    goShopLab.font = [UIFont systemFontOfSize:13];
    goShopLab.layer.borderWidth = 1;
    goShopLab.textAlignment = NSTextAlignmentCenter;
    goShopLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    goShopLab.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    goShopLab.layer.cornerRadius = 5;
    goShopLab.layer.masksToBounds = YES;
    [self addSubview:goShopLab];
    
    //店铺名称
    _shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_shopImage.frame.size.width + _shopImage.frame.origin.x + 12, 12, screenWidth - 180, 14)];
    _shopNameLab.font = [UIFont systemFontOfSize:14];
    _shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _shopNameLab.text = @"骆驼品质";
    _shopNameLab.textAlignment = NSTextAlignmentLeft;
//    _shopNameLab.backgroundColor = [UIColor redColor];
    [self addSubview:_shopNameLab];
    
    
    //店铺等级
    _shopGradeLab = [[UILabel alloc]initWithFrame:CGRectMake(_shopImage.frame.size.width + _shopImage.frame.origin.x + 12, _shopNameLab.frame.size.height + _shopNameLab.frame.origin.y+6 , screenWidth - 180, 18)];
    _shopGradeLab.font = [UIFont systemFontOfSize:10];
//    _shopGradeLab.backgroundColor = [UIColor blueColor];
    _shopGradeLab.textAlignment = NSTextAlignmentLeft;
    _shopGradeLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    _shopGradeLab.text = @"三星店铺";
    [self addSubview:_shopGradeLab];
    
    //销量 和宝贝个数
    _salesNumLab = [[UILabel alloc]initWithFrame:CGRectMake(_shopGradeLab.frame.origin.x, _shopGradeLab.frame.size.height+_shopGradeLab.frame.origin.y, 300, 18)];
    _salesNumLab.text = @"销量 100000 件 共 12 件宝贝";
    _salesNumLab.font = [UIFont systemFontOfSize:10];
    _salesNumLab.textAlignment = NSTextAlignmentLeft;
    _salesNumLab.textColor = [UIColor colorWithHexString:@"#666666"];
//    _salesNumLab.backgroundColor = [UIColor redColor];
    [self addSubview:_salesNumLab];

    
    
 
  
    
    
//    //画线
//    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(_allGoodsNumLab.frame.origin.x+_allGoodsNumLab.frame.size.width+2, _allGoodsNumLab.frame.origin.y, 1, _allGoodsNumLab.frame.size.height + allGoodsLab.frame.size.height+5)];
//    view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
//    [self addSubview:view1];
//    
  
     //进店逛逛按钮
    _shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _shopBtn.frame = CGRectMake(screenCenterX + 11, careLab.frame.size.height + careLab.frame.origin.y +10, 109, 21) ;
    [_shopBtn setTitle:@"进店逛逛" forState:UIControlStateNormal];
    [_shopBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    _shopBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    _shopBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _shopBtn.layer.cornerRadius = 4;
    _shopBtn.layer.masksToBounds = YES;
    [_shopBtn.layer setBorderWidth:1];
    [self addSubview:_shopBtn];
    
    //放图片的view
    _imgView = [[UIView alloc]initWithFrame:CGRectMake(0, _salesNumLab.frame.origin.y+_salesNumLab.frame.size.height, screenWidth, 100)];
    _imgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_imgView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
