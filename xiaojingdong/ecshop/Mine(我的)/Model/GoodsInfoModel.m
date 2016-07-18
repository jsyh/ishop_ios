//
//  GoodsInfoModel.m
//  ecshop
//
//  Created by Jin on 16/5/9.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"没有 %@ key",key);
}
-(NSString *)description{
    return [NSString stringWithFormat:@"订单编号:%@",self.supplierName];
}
@end
