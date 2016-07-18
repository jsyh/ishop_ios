//
//  goodsModel.h
//  ecshop
//
//  Created by Jin on 15/12/25.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsModel : NSObject
@property (nonatomic,strong)NSString *goods_id;
@property (nonatomic,strong)NSString *goods_img;
@property (nonatomic,strong)NSString *goods_name;
@property (nonatomic,strong)NSString *goods_price;
@property (nonatomic,assign)int number;
@property (nonatomic,strong)NSString *rec_id;
@property (nonatomic,strong)goodsModel *model;

/**
 *   商品详情用
 *   attrName    可选属性中的大类
 *   attrValue   可选属性中的小类
 *   attrPrice   可选属性中的价格
 *   attrID      可选属性中的id
 *   goodsAttrID 可选属性中的一级类名id
 */
@property (nonatomic,strong)NSString *attrName;
@property (nonatomic,strong)NSString *attrValue;
@property (nonatomic,strong)NSString *attrPrice;
@property (nonatomic,strong)NSString *attrID;
@property (nonatomic,strong)NSString *goodsAttrID;
@property (nonatomic, assign) BOOL modelSelected;

//商品id对应的库存
@property(nonatomic,strong)NSString *inventoryNumber;
//存放id
@property(nonatomic,strong)NSMutableArray *inventoryArr;


@end
