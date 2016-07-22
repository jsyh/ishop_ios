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
@end
