//
//  SureOrderController.h
//  ecshop
//
//  Created by jsyh-mac on 16/1/6.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureOrderController : UIViewController
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString * secondAddressId;//传递过来的id
@property (nonatomic, copy) NSString * sureId; //商品id
@property (nonatomic, copy) NSString * smallId;//商品属性id
@property (nonatomic, strong) UILabel * NumLab;//购买数量
@property (nonatomic, strong) UILabel * yunfei;//运费的
@property (nonatomic, copy) NSString * yunfeiID;//运费id
@property (nonatomic, strong) UILabel * yunfeiNAme;//运费的名字
@property (nonatomic, copy) NSString *priccc;//商品金额
@property (nonatomic, strong) UILabel * goodPrice;//商品金额
@property (nonatomic, copy) NSString * shopNum;//购买的数量
@property (nonatomic, copy) NSString * hongbaoNam;//红包名字
@property (nonatomic, copy) NSString * hongMuch;//红包面额
@property (nonatomic, copy) NSString * hongDiyong;//可以抵用的面额
@property (nonatomic, copy) NSString * hongId;//红包id
@property (nonatomic, copy) NSString * typeID;//类型id
@property (nonatomic, copy) NSString * userNamm;//用户名
@property (nonatomic, copy) NSString * teleNum;//电话
@property (nonatomic, copy) NSString * messageee;//地址信息
//接收物品id数组
@property (nonatomic,strong)NSMutableArray *tempArr;
@end
