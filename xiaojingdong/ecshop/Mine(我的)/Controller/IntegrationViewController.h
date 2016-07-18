//
//  IntegrationViewController.h
//  ecshop
//
//  Created by Jin on 16/4/26.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegrationViewController : UIViewController
@property(nonatomic,strong)NSString *integrationStr;
@property(nonatomic,strong)NSString *qd;//0未签到 1已签到
@property(nonatomic,strong)NSString *points;
@property(nonatomic,strong)NSString *type;//0为签到按钮 1为积分按钮
@end
