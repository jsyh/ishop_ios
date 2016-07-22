//
//  goodsModel.m
//  ecshop
//
//  Created by Jin on 15/12/25.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "goodsModel.h"

@implementation goodsModel
-(void)setModel:(goodsModel *)model{
    self.goods_id = model.goods_id;
    self.goods_img = model.goods_img;
    self.goods_name = model.goods_name;
    self.goods_price = model.goods_price;
    self.number = model.number;
    self.rec_id = model.rec_id;
}
@end
