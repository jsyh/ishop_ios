//
//  ShopTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/3/31.
//  Copyright © 2016年 jsyh. All rights reserved.
//商品详情商店的cell

#import "ShopTableViewCell.h"
#import "UIColor+Hex.h"
@implementation ShopTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenCenterX = screenWidth/2;
    //店铺头像
    _shopImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 49, 49)];
    _shopImage.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:_shopImage];
    
    
    //店铺名称
    _shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_shopImage.frame.size.width + _shopImage.frame.origin.x + 12, 12, screenWidth - 130, 25)];
    _shopNameLab.font = [UIFont systemFontOfSize:15];
    _shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    _shopNameLab.text = @"骆驼品质";
    [self addSubview:_shopNameLab];
    
    
    //店铺等级
    _shopGradeLab = [[UILabel alloc]initWithFrame:CGRectMake(_shopImage.frame.size.width + _shopImage.frame.origin.x + 12, _shopNameLab.frame.size.height + _shopNameLab.frame.origin.y, screenWidth - 130, 24)];
    _shopGradeLab.font = [UIFont systemFontOfSize:12];
    _shopGradeLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    _shopGradeLab.text = @"三星店铺";
    [self addSubview:_shopGradeLab];
    
    
    //全部宝贝个数
    float swidth = [UIScreen mainScreen].bounds.size.width;
    float width = (swidth/75)*17;
    _allGoodsNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _shopImage.frame.size.height + _shopImage.frame.origin.y + 10, width, 28)];
    _allGoodsNumLab.text = @"12";
    _allGoodsNumLab.textAlignment = NSTextAlignmentCenter;
    _allGoodsNumLab.font = [UIFont systemFontOfSize:14];
    _allGoodsNumLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:_allGoodsNumLab];
    
    //全部宝贝
    UILabel *allGoodsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _allGoodsNumLab.frame.size.height + _allGoodsNumLab.frame.origin.y + 5, width, 27)];
    allGoodsLab.text = @"全部宝贝";
    allGoodsLab.font = [UIFont systemFontOfSize:12];
    allGoodsLab.textAlignment = NSTextAlignmentCenter;
    allGoodsLab.textColor = [UIColor grayColor];
    [self addSubview:allGoodsLab];
    
    //上新宝贝个数
    _GoodsNewNumLab = [[UILabel alloc]initWithFrame:CGRectMake(_allGoodsNumLab.frame.size.width + _allGoodsNumLab.frame.origin.x, _allGoodsNumLab.frame.origin.y, width, 28)];
    _GoodsNewNumLab.text = @"12";
    _GoodsNewNumLab.textAlignment = NSTextAlignmentCenter;
    _GoodsNewNumLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_GoodsNewNumLab];
    
    //上新宝贝
    UILabel *goodsNewLab = [[UILabel alloc]initWithFrame:CGRectMake(allGoodsLab.frame.size.width + allGoodsLab.frame.origin.x , allGoodsLab.frame.origin.y, width, 27)];
    goodsNewLab.text = @"上新宝贝";
    goodsNewLab.font = [UIFont systemFontOfSize:12];
    goodsNewLab.textAlignment = NSTextAlignmentCenter;
    goodsNewLab.textColor = [UIColor grayColor];
    [self addSubview:goodsNewLab];
    
    
    
    //关注人数个数
    _careNumLab = [[UILabel alloc]initWithFrame:CGRectMake(_GoodsNewNumLab.frame.size.width + _GoodsNewNumLab.frame.origin.x , _allGoodsNumLab.frame.origin.y, width, 28)];
    _careNumLab.text = @"12";
    _careNumLab.textAlignment = NSTextAlignmentCenter;
    _careNumLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_careNumLab];
    
    //关注人数
    UILabel *careLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsNewLab.frame.size.width + goodsNewLab.frame.origin.x , allGoodsLab.frame.origin.y, width, 27)];
    careLab.text = @"关注人数";
    careLab.font = [UIFont systemFontOfSize:12];
    careLab.textAlignment = NSTextAlignmentCenter;
    careLab.textColor = [UIColor grayColor];
    [self addSubview:careLab];
    
    
    //画线
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(_allGoodsNumLab.frame.origin.x+_allGoodsNumLab.frame.size.width+2, _allGoodsNumLab.frame.origin.y, 1, _allGoodsNumLab.frame.size.height + allGoodsLab.frame.size.height+5)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(_GoodsNewNumLab.frame.origin.x+_GoodsNewNumLab.frame.size.width+2, _GoodsNewNumLab.frame.origin.y, 1, view1.frame.size.height)];
    view2.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self addSubview:view2];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(_careNumLab.frame.origin.x+_careNumLab.frame.size.width+2, _careNumLab.frame.origin.y, 1, view1.frame.size.height)];
    view3.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self addSubview:view3];
    
   float goodsNewLabWidth = swidth - width*3;
    //宝贝描述
    UILabel *goodsLab = [[UILabel alloc]initWithFrame:CGRectMake(view3.frame.origin.x+1 , _careNumLab.frame.origin.y, goodsNewLabWidth/2, 18)];
    goodsLab.font = [UIFont systemFontOfSize:12];
    goodsLab.text = @"宝贝描述";
    goodsLab.textAlignment = NSTextAlignmentCenter;
    goodsLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:goodsLab];
    //宝贝描述评分
    _goodsDesLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsLab.frame.size.width+goodsLab.frame.origin.x+6, goodsLab.frame.origin.y, goodsNewLabWidth/2-12, 13)];
    _goodsDesLab.font = [UIFont systemFontOfSize:12];
    _goodsDesLab.text = @"5.0";
    _goodsDesLab.textAlignment = NSTextAlignmentCenter;
    _goodsDesLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    [self addSubview:_goodsDesLab];
    
    //卖家服务
    UILabel *serviceLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsLab.frame.origin.x, goodsLab.frame.origin.y + goodsLab.frame.size.height, goodsLab.frame.size.width, 18)];
    serviceLab.font = [UIFont systemFontOfSize:12];
    serviceLab.text = @"卖家服务";
   
    serviceLab.textAlignment = NSTextAlignmentCenter;
    serviceLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:serviceLab];
    //卖家服务评分
    _serviceDesLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsLab.frame.size.width+goodsLab.frame.origin.x+6, serviceLab.frame.origin.y, _goodsDesLab.frame.size.width, 18)];
    _serviceDesLab.font = [UIFont systemFontOfSize:12];

    _serviceDesLab.text = @"5.0";
    _serviceDesLab.textAlignment = NSTextAlignmentCenter;
    _serviceDesLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    [self addSubview:_serviceDesLab];
    
    
    
    
    //物流服务
    UILabel *logisticsLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsLab.frame.origin.x , serviceLab.frame.origin.y + serviceLab.frame.size.height, goodsLab.frame.size.width, 18)];
    logisticsLab.font = [UIFont systemFontOfSize:12];
    logisticsLab.text = @"物流服务";
    logisticsLab.textAlignment = NSTextAlignmentCenter;
    logisticsLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:logisticsLab];
    //物流服务评分
    _logisticsDesLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsLab.frame.size.width+goodsLab.frame.origin.x+6, logisticsLab.frame.origin.y, _goodsDesLab.frame.size.width, 18)];
    _logisticsDesLab.font = [UIFont systemFontOfSize:12];
    _logisticsDesLab.text = @"5.0";
    _logisticsDesLab.textAlignment = NSTextAlignmentCenter;
    _logisticsDesLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    [self addSubview:_logisticsDesLab];
    
    //联系客服按钮
    _customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customBtn.frame = CGRectMake(screenCenterX - 120, careLab.frame.size.height + careLab.frame.origin.y +10, 109, 21) ;
    [_customBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [_customBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    _customBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    _customBtn.layer.cornerRadius = 4;
    _customBtn.layer.masksToBounds = YES;
    _customBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_customBtn.layer setBorderWidth:1];
    [self addSubview:_customBtn];
    //进店逛逛按钮
    _shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shopBtn.frame = CGRectMake(screenCenterX + 11, careLab.frame.size.height + careLab.frame.origin.y +10, 109, 21) ;
    [_shopBtn setTitle:@"进店逛逛" forState:UIControlStateNormal];
    [_shopBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    _shopBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    _shopBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _shopBtn.layer.cornerRadius = 4;
    _shopBtn.layer.masksToBounds = YES;
    [_shopBtn.layer setBorderWidth:1];
    [self addSubview:_shopBtn];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    
    // Configure the view for the selected state
}

@end
