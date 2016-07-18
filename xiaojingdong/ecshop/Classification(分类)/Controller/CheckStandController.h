//
//  CheckStandController.h
//  ecshop
//
//  Created by jsyh-mac on 16/1/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//
//收银台
#import <UIKit/UIKit.h>

@interface CheckStandController : UIViewController
@property (nonatomic, strong) NSString * jiage;
@property (nonatomic, strong) NSString * orderNs;
@property (nonatomic, strong) NSString * type;//判断从购物车(0)进来还是商品详情(2)进来
@end
