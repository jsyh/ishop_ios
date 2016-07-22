//
//  AddressViewController.h
//  ecshop
//
//  Created by Jin on 15/12/4.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController

@property(nonatomic,strong)NSDictionary *tempDic;
@property (nonatomic, copy) NSString * panduanid;//判断是否从创建订单传过来的
@end
