//
//  RegisterPasswordViewController.h
//  ecshop
//
//  Created by Jin on 16/4/19.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterPasswordViewController : UIViewController
@property(nonatomic,strong)NSString *code;//接收上一页传来的验证码
@property(nonatomic,strong)NSString *phone;

@end
