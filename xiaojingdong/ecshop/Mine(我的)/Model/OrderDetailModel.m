//
//  OrderDetailModel.m
//  ecshop
//
//  Created by Jin on 16/5/9.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"没有 %@ key",key);
}
-(NSString *)description{
    return [NSString stringWithFormat:@"订单编号:%@",self.orderSN];
}
@end
