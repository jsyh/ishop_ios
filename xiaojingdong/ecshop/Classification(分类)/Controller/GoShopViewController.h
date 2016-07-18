//
//  GoShopViewController.h
//  ecshop
//
//  Created by Jin on 16/4/6.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoShopViewController : UIViewController
@property(nonatomic,strong)NSString *shopUrl;//店铺的地址
@property(nonatomic,assign)int attention;//是否关注
@property(nonatomic,strong)NSString *shopID;//店铺id
@end
