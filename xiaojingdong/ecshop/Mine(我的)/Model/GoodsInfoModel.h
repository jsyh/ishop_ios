//
//  GoodsInfoModel.h
//  ecshop
//
//  Created by Jin on 16/5/9.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfoModel : NSObject
@property(nonatomic,copy) NSString *supplierName;
@property(nonatomic,strong) NSMutableArray *goodsInfoArray;
@end
