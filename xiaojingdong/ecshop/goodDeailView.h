//
//  goodDeailView.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/15.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "Sliderbar.h"

@interface goodDeailView : Sliderbar

@property (nonatomic, strong) UIImageView * iconImage;
@property (nonatomic, strong) UILabel * price;//价格
@property (nonatomic, strong) UILabel * bianHao;//商品编号
@property (nonatomic, strong) NSString * recevieId;
@property (nonatomic, strong) UILabel * attrLab;//颜色ID
@property (nonatomic, strong) NSString * numuBer;//购买数量
@property (nonatomic, strong) NSMutableDictionary * attDic;
@property (nonatomic, strong) UILabel * yanse;
@property (nonatomic, strong) UILabel * shuliang;
@property (nonatomic, assign) double changePrice;//价格增减的区间
@property (nonatomic, strong)  void (^showText)(NSString * text);

@property (nonatomic,strong)NSString *goodID;
@property (nonatomic,strong)UILabel *repertory;//库存
@property (nonatomic,strong)UILabel *colorNumLab;//颜色数量
@property (nonatomic,strong)NSString *type;//1从购物车进来 2从直接购买进来  0直接进来 3从积分进来

@end
