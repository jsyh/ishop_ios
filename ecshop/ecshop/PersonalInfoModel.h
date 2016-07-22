//
//  PersonalInfoModel.h
//  ecshop
//
//  Created by Jin on 15/12/21.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoModel : NSObject
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *nick_name;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *mobile;
//积分
@property(nonatomic,strong)NSString *integration;
//关注数量
@property(nonatomic,strong)NSString *attention;
//钱
@property (nonatomic,strong)NSString *user_money;
@property(nonatomic,strong)PersonalInfoModel *model;
@property (nonatomic,strong)NSString *birthday;
@property (nonatomic,strong)NSString *email;
//待付款数量
@property (nonatomic,strong)NSString *pay;
//待发货数量
@property (nonatomic,strong)NSString *shipping_send;
//购物车数量
@property (nonatomic,strong)NSString *cart_num;
@end
