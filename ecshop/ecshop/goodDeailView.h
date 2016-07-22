//
//  goodDeailView.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/15.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "Sliderbar.h"

@interface goodDeailView : Sliderbar

@property (nonatomic, strong)UIImageView * iconImage;
@property (nonatomic, strong)UILabel * price;//价格
@property (nonatomic, strong)UILabel * bianHao;//商品编号
@property (nonatomic, copy  )NSString * recevieId;
@property (nonatomic, copy) UILabel * attrLab;//颜色ID
@property (nonatomic, copy) NSString * numuBer;//购买数量
@property (nonatomic, strong) NSMutableDictionary * attDic;
@property (nonatomic, strong) UILabel * yanse;
@property (nonatomic, strong) UILabel * shuliang;
@property (nonatomic) double changePrice;//价格增减的区间
@property(nonatomic, copy)  void (^showText)(NSString * text);
@end
