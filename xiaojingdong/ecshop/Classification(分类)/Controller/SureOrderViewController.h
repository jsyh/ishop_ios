//
//  SureOrderViewController.h
//  ecshop
//
//  Created by Jin on 16/4/20.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureOrderViewController : UIViewController
@property(nonatomic,strong)NSString *goodsID;
@property(nonatomic,strong)NSString *propertyID;
@property(nonatomic,strong)NSString *goodsNumber;
@property(nonatomic,strong)NSString *type;//判断从购物车(0)进来还是商品详情(2)进来，积分(1)
@property(nonatomic,strong)NSString *points;//商品的积分

@end
