//
//  AddressModel.h
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
//收货地址id
@property(nonatomic,strong)NSString *address_id;
//详细的收货地址
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *telnumber;
@property(nonatomic,strong)NSString *username;
//是否默认收货地址0不是默认1是默认
@property(nonatomic,strong)NSString *is_default;
@property(nonatomic,strong)AddressModel *model;
@end
