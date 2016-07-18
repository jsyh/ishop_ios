//
//  ShopModel.h
//  ecshop
//
//  Created by Jin on 16/4/12.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property(nonatomic,strong)NSString *supplierID;
@property(nonatomic,strong)NSString *shopRage;  //店铺等级
@property(nonatomic,strong)NSString *shopLogo;  //店铺logo
@property(nonatomic,strong)NSString *shopName;  //店铺名
@property(nonatomic,strong)NSString *address;   //所在地
@property(nonatomic,strong)NSString *goodsThumb;//店铺图片
@property(nonatomic,strong)NSString *goodsNum;  //店铺的商品数量
@property(nonatomic,strong)NSString *shopUrl;   //店铺链接
@property(nonatomic,strong)NSString *sales;     //店铺销量
@property(nonatomic,strong)NSArray *goodsArr;//存放商品信息
@property(nonatomic,assign)int attention;//是否关注
@property(nonatomic,strong)ShopModel *model;
@end
